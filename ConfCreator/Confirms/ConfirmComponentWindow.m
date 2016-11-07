//
//  ConfirmComponentWindow.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ConfirmComponentWindow.h"
#import "Utils.h"
#import "CompsReader.h"

@interface ConfirmComponentWindow ()<NSTextFieldDelegate,NSTextViewDelegate,NSComboBoxDataSource>
@property (weak) IBOutlet NSComboBox *nameBox;

@property (weak) IBOutlet NSTextField *nameTextfield;
@property (weak) IBOutlet NSTextField *uidTexfield;
@property (unsafe_unretained) IBOutlet NSTextView *argsTextview;
@property (weak) IBOutlet NSTextField *searchPathTextfield;
@property (weak) IBOutlet NSTextField *foundLabel;
@property (weak) IBOutlet NSTextField *validLabel;

@property (nonatomic,strong) NSDictionary *tmpDefinition;

@property (nonatomic, strong) NSArray *all_components;

@end

@implementation ConfirmComponentWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    self.argsTextview.delegate = self;
    self.argsTextview.automaticQuoteSubstitutionEnabled = NO;
    self.argsTextview.string = @"{}";
    self.nameTextfield.delegate = self;
    NSArray * paths = NSSearchPathForDirectoriesInDomains (NSDesktopDirectory, NSUserDomainMask, YES);
    NSString * desktopPath = [paths objectAtIndex:0];
    self.searchPathTextfield.stringValue =[NSString stringWithFormat:@"%@/comps_def.json",desktopPath];
    self.foundLabel.stringValue = @"not found";
    self.foundLabel.textColor = [Utils colorWithHexColorString:@"333333" alpha:1];
    self.nameBox.dataSource = self;
    NSString *path = self.searchPathTextfield.stringValue;

    self.all_components = [CompsReader loadCompsFromPath:path];
}
- (IBAction)confirmComponent:(id)sender {
    NSString *nameComponent = self.nameBox.stringValue;
    
    NSString *uidComponent = self.uidTexfield.stringValue;
    
    if (!nameComponent.length || !uidComponent.length) {
        return;
    }
    // check args empty or a valid json
    NSError *error;
    NSDictionary *args = [Utils dictionaryFromString:self.argsTextview.string error:&error];
    if (error) {
        NSLog(@"error %@",error);
        return;
    }
    
    MIAComponent *comp = [[MIAComponent alloc]initWithName:nameComponent uid:uidComponent];
    [comp updateArgs:args];
    
    [comp setDefinition:self.tmpDefinition];

    [self.delegate confirmComponentWindow:self didConfirmComponent:comp];
    
    [self close];
}


- (IBAction)cancel:(id)sender {
    [self close];
}
-(void)textViewDidChangeSelection:(NSNotification *)notification{
    NSError *error;
    [Utils dictionaryFromString:self.argsTextview.string error:&error];
    if (error) {
        self.validLabel.stringValue = @"error";
        self.validLabel.textColor = [Utils colorWithHexColorString:@"AA5B39" alpha:1];
        return;
    }
    self.validLabel.stringValue = @"valid";
    self.validLabel.textColor = [Utils colorWithHexColorString:@"277455" alpha:1];

}
-(void)controlTextDidChange:(NSNotification *)obj{
    NSTextField *textfield= (NSTextField *)obj.object;
    
    NSString *path = self.searchPathTextfield.stringValue;
    NSDictionary *def = [CompsReader componentWithName:textfield.stringValue inPath:path];
    if (def) {
        self.tmpDefinition = def;
        self.foundLabel.stringValue = @"found";
        self.foundLabel.textColor = [Utils colorWithHexColorString:@"277455" alpha:1];
    }else{
        self.tmpDefinition = nil;
        self.foundLabel.stringValue = @"not found";
        self.foundLabel.textColor = [Utils colorWithHexColorString:@"333333" alpha:1];
    }
    
}
#pragma mark -  component box -
-(void)comboBoxWillPopUp:(NSNotification *)notification{
    
}
- (void)comboBoxSelectionIsChanging:(NSNotification*)notification {
//    NSComboBox* box = (NSComboBox*)[notification object];
 
    
}
- (NSInteger)numberOfItemsInComboBox:(NSComboBox*)aComboBox {
    return self->_all_components.count;
}

- (id)comboBox:(NSComboBox*)aComboBox
objectValueForItemAtIndex:(NSInteger)index {
    return [[self->_all_components objectAtIndex:index] objectForKey:@"name"];
    
}
@end
