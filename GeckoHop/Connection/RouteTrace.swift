import SwiftUI

struct RouteTrace: View {
    @AppLocalized private var L
    let destination: String
    let online: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var lit: CGFloat = 0

    var body: some View {
        VStack(spacing: 7) {
            Canvas { context, size in
                let start = CGPoint(x: 8, y: size.height - 10)
                let end = CGPoint(x: size.width - 8, y: 10)
                var guide = Path()
                for y in stride(from: 10.0, through: size.height - 8, by: 15) {
                    guide.move(to: CGPoint(x: 0, y: y))
                    guide.addLine(to: CGPoint(x: size.width, y: y))
                }
                context.stroke(guide, with: .color(.white.opacity(0.13)), lineWidth: 1)
                let color = online ? Palette.active : Palette.signal
                context.stroke(TraceLine().path(in: CGRect(origin: .zero, size: size)),
                               with: .color(online ? color.opacity(0.25) : color),
                               style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round,
                                                  dash: online ? [] : [4, 5]))
                for point in [start, end] {
                    let dot = CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)
                    context.fill(Path(ellipseIn: dot), with: .color(online ? color : Palette.panel))
                    context.stroke(Path(ellipseIn: dot), with: .color(color), lineWidth: 2)
                }
            }
            .overlay {
                if online {
                    TraceLine()
                        .trim(from: 0, to: reduceMotion ? 1 : lit)
                        .stroke(Palette.active, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                }
            }
            .onAppear { light(online) }
            .onChangeCompat(of: online) { light($0) }
            .frame(height: 72)
            .accessibilityHidden(true)

            HStack(alignment: .top, spacing: 12) {
                Text(L("此设备", "This device"))
                Spacer()
                Text(destination).multilineTextAlignment(.trailing).opacityTransitionCompat()
            }
            .font(.footnote.weight(.medium))
            .foregroundStyle(Palette.muted)
        }
    }

    private func light(_ online: Bool) {
        if online && !reduceMotion {
            withAnimation(.easeOut(duration: 0.42)) { lit = 1 }
        } else {
            lit = online ? 1 : 0
        }
    }

    private struct TraceLine: Shape {
        func path(in rect: CGRect) -> Path {
            let low = rect.maxY - 10
            let high = rect.minY + 10
            return Path { line in
                line.move(to: CGPoint(x: rect.minX + 8, y: low))
                line.addLine(to: CGPoint(x: rect.minX + rect.width * 0.32, y: low))
                line.addLine(to: CGPoint(x: rect.minX + rect.width * 0.64, y: high))
                line.addLine(to: CGPoint(x: rect.maxX - 8, y: high))
            }
        }
    }
}
