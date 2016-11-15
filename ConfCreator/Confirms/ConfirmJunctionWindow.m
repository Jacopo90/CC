//
//  ConfirmJunctionWindow.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 30/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ConfirmJunctionWindow.h"
#import "SignalDataSource.h"
#import "ReceptorDataSource.h"

@interface ConfirmJunctionWindow ()<NSComboBoxDelegate,NSComboBoxDataSource>
{
    NSArray <MIAComponent *> *_components;
}



@property (weak) IBOutlet NSComboBox *signalBox;
@property (weak) IBOutlet NSComboBox *receptorBox;
@property (weak) IBOutlet NSComboBox *senderBox;
@property (weak) IBOutlet NSComboBox *receiverBox;
@property (strong) SignalDataSource *signalDataSource;
@property (strong) ReceptorDataSource *receptorDataSource;
@property (weak) IBOutlet NSTextField *signalDescriptor;
@property (weak) IBOutlet NSTextField *receptorDescriptor;

@end

@implementation ConfirmJunctionWindow
-(instancetype)initWithWindowNibName:(NSString *)windowNibName components:(NSArray <MIAComponent *> *)components{
    self->_components = components;
    self.signalDataSource = [[SignalDataSource alloc]init];
    self.receptorDataSource = [[ReceptorDataSource alloc]init];
    return [super initWithWindowNibName:windowNibName];
}
- (void)windowDidLoad {
    [super windowDidLoad];
    
  

    self.senderBox.delegate = self;
    self.senderBox.dataSource = self;
    self.receiverBox.delegate = self;
    self.receiverBox.dataSource = self;
    
    self.signalBox.dataSource = self.signalDataSource;
    self.receptorBox.dataSource = self.receptorDataSource;
    self.signalBox.delegate = self;
    self.receptorBox.delegate = self;
}

- (IBAction)confirmJunction:(id)sender {
    MIAComponent *s_sender = [self->_components objectAtIndex:[self.senderBox indexOfSelectedItem]];
    MIAComponent *s_receiver = [self->_components objectAtIndex:[self.receiverBox indexOfSelectedItem]];
    NSString *signal = nil;
    if ([self.signalBox indexOfSelectedItem] >= 0) {
        signal = [self.signalDataSource objectAtIndex:[self.signalBox indexOfSelectedItem]];
    }else{
        signal = self.signalBox.stringValue;
    }
    NSString *receptor = nil;
    if ([self.receptorBox indexOfSelectedItem] >= 0) {
        receptor  = [self.receptorDataSource objectAtIndex:[self.receptorBox indexOfSelectedItem]];
    }else{
        receptor = self.receptorBox.stringValue;
    }
    BOOL pass = s_sender != nil &&
                signal != nil &&
                s_receiver != nil &&
                receptor != nil;
    if (!pass) {
        NSLog(@"junction doesnt pass validation");
        return;
    }
    MIAJunction *junction = [[MIAJunction alloc]initWithSender:s_sender
                                                        signal:signal
                                                      receiver:s_receiver
                                                      receptor:receptor];
    
    [self.delegate confirmJunctionWindow:self didConfirmJunction:junction];
    [self close];
}
-(BOOL)valueIsValid:(NSString *)string{
    return string && string.length;
}
- (IBAction)cancel:(id)sender {
    [self close];
}

#pragma mark - combo box  -
-(void)comboBoxWillPopUp:(NSNotification *)notification{
    NSComboBox* box = (NSComboBox*)[notification object];
    [box reloadData];
}
- (void)comboBoxSelectionIsChanging:(NSNotification*)notification {
    NSComboBox* box = (NSComboBox*)[notification object];
    if ([box.identifier isEqualToString:@"sender"] ) {
        MIAComponent *component = [self->_components objectAtIndex:[box indexOfSelectedItem]];
        if ([component definition] != nil) {
            [self.signalDataSource setSignals:[[component definition] objectForKey:@"signals"]];
        }else{
            [self.signalDataSource setSignals:nil];
        }
    }
    if ([box.identifier isEqualToString:@"receiver"]) {
        MIAComponent *component = [self->_components objectAtIndex:[box indexOfSelectedItem]];
        if ([component definition] != nil) {
            [self.receptorDataSource setReceptors:[[component definition] objectForKey:@"receptors"]];
        }else{
            [self.receptorDataSource setReceptors:nil];
        }
    }
 
    [box reloadData];

}
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSComboBox* box = (NSComboBox*)[notification object];

    
    if ([box.identifier isEqualToString:@"receptor"]) {
        MIAComponent *s_receiver = [self->_components objectAtIndex:[self.receiverBox indexOfSelectedItem]];
        if ([s_receiver definition] != nil) {
            NSArray *receptors = [[s_receiver definition] objectForKey:@"receptors"];
            if ([box indexOfSelectedItem] >= 0) {
                NSString *description = [[receptors objectAtIndex:[box indexOfSelectedItem]] objectForKey:@"description"];
                if (description != nil) {
                    self.receptorDescriptor.stringValue = description;
                }
            }
            
        }else{
            self.receptorDescriptor.stringValue = @"";
        }
    }
    if ([box.identifier isEqualToString:@"signal"]) {
        MIAComponent *s_sender = [self->_components objectAtIndex:[self.senderBox indexOfSelectedItem]];
        if ([s_sender definition] != nil) {
            NSArray *signals = [[s_sender definition] objectForKey:@"signals"];
            if ([box indexOfSelectedItem] >= 0) {
            NSString *description = [[signals objectAtIndex:[box indexOfSelectedItem]] objectForKey:@"description"];
                if (description != nil) {
                    self.signalDescriptor.stringValue = description;
                }
            }
            
        }else{
            self.signalDescriptor.stringValue = @"";
        }
    }
}
- (NSInteger)numberOfItemsInComboBox:(NSComboBox*)aComboBox {
    return self->_components.count;
}

- (id)comboBox:(NSComboBox*)aComboBox
objectValueForItemAtIndex:(NSInteger)index {
    return [[[self->_components objectAtIndex:index] dataDict] objectForKey:@"uid"];
    
}
@end
