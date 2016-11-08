//
//  StyleDefinitions.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NSDictionary StyleUIDefinition;

/// Background color is expressed as RGBA in hex format, passed as a string.
FOUNDATION_EXTERN NSString *const kMIAUIStyleBgColor;
/// Foreground color is context dependent (eg: when applied to an UITextView, it determines the text color). Is
/// expressed as RGBA in hex format, passed as a string.
FOUNDATION_EXTERN NSString *const kMIAUIStyleColor;
/// Background highlighted color is expressed as RGBA in hex format, passed as a string, usefull for buttons.
FOUNDATION_EXTERN NSString *const kMIAUIStyleHoverBgColor;
/// Title color when highlighted, is expressed as RGBA in hex format, passed as a string, usefull for buttons.
FOUNDATION_EXTERN NSString *const kMIAUIStyleHoverTitleColor;
/// Font family to be applied, passed in as a string.
FOUNDATION_EXTERN NSString *const kMIAUIStyleFontFamily;
/// This can have two values: bold or normal. @See MIAUIStyleFontWeight
FOUNDATION_EXTERN NSString *const kMIAUIStyleFontWeight;
/// This can have two values: italic or normal. @See MIAUIStyleFontStyle
FOUNDATION_EXTERN NSString *const kMIAUIStyleFontStyle;
/// Determines font size, passed in as a float NSNumber.
FOUNDATION_EXTERN NSString *const kMIAUIStyleFontSize;
//// Text alignment can be centered, left or right. @See MIAUIStyleTextAlignment
FOUNDATION_EXTERN NSString *const kMIAUIStyleTextAlign;
//// Content alignment can be centered, left or right. @See MIAUIStyleContentHorizontalAlignment
FOUNDATION_EXTERN NSString *const kMIAUIStyleContentHorizontalAlign;
//// Content alignment can be centered, left or right. @See MIAUIStyleContentVerticalAlignment
FOUNDATION_EXTERN NSString *const kMIAUIStyleContentVerticalAlign;
/// Describes text decoration. @See MIAUIStyleTextDecoration
FOUNDATION_EXTERN NSString *const kMIAUIStyleTextDecoration;
/// Describes the view border radius, passed in as a CGFloat.
FOUNDATION_EXTERN NSString *const kMIAUIStyleBorderRadius;
/// Describes the view border width, passed in as a CGFloat.
FOUNDATION_EXTERN NSString *const kMIAUIStyleBorderWidth;
/// Describes the view border color, passed in as a UIColor.
FOUNDATION_EXTERN NSString *const kMIAUIStyleBorderColor;
/// Describes if view have to mask his bounds
FOUNDATION_EXTERN NSString *const kMIAUIStyleOverflow;
/// Describes the view background linear gradient.
FOUNDATION_EXTERN NSString *const kMIAUIStyleLinearGradient;
/// Describes the view background radial gradient.
FOUNDATION_EXTERN NSString *const kMIAUIStyleRadialGradient;
/// Describes a background image.
FOUNDATION_EXTERN NSString *const kMIAUIStyleBgImage;
/// Describes a table view separator style
FOUNDATION_EXTERN NSString *const kMIAUIStyleTableSeparator;
/// Describes left padding
FOUNDATION_EXTERN NSString *const kMIAUIStylePaddingLeft;
/// Describes right padding
FOUNDATION_EXTERN NSString *const kMIAUIStylePaddingRight;
/// Describes top padding
FOUNDATION_EXTERN NSString *const kMIAUIStylePaddingTop;
/// Describes bottom padding
FOUNDATION_EXTERN NSString *const kMIAUIStylePaddingBottom;
/// Describes useless cells behavior
FOUNDATION_EXTERN NSString *const kMIAUIStyleTableRemoveUselessCells;
/// Describes tint color of view
FOUNDATION_EXTERN NSString *const kMIAUIStyleTintColor;
/// Describes translucent property of a bar
FOUNDATION_EXTERN NSString *const kMIAUIStyleTranslucent;
/// Describes content gravity
FOUNDATION_EXTERN NSString *const kMIAUIStyleGravity;
/// Describes text number of lines for text
FOUNDATION_EXPORT NSString *const kMIAUIStyleTextNumberOfLines;
/// Describes left margin
FOUNDATION_EXTERN NSString *const kMIAUIStyleMarginLeft;
/// Describes right margin
FOUNDATION_EXTERN NSString *const kMIAUIStyleMarginRight;
/// Describes top margin
FOUNDATION_EXTERN NSString *const kMIAUIStyleMarginTop;
/// Describes bottom margin
FOUNDATION_EXTERN NSString *const kMIAUIStyleMarginBottom;
/// Describes shadow radius
FOUNDATION_EXTERN NSString *const kMIAUIStyleShadowRadius;
/// Describes shadow color
FOUNDATION_EXTERN NSString *const kMIAUIStyleShadowColor;
/// Describes shadow offset
FOUNDATION_EXTERN NSString *const kMIAUIStyleShadowOffset;
/// Describes whether view clips contents to bounds
FOUNDATION_EXTERN NSString *const kMIAUIStyleClipContents;


@interface StyleDefinitions : NSObject
+(NSDictionary *)styleDictionaryFromUIKey:(NSString *)uikey;

@end
