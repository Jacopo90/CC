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
#import "StyleElementsTableSource.h"
#import "StyleDefinitions.h"
#import "ArgsView.h"
#import "NoodleLineNumberView.h"

@interface ConfirmComponentWindow ()<NSTextFieldDelegate,NSTextViewDelegate,NSComboBoxDataSource,NSComboBoxDelegate,StyleElementTableDataSourceProtocol>
@property (weak) IBOutlet NSComboBox *nameBox;

@property (weak) IBOutlet NSTextField *nameTextfield;
@property (weak) IBOutlet NSTextField *uidTexfield;
@property (unsafe_unretained) IBOutlet NSTextView *argsTextview;
@property (weak) IBOutlet NSTextField *searchPathTextfield;
@property (weak) IBOutlet NSTextField *foundLabel;
@property (weak) IBOutlet NSTextField *validLabel;

@property (nonatomic,strong) NSDictionary *tmpDefinition;

@property (nonatomic, strong) NSArray *all_components;
@property (nonatomic, strong) NSArray *namesComponentDataSource;

@property (nonatomic, strong) StyleElementsTableSource *styleData;
@property (weak) IBOutlet NSTableView *styleElementsTable;
@property (unsafe_unretained) IBOutlet ArgsView *stylesArgsView;
@property (weak) IBOutlet NSScrollView *scrollerStylerParameters;

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
    self.nameBox.delegate = self;
    NSString *path = self.searchPathTextfield.stringValue;

    self.all_components = [CompsReader loadCompsFromPath:path];
    self.namesComponentDataSource = self.all_components;
    
    self.styleData = [[StyleElementsTableSource alloc]init];
    self.styleData.sourceDelegate = self;
    self.styleElementsTable.dataSource = self.styleData;
    self.styleElementsTable.delegate = self.styleData;
    
    [self.scrollerStylerParameters setAutohidesScrollers:NO];
    [self.scrollerStylerParameters setHasVerticalScroller:YES];
    self.scrollerStylerParameters.hasVerticalRuler = YES;
    self.scrollerStylerParameters.rulersVisible = YES;
    NoodleLineNumberView *lineView = [[NoodleLineNumberView alloc] initWithScrollView:self.scrollerStylerParameters];
    lineView.backgroundColor = [Utils colorWithHexColorString:@"ffffff" alpha:1];
    lineView.textColor = [Utils colorWithHexColorString:@"666666" alpha:1];
    lineView.alternateTextColor  = [Utils colorWithHexColorString:@"ffffff" alpha:1];
    self.scrollerStylerParameters.verticalRulerView = lineView;

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

    
    NSString *path = self.searchPathTextfield.stringValue;

    NSDictionary *componentDefinition = [CompsReader componentWithName:nameComponent inPath:path];
    NSArray *elements = [componentDefinition objectForKey:@"UI"];
    [self.styleData updateDataSource:elements];
    
    MIAStyle *style = nil;
    /*
//    if (self.uiCheckBox.state == 1){
        NSString *path = self.searchPathTextfield.stringValue;

       NSDictionary *componentDefinition = [CompsReader componentWithName:nameComponent inPath:path];
        NSMutableArray *uiValues = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in [componentDefinition objectForKey:@"UI"]) {
            NSMutableDictionary *uielem = [[NSMutableDictionary alloc]init];
            [uielem setObject:[dict objectForKey:@"key"] forKey:@"key"];
            [uielem setObject:[dict objectForKey:@"type"] forKey:@"type"];
            [uiValues addObject:uielem];
        }
        
        style = [[MIAStyle alloc]initWithComponent:comp uiElements:uiValues];
//    }
    */
    [self.delegate confirmComponentWindow:self didConfirmComponent:comp withAssociatedStyle:style];
    
    [self close];
}


- (IBAction)cancel:(id)sender {
    [self close];
}
-(void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSComboBox *box= (NSComboBox *)notification.object;
    NSString *path = self.searchPathTextfield.stringValue;
    NSDictionary *valueDic = [self->_namesComponentDataSource objectAtIndex:box.indexOfSelectedItem];
    NSDictionary *def = [CompsReader componentWithName:[valueDic objectForKey:@"name"] inPath:path];
    if (def) {
        [self foundComponentWithName:[valueDic objectForKey:@"name"] andDefinition:def];
    }else{
        [self componentNotFound];
    }
}

-(void)comboBoxSelectionIsChanging:(NSNotification *)notification{

}
-(void)controlTextDidChange:(NSNotification *)obj{
    NSTextField *textfield= (NSTextField *)obj.object;
    
    NSString *path = self.searchPathTextfield.stringValue;
    NSDictionary *def = [CompsReader componentWithName:textfield.stringValue inPath:path];
    if (def) {
        [self foundComponentWithName:textfield.stringValue andDefinition:def];
    }else{
        [self componentNotFound];
    }
    
    
    if (textfield.stringValue  == nil || ![textfield.stringValue length]) {
        self->_namesComponentDataSource = self->_all_components;
    }else
    {
        self->_namesComponentDataSource = [self filterBy:textfield.stringValue];
    }
    [self.nameBox reloadData];

}
-(void)foundComponentWithName:(NSString *)componentName andDefinition:(NSDictionary *)def{
    self.tmpDefinition = def;
    self.foundLabel.stringValue = @"found";
    self.foundLabel.textColor = [Utils colorWithHexColorString:@"277455" alpha:1];
    NSArray *elements = [self.tmpDefinition objectForKey:@"UI"];
    [self.styleData updateDataSource:elements];
    [self.styleElementsTable reloadData];
}
-(void)componentNotFound{
    self.tmpDefinition = nil;
    self.foundLabel.stringValue = @"not found";
    self.foundLabel.textColor = [Utils colorWithHexColorString:@"333333" alpha:1];
    [self.styleData updateDataSource:@[]];
    [self.styleElementsTable reloadData];
}

#pragma mark -  component box -
-(void)comboBoxWillPopUp:(NSNotification *)notification{
    [self.nameBox reloadData];
}
-(void)comboBoxWillDismiss:(NSNotification *)notification{
    [self.nameBox reloadData];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox*)aComboBox {
    return self->_namesComponentDataSource.count;
}

- (id)comboBox:(NSComboBox*)aComboBox
objectValueForItemAtIndex:(NSInteger)index {
    return [[self->_namesComponentDataSource objectAtIndex:index] objectForKey:@"name"];
    
}

- (NSArray*)filterBy:(NSString*)text {
    NSPredicate* resultPredicate =
    [NSPredicate predicateWithFormat:@"name contains %@", text];
    return [self->_all_components filteredArrayUsingPredicate:resultPredicate];
}
#pragma mark - StyleTableDataDource delegate -
-(void)tableDataSource:(StyleElementsTableSource *)tableDataSource didSelectItem:(id)item{
    
    NSDictionary *styleDef = [StyleDefinitions styleDictionaryFromUIKey:[item objectForKey:@"type"]];
    [self.stylesArgsView addParameters:[styleDef allKeys]];
    
}

@end
