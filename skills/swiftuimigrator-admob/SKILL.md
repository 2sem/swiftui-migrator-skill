---
name: swiftuimigrator-admob
description: Use when the SwiftUI migration is already stable and the remaining work is Google AdMob integration, SwiftUIAdManager setup, GADManager ad-unit migration, opening/interstitial/rewarded/banner/native ads, or native ad UI migration.
---

# SwiftUI Migrator AdMob

## Overview

Use this skill only after project setup, startup flow, and core screen migration are already stable.

Core principle: AdMob is a late-stage migration concern. Keep ads out of the critical migration path until the SwiftUI app shell and primary user flows are verified.

## When to Use

- Core setup and screen migration are already working
- The remaining migration work is specific to Google AdMob / GADManager
- `SwiftUIAdManager`, ad-unit names, app-open ads, interstitial ads, rewarded ads, banner ads, or native ad views need SwiftUI equivalents
- Legacy UIKit AdMob wiring in `AppDelegate`, `SceneDelegate`, table/collection cells, or view controllers needs cleanup after SwiftUI parity

## Preconditions

- The app already has a stable SwiftUI entry path (`App` + `WindowGroup`)
- Startup, splash, and data migration flows are stable without ad-related blockers
- The target screens work without ads first
- Existing UIKit behavior has been read before replacing it; preserve timing, counters, and purchase/ad-free gates

## Scope

- Tuist / Info.plist AdMob configuration
- UserDefaults keys for ad timing and tracking permission
- `SwiftUIAdManager` as a SwiftUI-friendly `ObservableObject`
- App lifecycle wiring for Mobile Ads startup and app-open ads
- Screen-level interstitial presentation
- Rewarded ad actions such as temporary ad-free activation
- Banner ad loading and fixed-height SwiftUI placement
- Native ad loading and SwiftUI row rendering
- Cleanup of obsolete legacy AdMob logic only after verification

## Reference Implementation Pattern

The SendAdv app currently uses this shape and should be treated as the preferred production pattern:

- `Projects/App/Project.swift`
  - Adds `GADManager` package (`https://github.com/2sem/GADManager`, currently 1.4.x-compatible)
  - Defines `GADApplicationIdentifier`
  - Defines `GADUnitIdentifiers` for production units, e.g. `FullAd`, `Launch`, `Native`, `HomeBanner`, `SettingsBanner`
  - Adds `SKAdNetworkItems`
  - Adds `NSUserTrackingUsageDescription`
- `Projects/App/Sources/App.swift`
  - Imports `GoogleMobileAds` and `GADManager`
  - Owns `@StateObject private var adManager = SwiftUIAdManager()`
  - Injects `.environmentObject(adManager)` at `WindowGroup` level
  - Calls `MobileAds.shared.start` once from `setupAds()`
  - Calls `adManager.setup()` after Mobile Ads starts
  - Configures `MobileAds.shared.requestConfiguration.testDeviceIdentifiers` for local devices
  - Prepares rewarded, full/interstitial, and launch/opening units with DEBUG/RELEASE intervals
  - Uses `scenePhase` to show launch/opening ads only after returning from background
- `SwiftUIAdManager`
  - Is `NSObject, ObservableObject`
  - Defines ad-unit enum cases matching Info.plist keys (`FullAd`, `Launch`, `Native`, optional `RewardAd`, optional banner units such as `HomeBanner` / `SettingsBanner`)
  - Keeps `testUnits` populated in DEBUG and empty in RELEASE
  - Creates `GADManager<GADUnitName>` with a `UIWindow`
  - Publishes `isReady` so native ads can load after setup
  - Provides async `show(unit:) -> Bool`
  - Guards ad presentation and native loading with the app's ad-free flag (for example `LSDefaults.isAdFree`)
  - Implements `GADManagerDelegate` by reading/writing last prepared and last shown timestamps
- Banner ads
  - Add `SwiftUIAdManager.createBannerAdView(withAdSize:forUnit:) -> BannerView?`
  - Prepare through `gadManager.prepare(bannerUnit:isTesting:size:)`
  - Wrap `GoogleMobileAds.BannerView` with `UIViewRepresentable`
  - Load only after `adManager.isReady`; keep a `hasLoaded` guard to avoid duplicate requests
  - Use distinct banner units for placements when production IDs differ, such as `.homeBanner` and `.settingsBanner`
  - Reserve layout space only when the banner view exists, commonly `.frame(height: 50)` for `AdSizeBanner`
- Screen integration
  - Reads launch count with `@AppStorage("LaunchCount")`
  - Wraps paid/critical completion actions in `presentFullAdThen { ... }`
  - Skips interstitial ads for first launch (`launchCount <= 1`)
  - Requests app tracking only after first launch and only once
