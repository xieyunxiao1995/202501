import SwiftUI

struct TideNavigationTitleModifier: ViewModifier {
    let title: String
    var subtitle: String? = nil
    var symbol: String? = nil

    func body(content: Content) -> some View {
        content
            // 保留系统导航标题与返回手势，只把可见标题移到左侧。
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Color.clear.frame(width: 1, height: 1).accessibilityHidden(true)
                }
                if #available(iOS 26.0, *) {
                    ToolbarItem(placement: .topBarLeading) {
                        TideNavigationHeader(title: title, subtitle: subtitle, symbol: symbol)
                    }
                    .sharedBackgroundVisibility(.hidden)
                } else {
                    ToolbarItem(placement: .topBarLeading) {
                        TideNavigationHeader(title: title, subtitle: subtitle, symbol: symbol)
                    }
                }
            }
            .toolbarBackground(TideColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

extension View {
    func tideNavigationTitle(_ title: String, subtitle: String? = nil, symbol: String? = nil) -> some View {
        modifier(TideNavigationTitleModifier(title: title, subtitle: subtitle, symbol: symbol))
    }
}
