// Copyright 2016-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <UIKit/UIKit.h>

#import "MaterialButtons.h"
#import "MaterialElevation.h"
#import "MaterialShadowElevations.h"

#import "MDCFontTextStyle.h"

/**
 A representation of a mapping of UIContentSizeCategory keys to font size values.
 
 The values of this dictionary are CGFloat values represented as an NSNumber. Each value defines the
 font size to be used for a given content size category.
 */
typedef NSDictionary<UIContentSizeCategory, NSNumber *> *MDCScalingCurve;

@interface UIFont (MaterialScalable)

/**
 A custom scaling curve to be used when scaling this font for Dynamic Type.
 
 The keys of a scaling curve MUST include the complete set of UIContentSizeCategory values, from
 UIContentSizeCategoryExtraSmall to UIContentSizeCategoryExtraExtraExtraLarge AND all
 UIContentSizeCategoryAccessibility categories. If any of these keys are missing then any scaling
 behavior that reads from this property is undefined.
 */
@property(nonatomic, copy, nullable, setter=mdc_setScalingCurve:) MDCScalingCurve mdc_scalingCurve;

/**
 Returns a font with the same family, weight and traits, but whose point size is based on the given
 size category and the corresponding value from @c mdc_scalingCurve.
 
 @param sizeCategory The size category for which the font should be scaled.
 @return A font whose point size is extracted from @c mdc_scalingCurve for the given size category,
 or self if @c mdc_scalingCurve is nil.
 */
- (nonnull UIFont *)mdc_scaledFontForSizeCategory:(nonnull UIContentSizeCategory)sizeCategory;

/**
 Returns a font with the same family, weight and traits, but whose point size is based on the given
 trait environment's preferred content size category.
 
 If the device is running iOS 9 and not in an extension, then the provided traitEnvironment will be
 ignored and the UIApplication sharedApplication's preferredContentSizeCategory will be used
 instead.
 
 If the device is running iOS 9 and in an extension, then the provided trait environment will be
 ignored and the returned font will be scaled with UIContentSizeCategoryLarge.
 
 @param traitEnvironment The trait environment whose trait collection should be queried.
 @return A font whose point size is determined by @c mdc_scalingCurve for the given trait
 environment's content size category, or self if @c mdc_scalingCurve is nil.
 */
- (nonnull UIFont *)mdc_scaledFontForTraitEnvironment:
(nonnull id<UITraitEnvironment>)traitEnvironment;

/**
 Returns a font with the same family, weight and traits, but whose point size is based on the
 default size category of UIContentSizeCategoryLarge and the corresponding value from
 @c mdc_scalingCurve.
 
 This can be used to return a font for a text element that should *not* be scaled with Dynamic
 Type.
 
 @return A font whose point size is extracted from @c mdc_scalingCurve for
 UIContentSizeCategoryLarge, or self if @c mdc_scalingCurve is nil.
 */
- (nonnull UIFont *)mdc_scaledFontAtDefaultSize;

/**
 Returns a font with the same family, weight and traits, but whose point size is based on the
 device's current content size category and the corresponding value from @c mdc_scalingCurve.
 
 @note Prefer @c -mdc_scaledFontForSizeCategory: because it encourages use of trait collections
 instead.
 
 @return If @c mdc_scalingCurve is nil, returns self. On iOS 10 and above, returns a font whose
 point size is extracted from @c mdc_scalingCurve for UIScreen.mainScreen's
 preferredContentSizeCategory. On iOS 9, returns a font whose point size is extracted from
 @c mdc_scalingCurve for UIApplication.sharedApplication's preferredContentSizeCategory, if a shared
 application is available, otherwise uses UIContentSizeCategoryLarge instead.
 */
- (nonnull UIFont *)mdc_scaledFontForCurrentSizeCategory;

@end


/**
 Class which provides the default implementation of a Snackbar.
 */
@interface MDCSnackbarMessageView : UIView <MDCElevatable, MDCElevationOverriding>

