//
//  SettingsViewController.swift
//  LNPopupControllerExample
//
//  Created by Leo Natan on 02/10/2023.
//  Copyright © 2023 Leo Natan. All rights reserved.
//

import SwiftUI

#if LNPOPUP

import LNPopupController

extension UIBlurEffect.Style {
	static let `default` = UIBlurEffect.Style(rawValue: 0xffff)!
}

fileprivate extension Picker where Label == EmptyView {
	init(selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
		self.init(selection: selection, content: content) {
			EmptyView()
		}
	}
}

fileprivate var isLNPopupUIExample: Bool = {
	return ProcessInfo.processInfo.processName == "LNPopupUIExample"
}()

fileprivate struct CellPaddedText: View {
	let text: Text
	public init<S>(_ content: S) where S : StringProtocol {
		text = Text(content)
	}
	
	var body: some View {
		text.padding([.top, .bottom], 4.167)
	}
}

fileprivate struct CellPaddedToggle<S>: View where S: StringProtocol {
	let title: S
	let isOn: Binding<Bool>
	
	init(_ title: S, isOn: Binding<Bool>) {
		self.title = title
		self.isOn = isOn
	}
	
	var body: some View {
		Toggle(isOn: isOn, label: {
			Text(title).padding([.top, .bottom], 4.167)
		})
	}
}

struct SettingsView : View {
	@AppStorage(PopupSettingsBarStyle) var barStyle: LNPopupBar.Style = .default
	@AppStorage(PopupSettingsInteractionStyle) var interactionStyle: UIViewController.__PopupInteractionStyle = .default
	@AppStorage(PopupSettingsCloseButtonStyle) var closeButtonStyle: LNPopupCloseButton.Style = .default
	@AppStorage(PopupSettingsProgressViewStyle) var progressViewStyle: LNPopupBar.ProgressViewStyle = .default
	@AppStorage(PopupSettingsMarqueeStyle) var marqueeStyle: Int = 0
	@AppStorage(PopupSettingsVisualEffectViewBlurEffect) var blurEffectStyle: UIBlurEffect.Style = .default
	
	@AppStorage(PopupSettingsExtendBar) var extendBar: Bool = true
	@AppStorage(PopupSettingsHidesBottomBarWhenPushed) var hideBottomBar: Bool = true
	@AppStorage(PopupSettingsCustomBarEverywhereEnabled) var customPopupBar: Bool = false
	@AppStorage(PopupSettingsEnableCustomizations) var enableCustomizations: Bool = false
	@AppStorage(PopupSettingsContextMenuEnabled) var contextMenu: Bool = false
	@AppStorage(PopupSettingsTouchVisualizerEnabled) var touchVisualizer: Bool = false
	
	@AppStorage(__LNPopupBarHideContentView) var hidePopupBarContentView: Bool = false
	@AppStorage(__LNPopupBarHideShadow) var hidePopupBarShadow: Bool = false
	@AppStorage(__LNPopupBarEnableLayoutDebug) var layoutDebug: Bool = false
	
	@AppStorage(DemoAppDisableDemoSceneColors) var disableDemoSceneColors: Bool = false
	@AppStorage(DemoAppEnableFunkyInheritedFont) var enableFunkyInheritedFont: Bool = false
	@AppStorage(DemoAppEnableExternalScenes) var enableExternalScenes: Bool = false
	
	@Environment(\.sizeCategory) var sizeCategory
	
	let sizeCategoryToCellHeight: [ContentSizeCategory: CGFloat] = [.extraLarge: 48, .extraExtraLarge: 52, .extraExtraExtraLarge: 58, .accessibilityMedium: 103, .accessibilityLarge: 121, .accessibilityExtraLarge: 193, .accessibilityExtraExtraLarge: 282, .accessibilityExtraExtraExtraLarge: 313]
	
