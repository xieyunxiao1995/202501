import SwiftUI

struct HelpView: View {
    private let items = HelpFAQItem.all

    var body: some View {
        List {
            Section {
                Text("Learn the essentials and find answers to common renovation-planning questions.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            ForEach(items) { item in
                DisclosureGroup {
                    Text(item.answer)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 8)
                } label: {
                    Text(item.question)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.deep)
                }
            }
        }
        .navigationTitle("Help & FAQ")
        .scrollContentBackground(.hidden)
        .background(AppTheme.paper)
    }
}