/**
 The color for the background of the Snackbar message view.

 The default color is a dark gray color.
 */
@property(nonatomic, strong, nullable)
    UIColor *snackbarMessageViewBackgroundColor UI_APPEARANCE_SELECTOR;

/**
 The color for the shadow color for the Snackbar message view.

 The default color is @c blackColor.
 */
@property(nonatomic, strong, nullable)
    UIColor *snackbarMessageViewShadowColor UI_APPEARANCE_SELECTOR;

/**
 The color for the message text in the Snackbar message view.

 The default color is @c whiteColor.
 */
@property(nonatomic, strong, nullable) UIColor *messageTextColor UI_APPEARANCE_SELECTOR;

/**
 The font for the message text in the Snackbar message view.
 */
@property(nonatomic, strong, nullable) UIFont *messageFont UI_APPEARANCE_SELECTOR;

/**
 The font for the button text in the Snackbar message view.
 */
@property(nonatomic, strong, nullable) UIFont *buttonFont UI_APPEARANCE_SELECTOR;

/**
 The array of action buttons of the snackbar.
 */
@property(nonatomic, strong, nullable) NSMutableArray<MDCButton *> *actionButtons;

/**
 The elevation of the snackbar view.
 */
@property(nonatomic, assign) MDCShadowElevation elevation;

/**
 The @c accessibilityLabel to apply to the message of the Snackbar.
 */
@property(nullable, nonatomic, copy) NSString *accessibilityLabel;

/**
 The @c accessibilityHint to apply to the message of the Snackbar.
 */
@property(nullable, nonatomic, copy) NSString *accessibilityHint;

/**
 Returns the button title color for a particular control state.

 Default for UIControlStateNormal is MDCRGBAColor(0xFF, 0xFF, 0xFF, (CGFloat)0.6).
 Default for UIControlStatehighlighted is white.

 @param state The control state.
 @return The button title color for the requested state.
 */
- (nullable UIColor *)buttonTitleColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/**
 Sets the button title color for a particular control state.

 @param titleColor The title color.
 @param state The control state.
 */
- (void)setButtonTitleColor:(nullable UIColor *)titleColor
                   forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

/**
 Indicates whether the Snackbar should automatically update its font when the device’s
 UIContentSizeCategory is changed.

 This property is modeled after the adjustsFontForContentSizeCategory property in the
 UIContentSizeCategoryAdjusting protocol added by Apple in iOS 10.0.

 If set to YES, this button will base its message font on MDCFontTextStyleBody2
 and its button font on MDCFontTextStyleButton.

 Default value is NO.
 */
@property(nonatomic, readwrite, setter=mdc_setAdjustsFontForContentSizeCategory:)
    BOOL mdc_adjustsFontForContentSizeCategory UI_APPEARANCE_SELECTOR;

/**
 Affects the fallback behavior for when a scaled font is not provided.

 If enabled, the font size will adjust even if a scaled font has not been provided for
 a given UIFont property on this component.

 If disabled, the font size will only be adjusted if a scaled font has been provided.
 This behavior most closely matches UIKit's.

 Default value is YES, but this flag will eventually default to NO and then be deprecated
 and deleted.
 */
@property(nonatomic, assign) BOOL adjustsFontForContentSizeCategoryWhenScaledFontIsUnavailable;

/**
 A block that is invoked when the MDCSnackbarMessageView receives a call to @c
 traitCollectionDidChange:. The block is called after the call to the superclass.
 */
@property(nonatomic, copy, nullable) void (^traitCollectionDidChangeBlock)
    (MDCSnackbarMessageView *_Nonnull messageView,
     UITraitCollection *_Nullable previousTraitCollection);

@end

// clang-format off
@interface MDCSnackbarMessageView ()

/** @see messsageTextColor */
@property(nonatomic, strong, nullable) UIColor *snackbarMessageViewTextColor UI_APPEARANCE_SELECTOR
__deprecated_msg("Use messsageTextColor instead.");

@end
// clang-format on
