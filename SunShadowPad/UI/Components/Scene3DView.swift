import SwiftUI
import SceneKit
import UIKit
import simd

/// Interactive 3D site model. One-finger drag orbits (or moves an object in edit mode),
/// pinch zooms, and the sun light casts real shadows from the same solar position as the plan view.
struct Scene3DView: View {
    let scene: SceneDocument
    let moment: Date
    var allowsEditing: Bool = false
    var selectedElement: UUID? = nil
    var selectedTarget: UUID? = nil
    var onSelectElement: ((UUID) -> Void)? = nil
    var onSelectTarget: ((UUID) -> Void)? = nil
    var onMoveElement: ((UUID, Double, Double) -> Void)? = nil
    var onMoveTarget: ((UUID, Double, Double) -> Void)? = nil

    var body: some View {
        Scene3DRepresentable(scene: scene, moment: moment, allowsEditing: allowsEditing,
                             selectedElement: selectedElement, selectedTarget: selectedTarget,
                             onSelectElement: onSelectElement, onSelectTarget: onSelectTarget,
                             onMoveElement: onMoveElement, onMoveTarget: onMoveTarget)
            .background(AppTheme.navy)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(AppTheme.elevated, lineWidth: 1))
    }
}

private struct Scene3DRepresentable: UIViewRepresentable {
    let scene: SceneDocument
    let moment: Date
    let allowsEditing: Bool
    let selectedElement: UUID?
    let selectedTarget: UUID?
    let onSelectElement: ((UUID) -> Void)?
    let onSelectTarget: ((UUID) -> Void)?
    let onMoveElement: ((UUID, Double, Double) -> Void)?
    let onMoveTarget: ((UUID, Double, Double) -> Void)?

    func makeCoordinator() -> Scene3DCoordinator { Scene3DCoordinator() }

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .zero)
        view.scene = context.coordinator.scnScene
        view.backgroundColor = .clear
        view.antialiasingMode = .multisampling4X
        view.preferredFramesPerSecond = 60
        view.rendersContinuously = false
        view.isPlaying = false
        view.allowsCameraControl = false
        view.pointOfView = context.coordinator.cameraNode
        context.coordinator.attach(to: view)
        context.coordinator.update(scene: scene, moment: moment, allowsEditing: allowsEditing,
                                   selectedElement: selectedElement, selectedTarget: selectedTarget,
                                   onSelectElement: onSelectElement, onSelectTarget: onSelectTarget,
                                   onMoveElement: onMoveElement, onMoveTarget: onMoveTarget)
        return view
    }

    func updateUIView(_ view: SCNView, context: Context) {
        context.coordinator.update(scene: scene, moment: moment, allowsEditing: allowsEditing,
                                   selectedElement: selectedElement, selectedTarget: selectedTarget,
                                   onSelectElement: onSelectElement, onSelectTarget: onSelectTarget,
                                   onMoveElement: onMoveElement, onMoveTarget: onMoveTarget)
    }

    static func dismantleUIView(_ view: SCNView, coordinator: Scene3DCoordinator) {
        coordinator.teardown()
    }
}

private enum Scene3DHit {
    static let ground = 1 << 1
    static let objects = 1 << 2
}

@MainActor
final class Scene3DCoordinator: NSObject, UIGestureRecognizerDelegate {
    let scnScene = SCNScene()
    let cameraNode = SCNNode()

    private let contentRoot = SCNNode()
    private let sunLightNode = SCNNode()
    private let fillLightNode = SCNNode()
    private let sunNode = SCNNode()
    private var groundNode: SCNNode?
    private var elementRoots: [UUID: SCNNode] = [:]
    private var targetRoots: [UUID: SCNNode] = [:]
    private weak var view: SCNView?
    private weak var enclosingScrollView: UIScrollView?

    private var currentScene: SceneDocument?
    private var currentMoment: Date?
    private var lastSiteKey = ""
    private var allowsEditing = false
    private var selectedElement: UUID?
    private var selectedTarget: UUID?

    private var center = SIMD3<Float>(0, 0.6, 0)
    private var azimuth = 28.0
    private var elevation = 36.0
    private var radius = 28.0
    private var minimumRadius = 8.0
    private var maximumRadius = 60.0
    private var panStartAzimuth = 28.0
    private var panStartElevation = 36.0
    private var pinchStartRadius = 28.0
    private var drag: ObjectDrag?

    private var onSelectElement: ((UUID) -> Void)?
    private var onSelectTarget: ((UUID) -> Void)?
    private var onMoveElement: ((UUID, Double, Double) -> Void)?
    private var onMoveTarget: ((UUID, Double, Double) -> Void)?

