//
//  AppDelegate.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 27/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "AppDelegate.h"

#import "ComponentsView.h"
#import "JunctionsView.h"
#import "StylerView.h"

#import "MIAConfiguration.h"
#import "Utils.h"
#import "NoodleLineNumberView.h"
#import "ConfirmComponentWindow.h"
#import "ConfirmJunctionWindow.h"
#import "MIAObjectsDecoder.h"
#import "MIAConfigurationPrinter.h"

#import "CustomButton.h"
#import "JunctionsLinker.h"

@interface AppDelegate ()<NSTextViewDelegate,ComponentWindowProtocol,ComponentsViewProtocol,JunctionWindowProtocol,JunctionsViewProtocol,JunctionsLinkerProtocol,StylerViewProtocol>
@property (unsafe_unretained) IBOutlet NSTextView *jsonView;
@property (weak) IBOutlet NSScrollView *scrollerJson;
@property (weak) IBOutlet ComponentsView *componentsView;
@property (weak) IBOutlet JunctionsView *junctionsView;
@property (weak) IBOutlet StylerView *stylerView;
@property (weak) IBOutlet NSTextField *validTextfield;

@property (weak) IBOutlet NSWindow *window;

@property (strong) ConfirmComponentWindow *confirmComponentWin;
@property (strong) ConfirmJunctionWindow *confirmJunctionWin;

@property (strong) MIAConfiguration *mainConfiguration;
@property (strong) JunctionsLinker *junctionsLinker;
@property (weak) MIAObject *selectedObject;
@property (weak) IBOutlet CustomButton *addComponentButton;
@property (weak) IBOutlet CustomButton *addJunctionButton;
@property (weak) IBOutlet CustomButton *printAllButton;


@property (strong) NSMutableDictionary *tmp_addings;
@end
static NSDictionary * listMap;
@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self load];
}
-(void)mainStyle{
    
    [self.addComponentButton changeBgColor:[Utils colorWithHexColorString:@"468746" alpha:1]];
    [self.addJunctionButton changeBgColor:[Utils colorWithHexColorString:@"3E536E" alpha:1]];
    [self.printAllButton changeBgColor:[Utils colorWithHexColorString:@"ffffff" alpha:1]];
    [self.printAllButton changeTextColor:[Utils colorWithHexColorString:@"666666" alpha:1]];

    [self.addJunctionButton setNeedsDisplay:YES];
    [self.addComponentButton setNeedsDisplay:YES];
    [self.printAllButton setNeedsDisplay:YES];
    
}
- (void)load {
    [self mainStyle];
    
    listMap = @{NSStringFromClass([MIAJunction class]):self.junctionsView,
                NSStringFromClass([MIAComponent class]):self.componentsView,
                NSStringFromClass([MIAStyle class]):self.stylerView
                };
    
    self.window.appearance = [NSAppearance
       appearanceNamed:NSAppearanceNameVibrantLight];
    self.window.titlebarAppearsTransparent = YES;
    
    self.tmp_addings = [[NSMutableDictionary alloc]init];
    self.validTextfield.stringValue = @"valid";
    self.validTextfield.textColor = [Utils colorWithHexColorString:@"277455" alpha:1];
    self.scrollerJson.hasVerticalRuler = YES;
    self.scrollerJson.rulersVisible = YES;
    
    NoodleLineNumberView *lineView = [[NoodleLineNumberView alloc] initWithScrollView:self.scrollerJson];
    lineView.backgroundColor = [Utils colorWithHexColorString:@"ffffff" alpha:1];
    lineView.textColor = [Utils colorWithHexColorString:@"666666" alpha:1];
    lineView.alternateTextColor  = [Utils colorWithHexColorString:@"ffffff" alpha:1];
    self.scrollerJson.verticalRulerView = lineView;
    self.scrollerJson.hasHorizontalRuler = NO;
    self.jsonView.delegate = self;
    self.jsonView.font = [NSFont fontWithName:@"Menlo-Regular" size:13];
    self.jsonView.automaticQuoteSubstitutionEnabled = NO;

    self.componentsView.delegate = self;
    self.junctionsView.delegate = self;
    self.stylerView.delegate = self;
    
    self.mainConfiguration = [[MIAConfiguration alloc]init];
    [self.jsonView setVerticallyResizable:YES];
    [self.scrollerJson setAutohidesScrollers:NO];
    [self.scrollerJson setHasVerticalScroller:YES];
    
    
    self.junctionsLinker = [[JunctionsLinker alloc]initWithDelegate:self];
}
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)clear:(id)sender {
    [self.mainConfiguration removeAll:^(BOOL success) {
        [self.tmp_addings removeAllObjects];
        [self.junctionsView removeAll];
        [self.componentsView removeAll];
    }];
}
- (IBAction)openFile:(id)sender {
    
    [Utils openFileInWindow:self.window completionHandler:^(NSString *path) {
        [self clear:nil];

        NSString *jsonString = [Utils loadStringFromFilePath:path];
        
        NSError *error;
        NSDictionary *json = [Utils dictionaryFromString:jsonString error:&error];
        if (error) {
            NSLog(@"error : %@",error);
            return ;
        }
        
        NSArray <MIAComponent *> *components = [MIAObjectsDecoder componentsFromJson:json];
        for (MIAComponent*comp in components) {
            [self.mainConfiguration addComponent:comp];
            [self.componentsView addComponent:comp];
        }
        NSArray <MIAJunction *> *junctions = [MIAObjectsDecoder junctionsFromJson:json withComponents:[self.mainConfiguration components]];
       
        for (MIAJunction *junc in junctions) {
            [self.mainConfiguration addJunction:junc];
            [self.junctionsView addJunction:junc];
        }
        [self.junctionsLinker buildChains];
        [self.junctionsView applyStyleToJunctionChains:(NSArray *)[self.junctionsLinker chains]];
        
        // this is for the addings ... remove!!
        for (id key in json) {
            if ([key isEqualToString:@"components"] || [key isEqualToString:@"junctions"] || [key isEqualToString:@"styles"]) {
                continue;
            }
            [self.tmp_addings setObject:[json objectForKey:key] forKey:key];
        }
    }];
    
}

