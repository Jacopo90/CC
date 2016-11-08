//
//  MIAUIStyle.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAUIStyle.h"
#import "Utils.h"

@implementation MIAUIStyle

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
-(void)selectStyle{
    [[Utils colorWithHexColorString:@"93C95D" alpha:1] set];
    
}
-(void)defaultStyle{
    [[Utils colorWithHexColorString:@"C95D5D" alpha:1] set];
  
}
@end