- Native ads
  - Use `NativeAdSwiftUIView` with a coordinator that loads through `adManager.createAdLoader(forUnit: .native)`
  - Load on `adManager.isReady`
  - Render `MediaView` through `UIViewRepresentable`
  - Keep a visible `Ad` badge for policy compliance
  - Allow the hidden `NativeAdView` overlay to receive taps when an ad exists; keep fallback/house-ad content tappable when no ad loads
- Rewarded ads
  - Prefer a single path through `SwiftUIAdManager.showRewarded(completion:)` when using GADManager reward units
  - If a legacy `GADRewardManager` remains, keep it only while call sites still depend on it, then remove it in cleanup

## Migration Tasks

### 1. Audit existing ad behavior

1. Find all AdMob entry points: `AppDelegate`, `SceneDelegate`, `*ViewController`, ad table/collection cells, `GADManager`, `GoogleMobileAds`, `NativeAdView`, and rewarded managers.
2. Record the original behavior before editing:
   - Which units exist: full/interstitial, launch/opening, native, rewarded, banner
   - Which counters gate ads: launch count, last shown time, last prepared time, ad-free purchase/reward state
   - Which flows trigger ads: app foreground, message/send completion, list rows, reward button
3. Do not delete UIKit ad code until SwiftUI behavior is verified.

### 2. Migrate AdMob configuration

1. In `Projects/App/Project.swift`, ensure the `GADManager` package is present and the target depends on `.package(product: "GADManager", type: .runtime)`.
2. Ensure Info.plist includes:
   - `GADApplicationIdentifier`
   - `GADUnitIdentifiers` for every enum case used by `SwiftUIAdManager.GADUnitName`
   - `SKAdNetworkItems`
   - `NSUserTrackingUsageDescription`
3. If `GADUnitName` includes `.rewarded = "RewardAd"`, add a matching `RewardAd` key or remove that case/path. Do not leave enum cases that GADManager cannot resolve.
4. Keep production IDs in Info.plist and test IDs in DEBUG-only code (`testUnits`, test device IDs, or Google sample units).

### 3. Ensure defaults and gates exist

Add or reuse defaults for:

- `LaunchCount`
- `AdsTrackingRequested`
- `LastOpeningAdPrepared`
- `LastFullADShown`
- `LastRewardShown` if rewarded ads are used
- `isAdFree` or equivalent purchase/reward flag

Rules:

- Increment launch count once on the first `.active` scene transition after process launch.
- Request tracking only after first launch and only once.
- Never show paid ads when the user is ad-free.
- Preserve interval behavior from the UIKit implementation.

### 4. Add SwiftUI ad management

1. Create or adapt `SwiftUIAdManager`.
2. Initialize `GADManager` with the active `UIWindow` in `setup()`.
3. Set the `GADManagerDelegate` on the SwiftUI manager.
4. Publish readiness (`@Published var isReady`) after setup completes.
5. Add helpers:
   - `prepare(interstitialUnit:interval:)`
   - `prepare(openingUnit:interval:)`
   - `prepare(rewardUnit:)` when reward units are configured
   - `createBannerAdView(withAdSize:forUnit:) -> BannerView?` when banner units are configured
   - `show(unit:) async -> Bool`
   - `showRewarded(completion:)` when rewarded ads are configured
   - `createAdLoader(forUnit:) -> AdLoader?`
6. In DEBUG, include all active enum cases in `testUnits`; in RELEASE, keep `testUnits` empty.

Avoid double-prepare bugs: each ad unit should be prepared once per configuration branch. For example, do not prepare `.full` with a 60-second interval and then prepare `.full` again with a 60-minute interval in the same RELEASE startup path.

### 5. Wire Mobile Ads into `App.swift`

1. Import `GoogleMobileAds` and `GADManager`.
2. Own `SwiftUIAdManager` with `@StateObject`.
3. Inject it at the `WindowGroup` root with `.environmentObject(adManager)`.
4. Add idempotent setup (`guard !isSetupDone else { return }`).
5. Start Mobile Ads and then call `adManager.setup()`.
6. Configure ad preparation intervals:
   - DEBUG: short intervals for manual verification
   - RELEASE: production intervals matching the old app
7. Track `scenePhase`:
   - On first active transition: increment launch count
   - On background: mark `isFromBackground = true`
   - On active after background: show `.launch`, then reset the flag

### 6. Migrate screen-level interstitials

Use an explicit wrapper near the screen action:

```swift
private func presentFullAdThen(_ action: @escaping () -> Void) {
	guard launchCount > 1 else {
		action()
		return
	}
	Task {
		await adManager.requestAppTrackingIfNeed()
		await adManager.show(unit: .full)
		action()
	}
}
```

Guidelines:

