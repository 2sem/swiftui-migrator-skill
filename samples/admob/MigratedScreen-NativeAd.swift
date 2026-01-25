struct RecipientRuleListScreen: View {
    @EnvironmentObject private var adManager: SwiftUIAdManager
    @AppStorage("LaunchCount") var launchCount: Int = 0
    @AppStorage("LastFullAdShown") var lastFullAdShown: Date = Date.distantPast

    #if DEBUG
        var nativeAdUnit: String = "ca-app-pub-3940256099942544/3986624511"
    #else
        @InfoPlist(["GADUnitIdentifiers", "Native"], default: "") var nativeAdUnit: String
    #endif

    var body: some View {
        ...
        List {
            // 규칙 섹션 + 네이티브 광고 섞어 보여주기
            Section {
                let interval = 5
                ForEach(Array(rules.enumerated()), id: \.element.id) { index, rule in
                    Group {
                        NativeAdRowView(index: index, interval: interval)
                        ...
                    }
                }
            }
        }
        ...
    }
}