    private struct ObjectDrag {
        let elementID: UUID?
        let targetID: UUID?
        let node: SCNNode
        let startGround: SIMD3<Float>
        let originalX: Double
        let originalY: Double
        var finalX: Double
        var finalY: Double
    }

    override init() {
        super.init()
        configureScene()
    }

    func attach(to view: SCNView) {
        self.view = view
        view.isAccessibilityElement = true
        view.accessibilityTraits = [.allowsDirectInteraction]

        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.maximumNumberOfTouches = 1
        pan.delegate = self
        pan.cancelsTouchesInView = true
        view.addGestureRecognizer(pan)

        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinch.delegate = self
        view.addGestureRecognizer(pinch)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
    }

    func teardown() {
        setEnclosingScroll(enabled: true)
        view = nil
    }

    func update(scene: SceneDocument, moment: Date, allowsEditing: Bool,
                selectedElement: UUID?, selectedTarget: UUID?,
                onSelectElement: ((UUID) -> Void)?, onSelectTarget: ((UUID) -> Void)?,
                onMoveElement: ((UUID, Double, Double) -> Void)?, onMoveTarget: ((UUID, Double, Double) -> Void)?) {
        self.allowsEditing = allowsEditing
        self.onSelectElement = onSelectElement
        self.onSelectTarget = onSelectTarget
        self.onMoveElement = onMoveElement
        self.onMoveTarget = onMoveTarget

        let selectionChanged = self.selectedElement != selectedElement || self.selectedTarget != selectedTarget
        self.selectedElement = selectedElement
        self.selectedTarget = selectedTarget

        let sceneChanged = currentScene != scene
        if sceneChanged || selectionChanged {
            currentScene = scene
            rebuild(scene)
        }

        let siteKey = "\(scene.id.uuidString)|\(scene.width)|\(scene.height)"
        if siteKey != lastSiteKey {
            lastSiteKey = siteKey
            radius = defaultRadius(for: scene)
        }

        if sceneChanged || currentMoment != moment {
            currentMoment = moment
            updateSun(scene: scene, moment: moment)
        }

        clampCamera(for: scene)
        updateCamera()
        view?.accessibilityLabel = "3D model of \(scene.name)"
        view?.accessibilityHint = allowsEditing
            ? "Drag an object to move it on the ground. Drag empty ground to orbit. Pinch to zoom."
            : "Drag to orbit the camera. Pinch to zoom."
    }

    // MARK: Scene setup

    private func configureScene() {
        scnScene.background.contents = SkyTexture.image
        scnScene.fogColor = UIColor(AppTheme.navy)
        scnScene.fogDensityExponent = 1.4

        let camera = SCNCamera()
        camera.fieldOfView = 42
        camera.zNear = 0.1
        camera.zFar = 2_000
        camera.wantsDepthOfField = false
        cameraNode.camera = camera
        scnScene.rootNode.addChildNode(cameraNode)

        let ambient = SCNNode()
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.color = UIColor(red: 0.58, green: 0.70, blue: 0.85, alpha: 1)
        ambientLight.intensity = 560
        ambient.light = ambientLight
        scnScene.rootNode.addChildNode(ambient)

        let fill = SCNLight()
        fill.type = .directional
        fill.color = UIColor(red: 0.62, green: 0.73, blue: 0.92, alpha: 1)
        fill.intensity = 170
        fill.castsShadow = false
        fillLightNode.light = fill
        fillLightNode.eulerAngles = SCNVector3(-0.6, 0.5, 0)
        cameraNode.addChildNode(fillLightNode)

        let sunlight = SCNLight()
        sunlight.type = .directional
        sunlight.color = UIColor(red: 1.0, green: 0.93, blue: 0.79, alpha: 1)
        sunlight.intensity = 1_200
        sunlight.castsShadow = true
        sunlight.shadowMode = .forward
        sunlight.shadowColor = UIColor(white: 0, alpha: 0.72)
        sunlight.shadowRadius = 4
        sunlight.shadowSampleCount = 16
        sunlight.shadowMapSize = CGSize(width: 2_048, height: 2_048)
        sunLightNode.light = sunlight
        scnScene.rootNode.addChildNode(sunLightNode)

        let core = SCNSphere(radius: 0.52)
        core.segmentCount = 32
        core.firstMaterial = constantMaterial(UIColor(red: 1.0, green: 0.86, blue: 0.45, alpha: 1))
        let coreNode = SCNNode(geometry: core)
        coreNode.castsShadow = false
        coreNode.categoryBitMask = 0
        sunNode.addChildNode(coreNode)

        let glow = SCNSphere(radius: 1.15)
        glow.segmentCount = 24
        let glowMaterial = constantMaterial(UIColor(red: 1.0, green: 0.82, blue: 0.35, alpha: 0.16))
        glowMaterial.writesToDepthBuffer = false
        glow.firstMaterial = glowMaterial
        let glowNode = SCNNode(geometry: glow)
        glowNode.castsShadow = false
        glowNode.categoryBitMask = 0
        sunNode.addChildNode(glowNode)
        sunNode.castsShadow = false
        sunNode.categoryBitMask = 0
        scnScene.rootNode.addChildNode(sunNode)

        contentRoot.name = "site"
        scnScene.rootNode.addChildNode(contentRoot)
    }