- Keep the business action independent of ad success/failure.
- Execute the action after the ad completes, fails, or is skipped.
- Use the wrapper only at intentional trigger points, such as send/message completion.
- Avoid mutating SwiftUI state from ambiguous callbacks; hop to `Task` / `@MainActor` when needed.

### 7. Migrate rewarded ads

1. Prefer `SwiftUIAdManager.showRewarded(completion:)` for SwiftUI call sites.
2. Gate the button by the current ad-free state.
3. On reward success, update the ad-free entitlement/state and invoke any completion callback.
4. Verify a matching reward ad unit exists in configuration before enabling the UI.
5. Remove old `GADRewardManager` only after no SwiftUI or UIKit call sites use it.

### 8. Migrate banner ads

Use banner migration for persistent, inline placements such as a home screen footer or settings footer.

1. Add banner ad unit keys to `GADUnitIdentifiers`, for example `HomeBanner` and `SettingsBanner`.
2. Add matching `GADUnitName` enum cases, for example `.homeBanner = "HomeBanner"` and `.settingsBanner = "SettingsBanner"`.
3. Add a manager helper:

```swift
func createBannerAdView(withAdSize size: AdSize, forUnit unit: GADUnitName) -> BannerView? {
	gadManager?.prepare(bannerUnit: unit, isTesting: self.isTesting(unit: unit), size: size)
}
```

4. Create `BannerAdView` with an `@EnvironmentObject` `SwiftUIAdManager`, a coordinator conforming to `BannerViewDelegate`, and a `UIViewRepresentable` wrapper around `BannerView`.
5. In the coordinator, guard with `hasLoaded` and call `banner.load(Request())` only once after `adManager.isReady` becomes true.
6. Place `BannerAdView(unitName: .homeBanner)` or the appropriate placement-specific unit near the bottom of the SwiftUI screen.
7. Keep the banner outside scrollable content unless the original UIKit placement was intentionally part of the scrolling list.
8. For fixed banners using `AdSizeBanner`, reserve `50` points of height only when the `BannerView` exists; otherwise return `Color.clear.frame(height: 0)` to avoid empty ad gaps.
9. Do not show banner ads for ad-free users; return nil/no banner from the manager or skip the `BannerAdView` at the call site.

### 9. Migrate native ads

1. Create `MediaViewSwiftUIView` using `UIViewRepresentable` around `GoogleMobileAds.MediaView`.
2. Create `NativeAdSwiftUIView` with a coordinator that conforms to `AdLoaderDelegate` and `NativeAdLoaderDelegate`.
3. Load only after `adManager.isReady` is true.
4. Return nil/no ad loader when the user is ad-free.
5. Build `NativeAdRowView` to match the target list row design.
6. Include a visible `Ad` marker for real native ads.
7. Provide a fallback/house-ad state for failed or unavailable native ads if the product needs it.
8. Check hit testing:
   - Real ad loaded: let `NativeAdView` receive ad interactions
   - No real ad: let fallback SwiftUI content receive taps

### 10. Clean up legacy ad wiring

Only after SwiftUI ads are verified:

1. Remove `GADManagerDelegate` conformance and stored GAD managers from `AppDelegate` / `SceneDelegate`.
2. Keep `AppDelegate` focused on still-needed services such as Firebase configuration.
3. Delete obsolete UIKit ad cells/managers only after references are gone.
4. Search for old singletons (`sharedGADManager`, old reward managers, `NativeAdView` outlets) before deleting files.

## Shared References

- AdMob guide: `../swiftuimigrator/guides/admob-migration.md`
- Verification: `../swiftuimigrator/guides/verification-checklists.md`
- Samples: `../swiftuimigrator/samples/admob/`

## Verification

- Tuist project generation succeeds after adding/removing files: `mise x -- tuist generate --no-open`
- App builds with AdMob integrated
- `GADUnitName` cases exactly match `GADUnitIdentifiers` keys
- DEBUG uses test units/test devices; RELEASE uses production IDs and intervals
- Ads do not appear for ad-free users
- First launch does not show interstitial/opening ads unexpectedly
- App-open/launch ad appears only after returning from background if that is the intended behavior
- Interstitial wrapper runs the underlying action even when ad loading/showing fails
- Rewarded ad success updates the intended entitlement only after the reward callback
- Banner ads load after `adManager.isReady`, use the intended placement-specific unit, and do not leave blank spacing when unavailable
- Native ads load after `adManager.isReady` and render with the required `Ad` badge
- Legacy ad logic can be removed without regressions

## Exit Criteria

AdMob works in the SwiftUI app without depending on legacy UIKit-specific ad wiring, all active ad units are configured, and the app has safe gates for first launch, tracking permission, ad-free state, and production/test ad behavior.