	var body: some View {
		Form {
			Picker(selection: $barStyle) {
				CellPaddedText("Default").tag(LNPopupBar.Style.default)
				CellPaddedText("Compact").tag(LNPopupBar.Style.compact)
				CellPaddedText("Prominent").tag(LNPopupBar.Style.prominent)
				CellPaddedText("Floating").tag(LNPopupBar.Style.floating)
			} label: {
				Text("Bar Style")
			}
			
			Picker(selection: $interactionStyle) {
				CellPaddedText("Default").tag(UIViewController.__PopupInteractionStyle.default)
				CellPaddedText("Drag").tag(UIViewController.__PopupInteractionStyle.drag)
				CellPaddedText("Snap").tag(UIViewController.__PopupInteractionStyle.snap)
				CellPaddedText("Scroll").tag(UIViewController.__PopupInteractionStyle.scroll)
				CellPaddedText("None").tag(UIViewController.__PopupInteractionStyle.none)
			} label: {
				Text("Interaction Style")
			}
			
			Picker(selection: $closeButtonStyle) {
				CellPaddedText("Default").tag(LNPopupCloseButton.Style.default)
				CellPaddedText("Round").tag(LNPopupCloseButton.Style.round)
				CellPaddedText("Chevron").tag(LNPopupCloseButton.Style.chevron)
				CellPaddedText("Grabber").tag(LNPopupCloseButton.Style.grabber)
				CellPaddedText("None").tag(LNPopupCloseButton.Style.none)
			} label: {
				Text("Close Button Style")
			}
			
			Picker(selection: $progressViewStyle) {
				CellPaddedText("Default").tag(LNPopupBar.ProgressViewStyle.default)
				CellPaddedText("Top").tag(LNPopupBar.ProgressViewStyle.top)
				CellPaddedText("Bottom").tag(LNPopupBar.ProgressViewStyle.bottom)
				CellPaddedText("None").tag(LNPopupBar.ProgressViewStyle.none)
			} label: {
				Text("Progress View Style")
			}
			
			Picker(selection: $marqueeStyle) {
				CellPaddedText("Default").tag(0)
				CellPaddedText("Disabled").tag(1)
				CellPaddedText("Enabled").tag(2)
			} label: {
				Text("Marquee")
			}
			
			Section {
				Picker(selection: $blurEffectStyle) {
					CellPaddedText("Default").tag(UIBlurEffect.Style.default)
				}
			} header: {
				CellPaddedText("Background Blur Style")
			} footer: {
				Text("Uses the default material chosen by the system.")
			}
			
			Section {
				Picker(selection: $blurEffectStyle) {
					CellPaddedText("Ultra Thin Material").tag(UIBlurEffect.Style.systemUltraThinMaterial)
					CellPaddedText("Thin Material").tag(UIBlurEffect.Style.systemThinMaterial)
					CellPaddedText("Material").tag(UIBlurEffect.Style.systemMaterial)
					CellPaddedText("Thick Material").tag(UIBlurEffect.Style.systemThickMaterial)
					CellPaddedText("Chrome Material").tag(UIBlurEffect.Style.systemChromeMaterial)
				}
			} footer: {
				Text("Material styles which automatically adapt to the user interface style. Available in iOS 13 and above.")
			}
			
			Section {
				Picker(selection: $blurEffectStyle) {
					CellPaddedText("Regular").tag(UIBlurEffect.Style.regular)
					CellPaddedText("Prominent").tag(UIBlurEffect.Style.prominent)
				}
			} footer: {
				Text("Styles which automatically show one of the traditional blur styles, depending on the user interface style. Available in iOS 10 and above.")
			}
			
			Section {
				Picker(selection: $blurEffectStyle) {
					CellPaddedText("Extra Light").tag(UIBlurEffect.Style.extraLight)
					CellPaddedText("Light").tag(UIBlurEffect.Style.light)
					CellPaddedText("Dark").tag(UIBlurEffect.Style.dark)
				}
			} footer: {
				Text("Traditional blur styles. Available in iOS 8 and above.")
			}
			
			Section {
				CellPaddedToggle("Extend Bar Under Safe Area", isOn: $extendBar)
			} header: {
				Text("Settings")
			} footer: {
				if isLNPopupUIExample {
					Text("Calls the `popupBarShouldExtendPopupBarUnderSafeArea()` modifier with a value of `true` in standard demo scenes.")
				} else {
					Text("Sets the `shouldExtendPopupBarUnderSafeArea` property to `true` in standard demo scenes.")
				}
			}
			
			if isLNPopupUIExample == false {
				Section {
					CellPaddedToggle("Hides Bottom Bar When Pushed", isOn: !isLNPopupUIExample ? $hideBottomBar : Binding.constant(false))
				} footer: {
					if isLNPopupUIExample {
						Text("Not supported in SwiftUI yet.")
					} else {
						Text("Sets the `hidesBottomBarWhenPushed` property of pushed controllers in standard demo scenes.")
					}
				}.disabled(isLNPopupUIExample)
			}
			
			Section {
				CellPaddedToggle("Context Menu Interactions", isOn: $contextMenu)
			} footer: {
				Text("Enables popup bar context menu interaction in standard demo scenes.")
			}
			
			Section {
				CellPaddedToggle("Customizations", isOn: $enableCustomizations)
			} footer: {
				Text("Enables popup bar customizations in standard demo scenes.")
			}
			
			Section {
				CellPaddedToggle("Custom Popup Bar", isOn: $customPopupBar)
			} footer: {
				Text("Enables a custom popup bar in standard demo scenes.")
			}
			
			Section {
				CellPaddedToggle("Disable Demo Scene Colors", isOn: $disableDemoSceneColors)
			} footer: {
				Text("Disables random background colors in the demo scenes.")
			}
			
			if isLNPopupUIExample {
				Section {
					CellPaddedToggle("Enable Funky Inherited Font", isOn: $enableFunkyInheritedFont)
				} footer: {
					Text("Enables an environment font that is inherited by the popup bar.")
				}
			}
			
			Section {
				CellPaddedToggle("Layout Debug", isOn: $layoutDebug)
				CellPaddedToggle("Hide Content View", isOn: $hidePopupBarContentView)
				CellPaddedToggle("Hide Floating Shadow", isOn: $hidePopupBarShadow)
			} header: {
				Text("Popup Bar Debug")
			}
			
			Section {
				CellPaddedToggle("Touch Visualizer", isOn: $touchVisualizer)
			} header: {
				Text("Demonstration")
			} footer: {
				Text("Enables visualization of touches within the app, for demo purposes.")
			}
			
			if isLNPopupUIExample {
				Section {
					CellPaddedToggle("Enable", isOn: $enableExternalScenes)
				} header: {
					Text("External Libraries")
				} footer: {
					Text("Enables scenes for testing with external libraries.")
				}
			}
		}.pickerStyle(.inline)
	}
}