    private func rebuild(_ scene: SceneDocument) {
        contentRoot.childNodes.forEach { $0.removeFromParentNode() }
        elementRoots.removeAll()
        targetRoots.removeAll()
        groundNode = nil

        addGround(scene)
        for target in scene.targets {
            let node = targetNode(target, scene: scene)
            targetRoots[target.id] = node
            contentRoot.addChildNode(node)
        }
        for element in scene.activeElements {
            let node = elementNode(element, scene: scene)
            elementRoots[element.id] = node
            contentRoot.addChildNode(node)
        }
        center = cameraCenter(for: scene)
    }

    private func addGround(_ scene: SceneDocument) {
        let base = SCNBox(width: CGFloat(scene.width) + 0.5, height: 0.42,
                          length: CGFloat(scene.height) + 0.5, chamferRadius: 0.14)
        base.firstMaterial = litMaterial(UIColor(red: 0.05, green: 0.09, blue: 0.12, alpha: 1),
                                         specular: 0.05)
        let baseNode = SCNNode(geometry: base)
        baseNode.position = SCNVector3(0, -0.21, 0)
        baseNode.castsShadow = false
        baseNode.categoryBitMask = 0
        contentRoot.addChildNode(baseNode)

        let plane = SCNPlane(width: CGFloat(scene.width), height: CGFloat(scene.height))
        let material = SCNMaterial()
        material.lightingModel = .lambert
        material.diffuse.contents = GroundTexture.image(width: scene.width, height: scene.height,
                                                        northDegrees: scene.northDegrees)
        material.isDoubleSided = false
        plane.firstMaterial = material

        let node = SCNNode(geometry: plane)
        node.eulerAngles.x = -.pi / 2
        node.position = SCNVector3(0, 0.002, 0)
        node.castsShadow = false
        node.categoryBitMask = Scene3DHit.ground
        node.name = "ground"
        contentRoot.addChildNode(node)
        groundNode = node
    }

    private func elementNode(_ element: SceneElement, scene: SceneDocument) -> SCNNode {
        let root = SCNNode()
        root.name = "element:\(element.id.uuidString)"
        root.position = vec(Scene3DMath.worldPoint(x: element.x, y: element.y,
                                                  sceneWidth: scene.width, sceneHeight: scene.height))
        root.eulerAngles.y = Scene3DMath.rotationY(degrees: element.rotation)

        switch element.kind {
        case .tree:
            root.addChildNode(treeGeometry(element))
        case .column:
            root.addChildNode(cylinderElement(element))
        case .canopy:
            root.addChildNode(canopyGeometry(element))
        case .fence, .wall:
            root.addChildNode(boxElement(element, color: UIColor(red: 0.74, green: 0.76, blue: 0.75, alpha: 1)))
        case .building, .rectangle:
            root.addChildNode(boxElement(element, color: UIColor(red: 0.70, green: 0.67, blue: 0.57, alpha: 1)))
        }

        if selectedElement == element.id {
            root.addChildNode(selectionMarker(width: element.kind == .tree ? element.crownDiameter : element.width,
                                              depth: element.depth,
                                              height: element.height, kind: element.kind))
        }
        markSelectable(root)
        return root
    }

    private func boxElement(_ element: SceneElement, color: UIColor) -> SCNNode {
        let height = CGFloat(max(0.03, element.height))
        let box = SCNBox(width: CGFloat(max(0.05, element.width)), height: height,
                         length: CGFloat(max(0.05, element.depth)),
                         chamferRadius: min(0.06, height / 4))
        box.firstMaterial = litMaterial(color, specular: 0.12)
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(0, Float(height / 2), 0)
        node.castsShadow = true
        return node
    }