- (IBAction)addComponent:(id)sender {
    self.confirmComponentWin =
    [[ConfirmComponentWindow alloc] initWithWindowNibName:@"ConfirmComponentWindow"];
    self.confirmComponentWin.delegate = self;
    [self.confirmComponentWin showWindow:self];
}
- (IBAction)addJunction:(id)sender {
    self.confirmJunctionWin =
    [[ConfirmJunctionWindow alloc] initWithWindowNibName:@"ConfirmJunctionWindow" components:[self.mainConfiguration components]];
    self.confirmJunctionWin.delegate = self;
    [self.confirmJunctionWin showWindow:self];
}
#pragma mark - junction linker protocol
-(NSArray<MIAJunction *> *)junctionsLinker:(JunctionsLinker *)linker askJunctions:(BOOL)ask{
    if (!ask) {
        return nil;
    }
    return [self.mainConfiguration junctions];
}
#pragma mark - stack view delegate -
-(void)stackView:(StackView *)stackView wantsToUp:(BOOL)up object:(MIAUIObject *)uiobject completion:(void (^)(NSArray<MIAObject *> *))compBlock{

    MIAObject *object = [self.mainConfiguration objectFromID:uiobject.uuid];
    BOOL moved = [self.mainConfiguration moveObject:object up:up];
    if (!moved) {
        return;
    }
    NSArray *arrayOfObjects = nil;
    if([object isKindOfClass:[MIAComponent class]]){
        arrayOfObjects = [self.mainConfiguration components];
    }
    if([object isKindOfClass:[MIAJunction class]]){
        arrayOfObjects = [self.mainConfiguration junctions];
        
        // the junctions linker changes the style only of you change the order of the junctions
        [self.junctionsLinker buildChains];
        [self.junctionsView applyStyleToJunctionChains:(NSArray *)[self.junctionsLinker chains]];
    }
    compBlock(arrayOfObjects);
}

#pragma mark - confirm component delegate -
-(void)confirmComponentWindow:(ConfirmComponentWindow *)window didConfirmComponent:(MIAComponent *)component{
    BOOL added =  [self.mainConfiguration addComponent:component];
    if (!added) {
        return;
    }
    [self.componentsView addComponent:component];
    
    // to do : add also the style
    // creating a style
    // to do : implement a check if the component is a UI component
    
    MIAStyle *style = [[MIAStyle alloc]initWithUid:[[component dataDict] objectForKey:@"uid"]];
    BOOL stylerIsAdded = [self.mainConfiguration addStyle:style];
    if (!stylerIsAdded) {
        return;
    }
    [self.stylerView addStyle:style];
}
#pragma mark - components view delegate -
-(void)componentsView:(ComponentsView *)view wantsRemoveComponentWithId:(NSString *)uuid completion:(void (^)(void))compBlock{
    BOOL removed = [self.mainConfiguration removeFromID:uuid];
    if (!removed) {
        return;
    }
    compBlock();
    
    
    NSMutableArray *junctionsCopy = [[NSMutableArray alloc]initWithArray:[self.mainConfiguration junctions]];
    for (MIAJunction *junction in junctionsCopy) {
        if ([[junction senderUUID] isEqualToString:uuid] || [[junction receiverUUID] isEqualToString:uuid]) {
           BOOL removed = [self.mainConfiguration removeJunction:junction];
            if (!removed) {
                continue;
            }
            [self.junctionsView forceRemoveJunctionWithId:junction.uuid];
        }
    }
    
    [self printJson:@{}];
}
-(void)componentsView:(ComponentsView *)view tappedComponentWithId:(NSString *)uuid{
    
    if ([self.selectedObject.uuid isEqualToString:uuid]) {
        [view applySelectionFromId:nil];
        self.selectedObject = nil;
        [self printJson:@{}];
        return;
    }

    self.selectedObject = nil;
    MIAObject *obj = [self.mainConfiguration objectFromID:uuid];
    [view applySelectionFromId:uuid];
    [self printJson:[obj dataDict]];
    self.selectedObject = obj;
    
    
    
}

