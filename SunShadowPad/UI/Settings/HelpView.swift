import SwiftUI

struct HelpView: View {
    private let tips: [(String, String, String)] = [
        ("Create a space", "In Scenes, tap +. Open scene properties to set your latitude, longitude, time zone, dimensions and true-north direction.", "square.and.pencil"),
        ("Add obstacles", "In the scene editor choose Add Object. Tap an object to edit its dimensions and height. Drag it to move; pinch the scene to zoom.", "square.3.layers.3d"),
        ("Add planting areas", "Add a Vegetable Bed, Flower Bed or Observation Point. Set the amount of theoretical direct sunlight you want.", "leaf"),
        ("Move through the day", "In Shadow Simulator, select a scene and date. Scrub the local-time slider or play the sequence to reveal changing shadows.", "sun.horizon"),
        ("Read exposure", "Open Timeline. Choose an observation target, inspect its direct-sun blocks, or switch to the heatmap for spatial results.", "chart.bar.xaxis"),
        ("Compare a layout", "In Scenes, choose Duplicate as New Layout, change the copy, and use Timeline → Compare to see the difference.", "square.on.square"),
        ("Export your work", "Export scene JSON from the Scenes menu, create PDF planning reports from Simulator or Timeline, or export a PNG scene image from Simulator.", "square.and.arrow.up"),
        ("Restore a project", "Use Scenes → Import Project or Settings → Backup & Data. Imports with an existing scene ID are saved as new copies.", "externaldrive")
    ]
    var body: some View {
        List {
            Section("Getting Started") {
                ForEach(tips, id: \.0) { tip in
                    HStack(alignment: .top, spacing: 14) {
                        Image(systemName: tip.2)
                            .foregroundStyle(AppTheme.yellow)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(tip.0).font(.headline)
                            Text(tip.1).font(.subheadline).foregroundStyle(AppTheme.textMuted)
                        }
                    }.padding(.vertical, 4)
                }
            }
            Section("Accuracy") {
                Text("Sun positions use published approximation equations. Models assume level terrain and geometrically opaque obstacles. Use on-site checks for consequential planning decisions.")
                    .font(.subheadline)
            }
        }
        .scrollContentBackground(.hidden)
        .background(AppTheme.navy.ignoresSafeArea())
        .navigationTitle("Use Help")
    }
}