    private func cylinderElement(_ element: SceneElement) -> SCNNode {
        let height = CGFloat(max(0.05, element.height))
        let cylinder = SCNCylinder(radius: CGFloat(max(0.06, element.width / 2)), height: height)
        cylinder.radialSegmentCount = 32
        cylinder.firstMaterial = litMaterial(UIColor(red: 0.71, green: 0.68, blue: 0.58, alpha: 1),
                                             specular: 0.14)
        let node = SCNNode(geometry: cylinder)
        node.position = SCNVector3(0, Float(height / 2), 0)
        node.castsShadow = true
        return node
    }

    private func treeGeometry(_ element: SceneElement) -> SCNNode {
        let root = SCNNode()
        let crownRadius = max(0.22, element.crownDiameter / 2)
        let trunkHeight = max(0.45, min(element.crownBaseHeight, max(element.height, 0.6)))

        let trunk = SCNCylinder(radius: 0.11, height: CGFloat(trunkHeight))
        trunk.radialSegmentCount = 16
        trunk.firstMaterial = litMaterial(UIColor(red: 0.42, green: 0.31, blue: 0.21, alpha: 1),
                                          specular: 0.05)
        let trunkNode = SCNNode(geometry: trunk)
        trunkNode.position = SCNVector3(0, Float(trunkHeight / 2), 0)
        trunkNode.castsShadow = true
        root.addChildNode(trunkNode)

        let crown = SCNSphere(radius: CGFloat(crownRadius))
        crown.segmentCount = 32
        crown.firstMaterial = litMaterial(UIColor(red: 0.25, green: 0.61, blue: 0.39, alpha: 1),
                                          specular: 0.08)
        let crownNode = SCNNode(geometry: crown)
        crownNode.scale = SCNVector3(1, 0.86, 1)
        crownNode.position = SCNVector3(0, Float(max(trunkHeight, element.height - crownRadius * 0.45)), 0)
        crownNode.castsShadow = true
        root.addChildNode(crownNode)
        return root
    }

    private func canopyGeometry(_ element: SceneElement) -> SCNNode {
        let root = SCNNode()
        let height = max(0.5, element.height)
        let slab = SCNBox(width: CGFloat(max(0.2, element.width)), height: 0.16,
                          length: CGFloat(max(0.2, element.depth)), chamferRadius: 0.05)
        slab.firstMaterial = litMaterial(UIColor(red: 0.52, green: 0.69, blue: 0.74, alpha: 1),
                                         specular: 0.2)
        let slabNode = SCNNode(geometry: slab)
        slabNode.position = SCNVector3(0, Float(height), 0)
        slabNode.castsShadow = true
        root.addChildNode(slabNode)

        let postHeight = CGFloat(height)
        for dx in [-1.0, 1.0] where element.width > 0.5 {
            for dz in [-1.0, 1.0] where element.depth > 0.5 {
                let post = SCNCylinder(radius: 0.035, height: postHeight)
                post.radialSegmentCount = 10
                post.firstMaterial = litMaterial(UIColor(red: 0.55, green: 0.60, blue: 0.62, alpha: 1),
                                                 specular: 0.3)
                let postNode = SCNNode(geometry: post)
                postNode.position = SCNVector3(Float(dx * (element.width / 2 - 0.10)),
                                               Float(postHeight / 2),
                                               Float(dz * (element.depth / 2 - 0.10)))
                postNode.castsShadow = false
                root.addChildNode(postNode)
            }
        }
        return root
    }

    private func selectionMarker(width: Double, depth: Double, height: Double, kind: ElementKind) -> SCNNode {
        let color = UIColor(AppTheme.yellow)
        if kind == .tree || kind == .column {
            let radius = max(0.4, (kind == .tree ? width : width) / 2 + 0.25)
            let torus = SCNTorus(ringRadius: CGFloat(radius), pipeRadius: 0.045)
            torus.ringSegmentCount = 64
            torus.pipeSegmentCount = 12
            torus.firstMaterial = constantMaterial(color)
            let node = SCNNode(geometry: torus)
            node.eulerAngles.x = -.pi / 2
            node.position = SCNVector3(0, 0.05, 0)
            node.castsShadow = false
            node.categoryBitMask = 0
            return node
        }
        let outline = SCNBox(width: CGFloat(max(0.05, width) + 0.10),
                             height: CGFloat(max(0.03, height) + 0.08),
                             length: CGFloat(max(0.05, depth) + 0.10),
                             chamferRadius: 0.02)
        let material = constantMaterial(color)
        material.fillMode = .lines
        outline.firstMaterial = material
        let node = SCNNode(geometry: outline)
        node.position = SCNVector3(0, Float(max(0.03, height) / 2 + 0.04), 0)
        node.castsShadow = false
        node.categoryBitMask = 0
        return node
    }

