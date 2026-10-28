import SwiftUI
import SwiftData

struct ProjectDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var project: ProjectRecord

    @State private var showRoom = false
    @State private var showMaterial = false
    @State private var editRoom: RoomPlan?
    @State private var editMaterial: MaterialPlan?
    @State private var roomToDelete: RoomPlan?
    @State private var materialToDelete: MaterialPlan?
    @State private var editProject = false
    @State private var editBudget = false
    @State private var pdfReport: PDFReport?
    @State private var errorMessage: String?

    private var details: ProjectContent { project.details }

    var body: some View {
        Group {
            if project.isDeleted {
                ContentUnavailableView("Project deleted", systemImage: "trash",
                    description: Text("This project was removed from this device."))
            } else if !project.isContentReadable {
                ContentUnavailableView("Project data unavailable", systemImage: "exclamationmark.triangle",
                    description: Text("This project could not be read. Its data has not been changed. Restore a previous backup if available."))
            } else {
                ProjectDetailContent(
                    project: project,
                    onAddRoom: { showRoom = true },
                    onEditRoom: { editRoom = $0 },
                    onDeleteRoom: { roomToDelete = $0 },
                    onAddMaterial: { showMaterial = true },
                    onEditMaterial: { editMaterial = $0 },
                    onTogglePurchased: togglePurchase,
                    onDeleteMaterial: { materialToDelete = $0 },
                    onEditBudget: { editBudget = true },
                    onExportPDF: preparePDF
                )
            }
        }
        .navigationTitle("Project")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit project", systemImage: "square.and.pencil") { editProject = true }
                    .disabled(project.isDeleted)
            }
        }
        .sheet(isPresented: $showRoom) {
            RoomEditorSheet { room in
                editorModify { $0.rooms.append(room) }
            }
        }
        .sheet(item: $editRoom) { room in
            RoomEditorSheet(existing: room) { saved in
                editorModify { doc in
                    guard let index = doc.rooms.firstIndex(where: { $0.id == saved.id }),
                          doc.rooms[index] == room else {
                        throw ProjectEditError.changed
                    }
                    doc.rooms[index] = saved
                }
            }
        }
        .sheet(isPresented: $showMaterial) {
            MaterialEditorSheet(rooms: details.rooms, currencyCode: details.currencyCode) { item in
                editorModify { doc in
                    guard doc.rooms.contains(where: { $0.id == item.roomID }) else {
                        throw ProjectEditError.missingRoom
                    }
                    doc.materials.append(item)
                }
            }
        }
        .sheet(item: $editMaterial) { material in
            MaterialEditorSheet(rooms: details.rooms,
                                currencyCode: details.currencyCode,
                                existing: material) { saved in
                editorModify { doc in
                    guard let index = doc.materials.firstIndex(where: { $0.id == saved.id }) else {
                        throw ProjectEditError.changed
                    }
                    guard doc.rooms.contains(where: { $0.id == saved.roomID }) else {
                        throw ProjectEditError.missingRoom
                    }
                    var current = doc.materials[index]
                    let purchased = current.purchased
                    current.purchased = material.purchased
                    guard current == material else { throw ProjectEditError.changed }
                    var updated = saved
                    updated.purchased = purchased
                    doc.materials[index] = updated
                }
            }
        }
        .sheet(isPresented: $editProject) {
            ProjectEditorSheet(project: project)
        }
        .sheet(isPresented: $editBudget) {
            BudgetEditorSheet(project: project)
        }
        .sheet(item: $pdfReport) { report in
            PDFReportSheet(report: report)
        }
        .confirmationDialog("Delete room?", item: $roomToDelete, titleVisibility: .visible) { room in
            Button("Delete Room", role: .destructive) { deleteRoom(room) }
        } message: { room in
            Text("Delete \(room.name) and its associated materials? This cannot be undone.")
        }
        .confirmationDialog("Delete material?", item: $materialToDelete, titleVisibility: .visible) { material in
            Button("Delete Material", role: .destructive) { deleteMaterial(material) }
        } message: { material in
            Text("Delete \(material.name) from this project and its shopping list?")
        }
        .alert("Unable to complete action", item: $errorMessage) { _ in
            Button("OK", role: .cancel) { }
        } message: { message in
            Text(message)
        }
    }

    private var safeFilename: String {
        let filtered = project.name.map { ($0.isLetter || $0.isNumber || $0 == "-" || $0 == " ") ? $0 : "_" }
        let trimmed = String(filtered.prefix(60)).trimmingCharacters(in: .whitespaces)
        let base = trimmed.contains(where: { $0.isLetter || $0.isNumber }) ? trimmed : "Project"
        return "\(base)-Purchase-Report"
    }

    private func preparePDF() {
        do {
            try project.requireAvailable(in: context)
            let data = try PDFReportService.makeReport(project: project)
            pdfReport = PDFReport(data: data, filename: safeFilename)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteRoom(_ room: RoomPlan) {
        let removed = modify { doc in
            doc.rooms.removeAll { $0.id == room.id }
            doc.materials.removeAll { $0.roomID == room.id }
        }
        if removed {
            RoomPhotoService.delete(room.photoFilename)
        }
    }

    private func deleteMaterial(_ material: MaterialPlan) {
        modify { $0.materials.removeAll { $0.id == material.id } }
    }

    private func togglePurchase(_ id: UUID) {
        modify { doc in
            if let index = doc.materials.firstIndex(where: { $0.id == id }) {
                doc.materials[index].purchased.toggle()
            }
        }
    }

    private func editorModify(_ action: (inout ProjectContent) throws -> Void) -> String? {
        if modify(action) { return nil }
        let message = errorMessage ?? "Your changes could not be saved. Please try again."
        errorMessage = nil
        return message
    }

    @discardableResult
    private func modify(_ action: (inout ProjectContent) throws -> Void) -> Bool {
        do {
            try project.requireAvailable(in: context)
            var copy = try project.readDetails()
            try action(&copy)
            try project.update(copy)
            try context.save()
            return true
        } catch {
            context.rollback()
            errorMessage = error.localizedDescription
            return false
        }
    }
}