class SettingsViewController: UIHostingController<SettingsView> {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder, rootView: SettingsView())
	}
	
	override func viewIsAppearing(_ animated: Bool) {
		super.viewIsAppearing(animated)
		
		guard let parent = parent as? UINavigationController else {
			return
		}
		
		self.view.tintColor = parent.navigationBar.tintColor
	}
	
	class func reset() {
		UserDefaults.standard.removeObject(forKey: PopupSettingsEnableCustomizations)
		UserDefaults.standard.set(true, forKey: PopupSettingsExtendBar)
		UserDefaults.standard.set(true, forKey: PopupSettingsHidesBottomBarWhenPushed)
		UserDefaults.standard.removeObject(forKey: PopupSettingsTouchVisualizerEnabled)
		UserDefaults.standard.removeObject(forKey: PopupSettingsCustomBarEverywhereEnabled)
		UserDefaults.standard.removeObject(forKey: PopupSettingsContextMenuEnabled)
		UserDefaults.standard.removeObject(forKey: PopupSettingsVisualEffectViewBlurEffect)
		UserDefaults.standard.removeObject(forKey: __LNPopupBarHideContentView)
		UserDefaults.standard.removeObject(forKey: __LNPopupBarHideShadow)
		UserDefaults.standard.removeObject(forKey: __LNPopupBarEnableLayoutDebug)
		UserDefaults.standard.removeObject(forKey: DemoAppDisableDemoSceneColors)
		UserDefaults.standard.removeObject(forKey: DemoAppEnableFunkyInheritedFont)
		UserDefaults.standard.removeObject(forKey: DemoAppEnableExternalScenes)
		
		for key in [PopupSettingsBarStyle, PopupSettingsInteractionStyle, PopupSettingsCloseButtonStyle, PopupSettingsProgressViewStyle, PopupSettingsMarqueeStyle] {
			UserDefaults.standard.removeObject(forKey: key)
		}
		
		UserDefaults.standard.setValue(0xffff, forKey: PopupSettingsVisualEffectViewBlurEffect)
	}
	
	@IBAction func reset() {
		SettingsViewController.reset()
	}
}

@available(iOS 16.0, *)
struct SettingsNavView: View {
	@Environment(\.presentationMode) var presentationMode
	
	var body: some View {
		NavigationStack {
			SettingsView()
				.navigationTitle("Settings")
				.navigationBarTitleDisplayMode(.inline)
				.toolbar {
					ToolbarItem(placement: .navigationBarLeading) {
						Button("Reset") {
							SettingsViewController.reset()
						}
					}
					ToolbarItem(placement: .confirmationAction) {
						Button("Done") {
							self.presentationMode.wrappedValue.dismiss()
						}
					}
				}
		}.frame(minWidth: 320, minHeight: 480)
	}
}

#else

struct NoSettingsView : View {
	var body: some View {
		Text("No Settings")
			.foregroundStyle(.secondary)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color(UIColor.systemGroupedBackground))
	}
}

class SettingsViewController: UIHostingController<NoSettingsView> {
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder, rootView: NoSettingsView())
	}
	
	@IBAction func reset() {
		
	}
}

#endif