    private func targetNode(_ target: ObservationTarget, scene: SceneDocument) -> SCNNode {
        let root = SCNNode()
        root.name = "target:\(target.id.uuidString)"
        root.position = vec(Scene3DMath.worldPoint(x: target.x, y: target.y,
                                                  sceneWidth: scene.width, sceneHeight: scene.height))

        if target.isPoint {
            let ring = SCNTorus(ringRadius: 0.34, pipeRadius: 0.04)
            ring.ringSegmentCount = 48
            ring.pipeSegmentCount = 12
            ring.firstMaterial = constantMaterial(UIColor(AppTheme.yellow))
            let ringNode = SCNNode(geometry: ring)
            ringNode.eulerAngles.x = -.pi / 2
            ringNode.position = SCNVector3(0, 0.03, 0)
            ringNode.castsShadow = false
            root.addChildNode(ringNode)

            let beacon = SCNSphere(radius: 0.085)
            beacon.segmentCount = 20
            beacon.firstMaterial = constantMaterial(UIColor(AppTheme.yellow))
            let beaconNode = SCNNode(geometry: beacon)
            beaconNode.position = SCNVector3(0, 0.48, 0)
            beaconNode.castsShadow = false
            root.addChildNode(beaconNode)

            let stem = SCNCylinder(radius: 0.012, height: 0.44)
            stem.radialSegmentCount = 8
            stem.firstMaterial = constantMaterial(UIColor(red: 1.0, green: 0.75, blue: 0.27, alpha: 0.55))
            let stemNode = SCNNode(geometry: stem)
            stemNode.position = SCNVector3(0, 0.22, 0)
            stemNode.castsShadow = false
            root.addChildNode(stemNode)
        } else {
            let width = CGFloat(max(0.1, target.width))
            let depth = CGFloat(max(0.1, target.depth))
            let fill = SCNPlane(width: width, height: depth)
            let fillMaterial = constantMaterial(UIColor(red: 0.33, green: 0.73, blue: 0.51, alpha: 0.30))
            fillMaterial.isDoubleSided = false
            fillMaterial.writesToDepthBuffer = false
            fill.firstMaterial = fillMaterial
            let fillNode = SCNNode(geometry: fill)
            fillNode.eulerAngles.x = -.pi / 2
            fillNode.position = SCNVector3(0, 0.012, 0)
            fillNode.castsShadow = false
            root.addChildNode(fillNode)

            let borderMaterial = constantMaterial(UIColor(red: 0.33, green: 0.73, blue: 0.51, alpha: 1))
            let thickness: CGFloat = 0.035
            for (dx, dz, w, d) in [(0.0, -0.5, 1.0, 0.0), (0.0, 0.5, 1.0, 0.0),
                                   (-0.5, 0.0, 0.0, 1.0), (0.5, 0.0, 0.0, 1.0)] {
                let strip = SCNBox(width: w > 0 ? width : thickness, height: 0.035,
                                   length: d > 0 ? depth : thickness, chamferRadius: 0.005)
                strip.firstMaterial = borderMaterial
                let stripNode = SCNNode(geometry: strip)
                stripNode.position = SCNVector3(Float(dx * Double(width)),
                                               0.018,
                                               Float(dz * Double(depth)))
                stripNode.castsShadow = false
                root.addChildNode(stripNode)
            }
        }

        if selectedTarget == target.id {
            let radius = target.isPoint ? 0.48 : max(0.5, max(target.width, target.depth) / 2 + 0.20)
            let torus = SCNTorus(ringRadius: CGFloat(radius), pipeRadius: 0.045)
            torus.ringSegmentCount = 64
            torus.pipeSegmentCount = 12
            torus.firstMaterial = constantMaterial(UIColor(AppTheme.yellow))
            let node = SCNNode(geometry: torus)
            node.eulerAngles.x = -.pi / 2
            node.position = SCNVector3(0, 0.05, 0)
            node.castsShadow = false
            node.categoryBitMask = 0
            root.addChildNode(node)
        }

        markSelectable(root)
        return root
    }

    // MARK: Sun and camera

