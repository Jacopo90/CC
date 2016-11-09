//
//  MIAUIJunction.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAUIJunction.h"
#import "Utils.h"
#import "ArrowButton.h"


@interface NSLine: NSView

@end
@implementation NSLine
- (void)drawRect:(NSRect)dirtyRect {
    [[Utils colorWithHexColorString:@"677D99" alpha:1] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end

@interface MIAUIJunction(){

}
@property (weak) IBOutlet ArrowButton *downButton;
@property (weak) IBOutlet ArrowButton *upButton;
@property (weak) IBOutlet NSTextField *senderTextField;
@property (weak) IBOutlet NSTextField *signalTextField;
@property (weak) IBOutlet NSTextField *receiverTextField;
@property (weak) IBOutlet NSTextField *receptorTextField;
@property (weak) IBOutlet NSLine *line;
@property (nonatomic,strong) NSColor *junctionBgColor;
@end

@implementation MIAUIJunction
@synthesize delegate;

-(void)selectStyle{
    [[Utils colorWithHexColorString:@"C9AE82" alpha:1] set];

}
-(void)defaultStyle{
    [[Utils colorWithHexColorString:@"5da5c3" alpha:1] set];
    self.senderTextField.textColor = [Utils colorWithHexColorString:@"283D58"alpha:1];
    self.receiverTextField.textColor = [Utils colorWithHexColorString:@"283D58" alpha:1];
    self.signalTextField.textColor = [Utils colorWithHexColorString:@"efefef" alpha:1];
    self.receptorTextField.textColor = [Utils colorWithHexColorString:@"efefef" alpha:1];

}
-(void)customStyle{
    [self.junctionBgColor set];
}


-(void)bindData:(NSDictionary *)data{
    if ([data objectForKey:@"sender"]) {
        self.senderTextField.stringValue = [data objectForKey:@"sender"];
    }
    if ([data objectForKey:@"signal"]) {
        self.signalTextField.stringValue = [data objectForKey:@"signal"];
    }
    if ([data objectForKey:@"receiver"]) {
        self.receiverTextField.stringValue = [data objectForKey:@"receiver"];
    }
    if ([data objectForKey:@"receptor"]) {
        self.receptorTextField.stringValue = [data objectForKey:@"receptor"];
    }
    [self.upButton upArrow:YES];
    [self.downButton upArrow:NO];
}
-(void)setBgColorForLinkedJunctionStyle:(NSColor *)color{ // to do: think a better way to do
    self.junctionBgColor = color;
}
@end
