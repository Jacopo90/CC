//
//  LoadJsonWindow.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 12/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "LoadJsonWindow.h"
#import "ArgsView.h"

@interface LoadJsonWindow ()<ArgsViewProtocol>
@property (unsafe_unretained) IBOutlet ArgsView *viewConfiguration;
@property (weak) IBOutlet NSTextField *validateLabel;

@end

@implementation LoadJsonWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    self.viewConfiguration.argsViewdelegate = self;
    self.validateLabel.stringValue = @"not valid";
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
- (IBAction)close:(id)sender {
    [self close];
}
- (IBAction)confirm:(id)sender {
    NSDictionary *dict = [self.viewConfiguration dictionary];
    if (dict == nil) {
        return;
    }
    [self.delegate loadJsonWindow:self confirmJson:dict];
    [self close];
}
-(void)argsView:(ArgsView *)argsview validDictionary:(NSDictionary *)dictionary{
    if (dictionary) {
        self.validateLabel.stringValue = @"valid";
    }
}
-(void)argsView:(ArgsView *)argsview errorDictionary:(NSError *)error{
    if (error) {
        self.validateLabel.stringValue = @"not valid / empty";
    }
}
@end