    private func updateSun(scene: SceneDocument, moment: Date) {
        let sun = SolarPositionEngine.position(at: moment, latitude: scene.latitude,
                                               longitude: scene.longitude, timeZoneID: scene.timeZoneID)
        let direction = Scene3DMath.sunDirection(elevation: sun.elevation, azimuth: sun.azimuth,
                                                 northDegrees: scene.northDegrees)
        let span = Float(max(scene.width, scene.height))
        let lightDistance = max(12, span * 2.4)

        sunLightNode.position = vec(center + direction * lightDistance)
        sunLightNode.look(at: vec(center))

        if sun.isAboveHorizon {
            sunLightNode.light?.intensity = 1_200
            sunLightNode.light?.castsShadow = true
            sunLightNode.light?.color = UIColor(red: 1.0, green: 0.93, blue: 0.79, alpha: 1)
            sunNode.isHidden = false
            sunNode.position = vec(center + direction * max(8, span * 1.35))
        } else {
            sunLightNode.light?.intensity = 55
            sunLightNode.light?.castsShadow = false
            sunLightNode.light?.color = UIColor(red: 0.48, green: 0.62, blue: 0.92, alpha: 1)
            sunLightNode.position = vec(center + SIMD3<Float>(0.35, 1, 0.45) * lightDistance)
            sunLightNode.look(at: vec(center))
            sunNode.isHidden = true
        }

        let scale = CGFloat(max(scene.width, scene.height) * 0.95)
        sunLightNode.light?.orthographicScale = max(4, scale)
        sunLightNode.light?.zNear = 0.5
        sunLightNode.light?.zFar = CGFloat(max(40, span * 5))
        view?.setNeedsDisplay()
    }

    private func cameraCenter(for scene: SceneDocument) -> SIMD3<Float> {
        let tallest = scene.activeElements.map(\.height).max() ?? 0
        return SIMD3<Float>(0, Float(min(2.2, max(0.45, tallest * 0.28))), 0)
    }

    private func defaultRadius(for scene: SceneDocument) -> Double {
        let tallest = scene.activeElements.map(\.height).max() ?? 0
        let span = max(max(scene.width, scene.height), tallest * 1.8)
        return max(5, span * 1.55)
    }

    private func clampCamera(for scene: SceneDocument) {
        let tallest = scene.activeElements.map(\.height).max() ?? 0
        let span = max(max(scene.width, scene.height), tallest * 1.8)
        minimumRadius = max(2.5, span * 0.55)
        maximumRadius = max(minimumRadius + 4, span * 3.4)
        radius = min(maximumRadius, max(minimumRadius, radius))
        center = cameraCenter(for: scene)
    }

    private func updateCamera() {
        let position = Scene3DMath.cameraPosition(azimuth: azimuth, elevation: elevation,
                                                  radius: radius, center: center)
        cameraNode.position = vec(position)
        cameraNode.look(at: vec(center), up: SCNVector3(0, 1, 0), localFront: SCNVector3(0, 0, -1))
        scnScene.fogStartDistance = CGFloat(radius * 1.6)
        scnScene.fogEndDistance = CGFloat(radius * 3.4)
        view?.setNeedsDisplay()
    }

