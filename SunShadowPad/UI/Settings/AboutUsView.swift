import SwiftUI

struct AboutUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 19) {
                Image(systemName: "sun.horizon.fill")
                    .font(.system(size: 70)).foregroundStyle(AppTheme.yellow)
                    .padding(.top, 30)
                Text(AppInfo.name).font(.largeTitle.bold())
                Text("Outdoor light, thoughtfully mapped.")
                    .foregroundStyle(AppTheme.textMuted)
                Surface {
                    Text("About the App").font(.headline)
                    Text("SunShadowPad is a standalone iPhone planning utility for gardens, courtyards, balconies and outdoor photo setups. It estimates where direct sunlight may fall around the objects you draw.")
                        .font(.body)
                }
                Surface {
                    Text("Development & Method").font(.headline)
                    Text("Built with SwiftUI and local SwiftData storage. Solar position uses published NOAA approximation equations; geometric shadows are illustrative calculations for horizontal ground.")
                }
                Surface {
                    LabeledContent("Version", value: AppInfo.version)
                    LabeledContent("Platform", value: "iPhone")
                    LabeledContent("Connection", value: "Not required")
                    LabeledContent("Projects", value: "Stored on your device")
                }
                Surface {
                    Text("Contact").font(.headline)
                    LabeledContent("Developer", value: AppInfo.developer)
                    if let support = AppInfo.supportAddress {
                        Link(AppInfo.supportEmail, destination: support)
                            .foregroundStyle(AppTheme.yellow)
                    } else {
                        Text(AppInfo.supportContactSentence)
                            .font(.footnote)
                            .foregroundStyle(AppTheme.textMuted)
                    }
                }
                Text(AppInfo.copyright)
                    .font(.caption)
                    .foregroundStyle(AppTheme.textMuted)
                    .padding(.bottom, 20)
            }.padding(16)
        }
        .background(AppTheme.navy.ignoresSafeArea())
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}