#pragma marl - confirm junction delegate
-(void)confirmJunctionWindow:(ConfirmJunctionWindow *)window didConfirmJunction:(MIAJunction *)junction{
    BOOL added = [self.mainConfiguration addJunction:junction];
    if (!added) {
        return;
    }
    [self.junctionsView addJunction:junction];
    
    [self.junctionsLinker buildChains];
    [self.junctionsView applyStyleToJunctionChains:(NSArray *)[self.junctionsLinker chains]];
}
#pragma mark - junctions view delegate -
-(void)junctionsView:(JunctionsView *)view wantsRemoveJunctionWithId:(NSString *)uuid completion:(void (^)(void))compBlock{
    BOOL removed = [self.mainConfiguration removeFromID:uuid];
    if (!removed) {
        return;
    }
    compBlock();
    [self printJson:@{}];
}
-(void)junctionsView:(JunctionsView *)view tappedJunctionWithId:(NSString *)uuid{
    
    if ([self.selectedObject.uuid isEqualToString:uuid]) {
        [view applySelectionFromId:nil];
        self.selectedObject = nil;
        [self printJson:@{}];
        return;
    }
    
    self.selectedObject = nil;
    MIAObject *obj = [self.mainConfiguration objectFromID:uuid];
    [view applySelectionFromId:uuid];
    [self printJson:[obj dataDict]];
    self.selectedObject = obj;

}

#pragma mark - styler view -
-(void)stylerView:(StylerView *)view tappedStyleWithId:(NSString *)uuid{
    if ([self.selectedObject.uuid isEqualToString:uuid]) {
        [view applySelectionFromId:nil];
        self.selectedObject = nil;
        [self printJson:@{}];
        return;
    }
    
    self.selectedObject = nil;
    MIAObject *obj = [self.mainConfiguration objectFromID:uuid];
    [view applySelectionFromId:uuid];
    [self printJson:[obj dataDict]];
    self.selectedObject = obj;
    
}
-(void)stylerView:(StylerView *)view wantsRemoveStyleWithId:(NSString *)uuid completion:(void (^)(void))compBlock{
    // to do : implement
}
#pragma mark - json view
-(void)textViewDidChangeSelection:(NSNotification *)notification{
    NSError *error;
    NSDictionary *dict = [Utils dictionaryFromString:self.jsonView.string error:&error];
    
    
    if (error) {
        self.validTextfield.stringValue = @"error";
        self.validTextfield.textColor = [Utils colorWithHexColorString:@"AA5B39" alpha:1];
        return;
    }
    self.validTextfield.stringValue = @"valid";
    self.validTextfield.textColor = [Utils colorWithHexColorString:@"277455" alpha:1];
    
    
    
    [self.selectedObject update:dict completion:^(NSDictionary *dict) {
        StackView *listView = [listMap objectForKey:[self.selectedObject className]];
        [listView updateObjectWithId:self.selectedObject.uuid withData:dict];
        
        
        [self.mainConfiguration cycleObjects:^(MIAObject *object) {
            StackView *listView = [listMap objectForKey:[object className]];
            [listView updateObjectWithId:object.uuid withData:[object dataDict]];
        }];
    }];
    
    
}

-(void)printJson:(NSDictionary *)json{
    NSString* string = [Utils dictToJsonString:json];
    string = [string stringByReplacingOccurrencesOfString:@"\\/"
                                               withString:@"/"];
    self.jsonView.string = string;
}
- (IBAction)printAll:(id)sender {
    
   NSDictionary *json = [MIAConfigurationPrinter printConfiguration:self.mainConfiguration adds:self.tmp_addings];
    [self printJson:json];
}


@end