    // MARK: Gestures

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard allowsEditing, let view else { return }
        guard let hit = objectHit(at: gesture.location(in: view)) else { return }
        if let id = hit.elementID {
            onSelectElement?(id)
        } else if let id = hit.targetID {
            onSelectTarget?(id)
        }
    }

    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let view else { return }
        let point = gesture.location(in: view)

        switch gesture.state {
        case .began:
            panStartAzimuth = azimuth
            panStartElevation = elevation
            if allowsEditing,
               let hit = objectHit(at: point),
               let ground = groundPoint(at: point, in: view),
               let state = dragState(for: hit, ground: ground) {
                drag = state
            } else {
                drag = nil
                setEnclosingScroll(enabled: false)
            }
        case .changed:
            if let drag {
                let current = groundPoint(at: point, in: view) ?? drag.startGround
                let x = drag.originalX + Double(current.x - drag.startGround.x)
                let y = drag.originalY + Double(current.z - drag.startGround.z)
                guard let scene = currentScene else { return }
                let site = Scene3DMath.clampToSite(x, y, width: scene.width, height: scene.height)
                drag.node.position = vec(Scene3DMath.worldPoint(x: site.x, y: site.y,
                                                               sceneWidth: scene.width,
                                                               sceneHeight: scene.height))
                self.drag?.finalX = site.x
                self.drag?.finalY = site.y
                view.setNeedsDisplay()
            } else {
                let translation = gesture.translation(in: view)
                azimuth = panStartAzimuth - Double(translation.x) * 0.32
                elevation = min(82, max(12, panStartElevation - Double(translation.y) * 0.26))
                updateCamera()
            }
        case .ended:
            if let drag {
                if drag.elementID != nil {
                    onMoveElement?(drag.elementID!, drag.finalX, drag.finalY)
                } else if drag.targetID != nil {
                    onMoveTarget?(drag.targetID!, drag.finalX, drag.finalY)
                }
            }
            self.drag = nil
            setEnclosingScroll(enabled: true)
        case .cancelled, .failed:
            if let drag, let scene = currentScene {
                drag.node.position = vec(Scene3DMath.worldPoint(x: drag.originalX, y: drag.originalY,
                                                               sceneWidth: scene.width,
                                                               sceneHeight: scene.height))
                view.setNeedsDisplay()
            }
            self.drag = nil
            setEnclosingScroll(enabled: true)
        default:
            break
        }
    }

    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view else { return }
        switch gesture.state {
        case .began:
            pinchStartRadius = radius
        case .changed:
            radius = min(maximumRadius, max(minimumRadius, pinchStartRadius / Double(gesture.scale)))
            updateCamera()
            view.setNeedsDisplay()
        default:
            break
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    // MARK: Hit testing

    private func dragState(for hit: HitObject, ground: SIMD3<Float>) -> ObjectDrag? {
        guard let scene = currentScene else { return nil }
        if let id = hit.elementID {
            guard let element = scene.elements.first(where: { $0.id == id }), !element.isLocked else { return nil }
            return ObjectDrag(elementID: id, targetID: nil, node: hit.node,
                              startGround: ground, originalX: element.x, originalY: element.y,
                              finalX: element.x, finalY: element.y)
        }
        if let id = hit.targetID, let target = scene.targets.first(where: { $0.id == id }) {
            return ObjectDrag(elementID: nil, targetID: id, node: hit.node,
                              startGround: ground, originalX: target.x, originalY: target.y,
                              finalX: target.x, finalY: target.y)
        }
        return nil
    }

    private struct HitObject {
        let node: SCNNode
        let elementID: UUID?
        let targetID: UUID?
    }

    private func objectHit(at point: CGPoint) -> HitObject? {
        guard let view else { return nil }
        let results = view.hitTest(point, options: [.categoryBitMask: Scene3DHit.objects,
                                                    .searchMode: SCNHitTestSearchMode.closest.rawValue])
        for result in results {
            var node: SCNNode? = result.node
            while let current = node {
                if let id = elementRoots.first(where: { $0.value === current })?.key {
                    return HitObject(node: current, elementID: id, targetID: nil)
                }
                if let id = targetRoots.first(where: { $0.value === current })?.key {
                    return HitObject(node: current, elementID: nil, targetID: id)
                }
                node = current.parent
            }
        }
        return nil
    }

    private func groundPoint(at point: CGPoint, in view: SCNView) -> SIMD3<Float>? {
        let results = view.hitTest(point, options: [.categoryBitMask: Scene3DHit.ground,
                                                    .searchMode: SCNHitTestSearchMode.closest.rawValue])
        guard let world = results.first?.worldCoordinates else { return nil }
        return SIMD3<Float>(world.x, 0, world.z)
    }

    private func markSelectable(_ node: SCNNode) {
        node.categoryBitMask = Scene3DHit.objects
        for child in node.childNodes { markSelectable(child) }
    }

    private func setEnclosingScroll(enabled: Bool) {
        if enabled {
            enclosingScrollView?.isScrollEnabled = true
            enclosingScrollView = nil
            return
        }
        var candidate = view?.superview
        while let current = candidate {
            if let scroll = current as? UIScrollView {
                enclosingScrollView = scroll
                scroll.isScrollEnabled = false
                return
            }
            candidate = current.superview
        }
    }

    // MARK: Materials and helpers

    private func vec(_ value: SIMD3<Float>) -> SCNVector3 {
        SCNVector3(value.x, value.y, value.z)
    }

    private func litMaterial(_ color: UIColor, specular: CGFloat) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .blinn
        material.diffuse.contents = color
        material.specular.contents = UIColor(white: specular, alpha: 1)
        material.shininess = 0.18
        return material
    }

    private func constantMaterial(_ color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .constant
        material.diffuse.contents = color
        material.emission.contents = color
        material.isDoubleSided = true
        return material
    }
}

