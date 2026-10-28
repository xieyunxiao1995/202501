import SwiftUI
import SwiftData

struct OverviewView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Query(sort: \ProjectRecord.updatedAt, order: .reverse) private var projects: [ProjectRecord]
    @State private var showingNew = false

    var body: some View {
        let stats = OverviewStats(projects: projects)
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                VStack(alignment: .leading, spacing: 7) {
                    Text("Your renovation, in focus")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(AppTheme.deep)
                    Text("Plan spaces, calculate materials, shop with confidence.")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 10)

                OverviewHeroCard { showingNew = true }

                if stats.hasUnreadableProject {
                    Text("Some project data could not be read and is excluded from these totals. Open Projects for details.")
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                SectionTitle(title: "At a glance")
                LazyVGrid(columns: Array(repeating: .init(.flexible()),
                                         count: dynamicTypeSize.isAccessibilitySize ? 1 : 2),
                          spacing: 12) {
                    MetricCard(title: "Active projects", value: "\(stats.projectCount)", icon: "house")
                    MetricCard(title: "Rooms planned", value: "\(stats.roomCount)", icon: "rectangle.3.group")
                    MetricCard(title: "Material lines", value: "\(stats.materialCount)", icon: "square.stack")
                    MetricCard(title: "Items purchased", value: "\(stats.purchasedCount)", icon: "checkmark.circle")
                }

                OverviewBudgetCard(total: stats.usdTotal, isUnavailable: stats.usdBudgetIsUnavailable)

                SectionTitle(title: "Recent projects")
                if projects.isEmpty {
                    EmptyPanel(symbol: "house", heading: "A fresh start",
                               detail: "Create your first project to plan rooms and materials.")
                } else {
                    ForEach(projects.prefix(3)) { project in
                        NavigationLink { ProjectDetailView(project: project) } label: {
                            ProjectRow(project: project)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(18)
        }
        .background(AppTheme.paper)
        .navigationTitle("Overview")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Create project", systemImage: "plus") { showingNew = true }
            }
        }
        .sheet(isPresented: $showingNew) { ProjectEditorSheet() }
    }
}
