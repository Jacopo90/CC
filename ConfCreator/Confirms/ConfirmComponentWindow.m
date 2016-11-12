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
#import "ArgsDataSource.h"


@interface ConfirmComponentWindow ()<NSTextFieldDelegate,NSTextViewDelegate,NSComboBoxDataSource,NSComboBoxDelegate,StyleElementTableDataSourceProtocol,ArgsViewProtocol>
@property (weak) IBOutlet NSComboBox *nameBox;

@property (weak) IBOutlet NSTextField *nameTextfield;
@property (weak) IBOutlet NSTextField *uidTexfield;
@property (weak) IBOutlet NSTextField *searchPathTextfield;
@property (weak) IBOutlet NSTextField *foundLabel;
@property (weak) IBOutlet NSTextField *validLabel;

@property (nonatomic,strong) NSDictionary *tmpComponentDefinition;

@property (nonatomic, strong) NSArray *all_components;
@property (nonatomic, strong) NSArray *namesComponentDataSource;

@property (nonatomic, strong) StyleElementsTableSource *styleData;
@property (nonatomic, strong) ArgsDataSource *argsData;

@property (weak) IBOutlet NSTableView *styleElementsTable;
@property (unsafe_unretained) IBOutlet ArgsView *stylesArgsView;
@property (unsafe_unretained) IBOutlet ArgsView *argsView;
@property (nonatomic,strong) NSDictionary *tmpUIElementDefinition;
@property (weak) IBOutlet NSScrollView *scrollerStylerParameters;


@end

@implementation ConfirmComponentWindow

- (void)windowDidLoad {
    [super windowDidLoad];
 
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
    
    self.argsData = [[ArgsDataSource alloc]init];
    
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
    [self.scrollerStylerParameters setAutohidesScrollers:NO];
    [self.scrollerStylerParameters setHasVerticalScroller:YES];
    
    
    
    [self.stylesArgsView setVerticallyResizable:YES];
    self.stylesArgsView.argsViewdelegate = self;
    self.stylesArgsView.argsViewIdentifier = @"styler_view";
    
    
    self.argsView.argsViewdelegate = self;
    self.argsView.argsViewIdentifier = @"arguments_view";
    

}
- (IBAction)confirmComponent:(id)sender {
    
    if ([self.argsView validate] == nil || [self.stylesArgsView validate] == nil) {
        return;
    }
    
    NSString *nameComponent = self.nameBox.stringValue;
    NSString *uidComponent = self.uidTexfield.stringValue;
    
    if (!nameComponent.length || !uidComponent.length) {
        return;
    }

    MIAComponent *comp = [[MIAComponent alloc]initWithName:nameComponent uid:uidComponent];
    
    [comp updateArgs:[self.argsData datasource]];
    [comp setDefinition:self.tmpComponentDefinition];

    MIAStyle *style = [[MIAStyle alloc]initWithComponent:comp uiElements:[self.styleData datasource]];
    
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
    [self.argsView cleanView];
    [self.stylesArgsView cleanView];
    
    if (def) {
        [self foundComponentWithName:[valueDic objectForKey:@"name"] andDefinition:def];
    }else{
        [self componentNotFound];
    }
}

-(void)controlTextDidChange:(NSNotification *)obj{
    NSTextField *textfield= (NSTextField *)obj.object;
    
    NSString *path = self.searchPathTextfield.stringValue;
    NSDictionary *def = [CompsReader componentWithName:textfield.stringValue inPath:path];
    
    [self.argsView cleanView];
    [self.stylesArgsView cleanView];
    
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
    if (def == nil) {
        self.tmpComponentDefinition = nil;
        return;
    }
    
    self.tmpComponentDefinition = def;
    self.foundLabel.stringValue = @"found";
    self.foundLabel.textColor = [Utils colorWithHexColorString:@"277455" alpha:1];
        
   

    // styles
    [self.styleData clean];
    for (NSDictionary *dict in [self.tmpComponentDefinition objectForKey:@"UI"]) {
        [self.styleData addItemWithKey:[dict objectForKey:@"key"]
                                  type:[dict objectForKey:@"type"]];
    }
    
    // style elements : the datasource is changed after the style data is set
    [self.styleElementsTable reloadData];
    
    
    // args
    [self.argsData clean];
    for (NSDictionary *dict in [self.tmpComponentDefinition objectForKey:@"args"]) {
        [self.argsData addItemWithName:[dict objectForKey:@"name"]
                                  type:[dict objectForKey:@"type"]
                          defaultValue:[dict objectForKey:@"default"]
                                values:[dict objectForKey:@"values"]];
    }
    
    [self.argsView addParameters:[self.argsData keys]];

}
-(void)componentNotFound{
    self.tmpComponentDefinition = nil;
    self.foundLabel.stringValue = @"not found";
    self.foundLabel.textColor = [Utils colorWithHexColorString:@"333333" alpha:1];
    
    [self.styleData clean];
    [self.styleElementsTable reloadData];
    [self.stylesArgsView cleanView];
    
    [self.argsData clean];
    [self.argsView cleanView];
    
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
-(void)tableDataSource:(StyleElementsTableSource *)tableDataSource didSelectItem:(NSDictionary *)item{
    self.tmpUIElementDefinition = item;
    NSDictionary *styleDef = [StyleDefinitions styleDictionaryFromUIKey:[self.tmpUIElementDefinition objectForKey:@"type"]];
    [self.stylesArgsView addParameters:[styleDef allKeys]];
    
}
#pragma mark - args view protocol  -
-(void)argsView:(ArgsView *)argsview validDictionary:(NSDictionary *)dictionary{
    
    if ([argsview.argsViewIdentifier isEqualToString:@"styler_view"]) {
        [self.styleData changeValue:dictionary forItemWithKey:[self.tmpUIElementDefinition objectForKey:@"key"]];
    }
    
    if ([argsview.argsViewIdentifier isEqualToString:@"arguments_view"]) {
        for (NSString *key in dictionary) {
            [self.argsData changeValue:[dictionary objectForKey:key] forItemWithKey:key];
        }
    }
}
@end
