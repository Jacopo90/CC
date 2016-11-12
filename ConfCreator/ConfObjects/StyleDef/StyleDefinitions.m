//
//  StyleDefinitions.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 08/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StyleDefinitions.h"
typedef enum : NSUInteger {
    color,
    image,
    number,
    boolean,
    string
}styleType;


NSString * const kMIAUIStyleBgImage = @"background-image";
NSString * const kMIAUIStyleBgColor = @"background-color";
NSString * const kMIAUIStyleColor = @"color";

NSString * const kMIAUIStyleFontFamily = @"font-family";
NSString * const kMIAUIStyleFontWeight = @"font-weight";
NSString * const kMIAUIStyleFontStyle = @"font-style";
NSString * const kMIAUIStyleFontSize = @"font-size";
NSString * const kMIAUIStyleTextNumberOfLines = @"number-lines";
NSString * const kMIAUIStyleTextAlign = @"text-align";

NSString * const kMIAUIStyleContentHorizontalAlign = @"content-horizontal-align";
NSString * const kMIAUIStyleContentVerticalAlign = @"content-vertical-align";

NSString * const kMIAUIStyleTextDecoration = @"text-decoration";

NSString * const kMIAUIStyleBorderRadius = @"border-radius";
NSString * const kMIAUIStyleBorderWidth = @"border-width";
NSString * const kMIAUIStyleBorderColor = @"border-color";
NSString * const kMIAUIStyleOverflow = @"overflaw";

NSString * const kMIAUIStyleHoverBgColor = @"hover-background-color";
NSString * const kMIAUIStyleHoverTitleColor = @"hover-title-color";

NSString * const kMIAUIStyleLinearGradient = @"linear-gradient";
NSString * const kMIAUIStyleRadialGradient = @"radial-gradient";

NSString * const kMIAUIStyleTableSeparator = @"table-separator";
NSString * const kMIAUIStyleTableRemoveUselessCells = @"table-remove-cells";

NSString * const kMIAUIStylePaddingLeft = @"padding-left";
NSString * const kMIAUIStylePaddingRight = @"padding-right";
NSString * const kMIAUIStylePaddingTop = @"padding-top";
NSString * const kMIAUIStylePaddingBottom = @"padding-bottom";
NSString * const kMIAUIStyleMarginLeft = @"margin-left";
NSString * const kMIAUIStyleMarginRight = @"margin-right";
NSString * const kMIAUIStyleMarginTop = @"margin-top";
NSString * const kMIAUIStyleMarginBottom = @"margin-bottom";

NSString * const kMIAUIStyleTintColor = @"tint-color";
NSString * const kMIAUIStyleTranslucent = @"translucent";

NSString * const kMIAUIStyleGravity = @"gravity";
NSString * const kMIAUIStyleShadowRadius = @"shadow-radius";
NSString * const kMIAUIStyleShadowColor = @"shadow-color";
NSString * const kMIAUIStyleShadowOffset = @"shadow-offset";
NSString * const kMIAUIStyleClipContents = @"clip-contents";


static NSDictionary *stylesConfigurations;

@implementation StyleDefinitions

+(void)load{
    
    NSMutableDictionary *viewStyle = [[NSMutableDictionary alloc]init];
    [viewStyle addEntriesFromDictionary:@{kMIAUIStyleBgImage:@(image),
                                          kMIAUIStyleBgColor:@(color),
                                          kMIAUIStyleColor:@(color),
                                          kMIAUIStyleContentHorizontalAlign:@(number),
                                          kMIAUIStyleContentVerticalAlign:@(number),
                                          kMIAUIStyleBorderRadius:@(number),
                                          kMIAUIStyleBorderWidth:@(number),
                                          kMIAUIStyleBorderColor:@(color),
                                          kMIAUIStyleOverflow:@(boolean),
                                          kMIAUIStyleTableRemoveUselessCells:@(boolean),
                                          kMIAUIStylePaddingLeft:@(number),
                                          kMIAUIStylePaddingRight:@(number),
                                          kMIAUIStylePaddingTop:@(number),
                                          kMIAUIStylePaddingBottom:@(number),
                                          kMIAUIStyleMarginLeft:@(number),
                                          kMIAUIStyleMarginRight:@(number),
                                          kMIAUIStyleMarginTop:@(number),
                                          kMIAUIStyleMarginBottom:@(number),
                                          kMIAUIStyleClipContents:@(boolean),
                                          kMIAUIStyleGravity:@(string),
                                          kMIAUIStyleTintColor:@(color)
                                          }];
    NSMutableDictionary *labelStyle = [[NSMutableDictionary alloc]init];
    [labelStyle addEntriesFromDictionary:viewStyle];
    [labelStyle addEntriesFromDictionary:@{kMIAUIStyleFontFamily:@(string),
                                           kMIAUIStyleFontWeight:@(number),
                                           kMIAUIStyleFontSize:@(number),
                                           kMIAUIStyleTextNumberOfLines:@(number),
                                           kMIAUIStyleTextAlign:@(string)
                                           }];
    NSMutableDictionary *imageStyle = [[NSMutableDictionary alloc]init];
    [imageStyle addEntriesFromDictionary:viewStyle];
 
    
    NSMutableDictionary *allStyle = [[NSMutableDictionary alloc]init];
    [allStyle addEntriesFromDictionary:viewStyle];
    [allStyle addEntriesFromDictionary:labelStyle];
    [allStyle addEntriesFromDictionary:imageStyle];

    stylesConfigurations = @{@"view":viewStyle,
                             @"label":labelStyle,
                             @"image":imageStyle,
                             @"default":allStyle
                             };
}
+(StyleUIDefinition *)styleDictionaryFromUIKey:(NSString *)uikey{
    if (uikey == nil || [stylesConfigurations objectForKey:uikey] == nil) {
        return [stylesConfigurations objectForKey:@"default"];
    }
    return [stylesConfigurations objectForKey:uikey];
}

@end
