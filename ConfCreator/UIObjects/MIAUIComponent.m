//
//  MIAUIComponent.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "MIAUIComponent.h"
#import "Utils.h"
#import "ArrowButton.h"

@interface MIAUIComponent()
@property (weak) IBOutlet NSTextField *nameTextfield;
@property (weak) IBOutlet NSTextField *uidTextfield;
@property (weak) IBOutlet NSTextField *argsTextfield;
@property (weak) IBOutlet ArrowButton *upButton;
@property (weak) IBOutlet ArrowButton *downButton;
@property (weak) IBOutlet NSTextField *defTextfield;

@end

@implementation MIAUIComponent
@synthesize delegate;

-(void)selectStyle{
    [[NSColor colorWithRed:0 green:40.0/255.0f blue:40.0f/255.0f alpha:1] set];
    self.nameTextfield.textColor = [Utils colorWithHexColorString:@"ffffff" alpha:1];

}
-(void)defaultStyle{
    [[NSColor colorWithRed:0 green:96.0/255.0f blue:88.0f/255.0f alpha:1] set];
    self.nameTextfield.textColor = [Utils colorWithHexColorString:@"ffffff" alpha:1];
    self.uidTextfield.textColor = [Utils colorWithHexColorString:@"ffffff" alpha:1];

}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
  
}
-(void)hideDefinition:(BOOL)hide{
    self.defTextfield.hidden = hide;

}
-(void)bindData:(NSDictionary *)data{
    self.nameTextfield.stringValue = [data objectForKey:@"name"];
    self.uidTextfield.stringValue = [data objectForKey:@"uid"];
    if (![data objectForKey:@"args"]) {
        self.argsTextfield.hidden = YES;
    }
  
    [self.upButton upArrow:YES];
    [self.downButton upArrow:NO];
    
    
    self.argsTextfield.hidden = YES;
    self.defTextfield.hidden = YES;
}

#pragma mark - actions -

@end