private enum SkyTexture {
    static let image: UIImage = {
        let size = CGSize(width: 16, height: 256)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            let colors = [UIColor(red: 0.020, green: 0.035, blue: 0.075, alpha: 1).cgColor,
                          UIColor(red: 0.055, green: 0.105, blue: 0.170, alpha: 1).cgColor,
                          UIColor(red: 0.095, green: 0.170, blue: 0.230, alpha: 1).cgColor]
            guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                            colors: colors as CFArray, locations: [0, 0.62, 1]) else { return }
            context.cgContext.drawLinearGradient(gradient, start: .zero,
                                                 end: CGPoint(x: 0, y: size.height), options: [])
        }
    }()
}

private enum GroundTexture {
    private static let cache = NSCache<NSString, UIImage>()

    static func image(width: Double, height: Double, northDegrees: Double) -> UIImage {
        let key = "\(Int(width.rounded()))x\(Int(height.rounded()))x\(Int(northDegrees.rounded()))" as NSString
        if let cached = cache.object(forKey: key) { return cached }

        let longSide: CGFloat = 1_280
        let size = CGSize(width: longSide, height: max(240, longSide * CGFloat(height / max(width, 0.1))))
        let step = gridStep(for: max(width, height))
        let columns = max(1, Int((width / step).rounded()))
        let rows = max(1, Int((height / step).rounded()))

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let cg = context.cgContext
            cg.setFillColor(UIColor(red: 0.135, green: 0.215, blue: 0.265, alpha: 1).cgColor)
            cg.fill(CGRect(origin: .zero, size: size))

            for index in 0...columns {
                let x = CGFloat(Double(index) * step / width) * size.width
                let major = index % 5 == 0
                cg.setStrokeColor(UIColor(white: 1, alpha: major ? 0.20 : 0.10).cgColor)
                cg.setLineWidth(major ? 1.5 : 1)
                cg.move(to: CGPoint(x: x, y: 0))
                cg.addLine(to: CGPoint(x: x, y: size.height))
                cg.strokePath()
            }
            for index in 0...rows {
                let y = CGFloat(Double(index) * step / height) * size.height
                let major = index % 5 == 0
                cg.setStrokeColor(UIColor(white: 1, alpha: major ? 0.20 : 0.10).cgColor)
                cg.setLineWidth(major ? 1.5 : 1)
                cg.move(to: CGPoint(x: 0, y: y))
                cg.addLine(to: CGPoint(x: size.width, y: y))
                cg.strokePath()
            }

            cg.setStrokeColor(UIColor(red: 0.55, green: 0.65, blue: 0.72, alpha: 0.55).cgColor)
            cg.setLineWidth(3)
            cg.stroke(CGRect(origin: .zero, size: size).insetBy(dx: 1.5, dy: 1.5))

            drawCompass(in: cg, size: size, northDegrees: northDegrees)
        }
        cache.setObject(image, forKey: key)
        return image
    }

    private static func drawCompass(in cg: CGContext, size: CGSize, northDegrees: Double) {
        let arm = max(26, min(size.width, size.height) * 0.075)
        let center = CGPoint(x: size.width * 0.78, y: size.height * 0.55)
        let color = UIColor(red: 1.0, green: 0.75, blue: 0.27, alpha: 0.9)

        cg.saveGState()
        cg.translateBy(x: center.x, y: center.y)
        cg.rotate(by: CGFloat(northDegrees * Double.pi / 180))

        cg.setStrokeColor(color.cgColor)
        cg.setLineWidth(max(2, arm * 0.08))
        cg.setLineCap(.round)
        cg.move(to: CGPoint(x: 0, y: arm * 0.66))
        cg.addLine(to: CGPoint(x: 0, y: -arm))
        cg.strokePath()

        cg.setFillColor(color.cgColor)
        cg.move(to: CGPoint(x: 0, y: -arm * 1.32))
        cg.addLine(to: CGPoint(x: -arm * 0.38, y: -arm * 0.58))
        cg.addLine(to: CGPoint(x: arm * 0.38, y: -arm * 0.58))
        cg.closePath()
        cg.fillPath()

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: arm * 0.82, weight: .heavy),
            .foregroundColor: color
        ]
        let label = "N" as NSString
        let labelSize = label.size(withAttributes: attributes)
        label.draw(at: CGPoint(x: -labelSize.width / 2, y: -arm * 2.12), withAttributes: attributes)
        cg.restoreGState()
    }

    private static func gridStep(for span: Double) -> Double {
        if span > 60 { return 10 }
        if span > 30 { return 5 }
        if span > 14 { return 2 }
        return 1
    }
}
