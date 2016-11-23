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
#import "LoadJsonWindow.h"

#import "MIAObjectsDecoder.h"
#import "MIAConfigurationPrinter.h"

#import "MenuView.h"

#import "CustomButton.h"
#import "JunctionsLinker.h"
#import "TesterViewController.h"
#import "ChameleonAppDelegate.h"
#import "FileManager.h"

#import "Alert.h"


@interface AppDelegate ()<NSTextViewDelegate,
                         ComponentWindowProtocol,
                         ComponentsViewProtocol,
                         JunctionWindowProtocol,
                         JunctionsViewProtocol,
                         JunctionsLinkerProtocol,
                         StylerViewProtocol,
                         LoadJsonWindowProtocol,
                         NSWindowDelegate>{
}
@property (unsafe_unretained) IBOutlet NSTextView *jsonView;
@property (weak) IBOutlet NSScrollView *scrollerJson;
@property (weak) IBOutlet ComponentsView *componentsView;
@property (weak) IBOutlet JunctionsView *junctionsView;
@property (weak) IBOutlet StylerView *stylerView;
@property (weak) IBOutlet NSTextField *validTextfield;
@property (weak) IBOutlet MenuView *menuView;
@property (strong) ChameleonAppDelegate *iosApp;


@property (strong) ConfirmComponentWindow *confirmComponentWin;
@property (strong) ConfirmJunctionWindow *confirmJunctionWin;
@property (strong) LoadJsonWindow *loadJsonWindow;

@property (strong) MIAConfiguration *mainConfiguration;
@property (strong) JunctionsLinker *junctionsLinker;
@property (weak) MIAObject *selectedObject;
@property (weak) IBOutlet CustomButton *addComponentButton;
@property (weak) IBOutlet CustomButton *addJunctionButton;
@property (weak) IBOutlet CustomButton *printAllButton;
@property (weak) IBOutlet CustomButton *saveButton;
@property (weak) IBOutlet CustomButton *loadJsonButton;


@property (strong) NSMutableDictionary *tmp_addings;
@end
static NSDictionary * listMap;
@implementation AppDelegate

@synthesize window, chameleonNSView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    chameleonApp = [[ChameleonAppDelegate alloc] init];
    [chameleonNSView launchApplicationWithDelegate:chameleonApp afterDelay:1];

    [self load];
}
-(void)mainStyle{
    
    [self.addComponentButton changeMainColor:[Utils colorWithHexColorString:@"bdc3c7" alpha:1]];
    [self.addComponentButton changeTextColor:[Utils colorWithHexColorString:@"bdc3c7" alpha:1]];
    [self.addComponentButton changeFont:[NSFont fontWithName:@"Roboto-Medium" size:27]];
    [self.addComponentButton changeOffsetY:-8];


    [self.addJunctionButton changeMainColor:[Utils colorWithHexColorString:@"3894d1" alpha:1]];
    [self.addJunctionButton changeTextColor:[Utils colorWithHexColorString:@"3894d1" alpha:1]];
    [self.addJunctionButton changeFont:[NSFont fontWithName:@"Roboto-Medium" size:27]];
    [self.addJunctionButton changeOffsetY:-8];


    [self.printAllButton changeMainColor:[Utils colorWithHexColorString:@"888888" alpha:1]];
    [self.printAllButton changeTextColor:[Utils colorWithHexColorString:@"888888" alpha:1]];
    [self.printAllButton changeFont:[NSFont fontWithName:@"Linearicons-Free" size:25]];
    [self.printAllButton changeText:@"\ue872"];
    [self.printAllButton changeOffsetY:-5];

    
    [self.saveButton changeMainColor:[Utils colorWithHexColorString:@"888888" alpha:1]];
    [self.saveButton changeTextColor:[Utils colorWithHexColorString:@"888888" alpha:1]];
    [self.saveButton changeFont:[NSFont fontWithName:@"Linearicons-Free" size:25]];
    [self.saveButton changeText:@"\ue81e"];
    [self.saveButton changeOffsetY:-5];
    
    [self.loadJsonButton changeMainColor:[Utils colorWithHexColorString:@"888888" alpha:1]];
    [self.loadJsonButton changeTextColor:[Utils colorWithHexColorString:@"888888" alpha:1]];
    [self.loadJsonButton changeFont:[NSFont fontWithName:@"Linearicons-Free" size:25]];
    [self.loadJsonButton changeText:@"\ue867"];
    [self.loadJsonButton changeOffsetY:-5];


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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    
    
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
    self.jsonView.font = [NSFont fontWithName:@"Menlo-Regular" size:12];
    self.jsonView.automaticQuoteSubstitutionEnabled = NO;

    self.componentsView.delegate = self;
    self.junctionsView.delegate = self;
    self.stylerView.delegate = self;
    
    self.mainConfiguration = [[MIAConfiguration alloc]init];
    [self.jsonView setVerticallyResizable:YES];
    [self.scrollerJson setAutohidesScrollers:NO];
    [self.scrollerJson setHasVerticalScroller:YES];
    
    
    self.junctionsLinker = [[JunctionsLinker alloc]initWithDelegate:self];
    
    
    self.window.titleVisibility = YES;
    self.window.styleMask |= NSFullSizeContentViewWindowMask;
    
    self.window.delegate = self;
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
- (IBAction)clear:(id)sender {
    if ([self.mainConfiguration isEmpty] == YES) {
        return ;
    }
    [Alert showAlertWithTitle:@"Vuoi cancellare la tua configurazione?" message:@"l'operazione è irreversibile" confirmBlock:^{
        [self clear:sender completionBlock:nil];
    } cancelBlock:^{
        NSLog(@"you are doing the right job man");
    } inWindow:self.window style:NSCriticalAlertStyle];
}

- (IBAction)openFile:(id)sender {
    
    void (^openFile)(void) = ^void{
        [FileManager openFileInWindow:self.window completionHandler:^(NSString *path) {
            [self clear:nil completionBlock:^{
                NSString *jsonString = [Utils loadStringFromFilePath:path];
                
                NSError *error;
                NSDictionary *json = [Utils dictionaryFromString:jsonString error:&error];
                if (error) {
                    NSLog(@"error : %@",error);
                    return ;
                }
                [self loadJson:json];
            }];
        }];
    };
    if ([self.mainConfiguration isEmpty]) {
        openFile();
        return;
    }

    [Alert showAlertWithTitle:@"Vuoi salvare la tua configurazione?" message:@"" confirmBlock:^{
        [self saveConfiguration:nil completionBlock:^(BOOL success) {
            openFile();
        }];
    } cancelBlock:^{
        openFile();
    } inWindow:self.window style:NSWarningAlertStyle];
  
  
}
-(void)loadJson:(NSDictionary *)json{
    
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
    
    
    NSArray <MIAStyle *> *styles = [MIAObjectsDecoder stylesFromJson:json withComponents:components];
    for (MIAStyle *style in styles) {
        [self.mainConfiguration addStyle:style];
        [self.stylerView addStyle:style];
    }
    
    // this is for the addings ... remove!!
    for (id key in json) {
        if ([key isEqualToString:@"components"] || [key isEqualToString:@"junctions"] || [key isEqualToString:@"styles"]) {
            continue;
        }
        [self.tmp_addings setObject:[json objectForKey:key] forKey:key];
    }
}
- (void)clear:(id)sender completionBlock:(void(^)(void))completion{

    [self.mainConfiguration removeAll:^(BOOL success) {
        [self.tmp_addings removeAllObjects];
        [self.junctionsView removeAll];
        [self.componentsView removeAll];
        [self.stylerView removeAll];
        if (completion != nil) {
            completion();
        }
    }];
}
- (void)saveConfiguration:(id)sender completionBlock:(void(^)(BOOL success))completion{
    NSDictionary *json = [MIAConfigurationPrinter printConfiguration:self.mainConfiguration adds:self.tmp_addings];
    [FileManager exportDocument:@"new_conf" toType:@"json" inWindow:self.window completionHandler:^(NSString *path) {
        if (path == nil) {
            return;
        }
        [FileManager save:json inPath:path completion:^(BOOL success) {
            completion(success);
        }];
    }];
}
-(void)closeConfiguration{
    [Alert showAlertWithTitle:@"Attenzione: vuoi cancellare la tua configurazione?" message:@"l'operazione è irreversibile" confirmBlock:^{
        [self clear:nil completionBlock:^{
            [self.window close];
        }];
    } cancelBlock:^{
        NSLog(@"you are doing the right job man ! ");
    } inWindow:self.window style:NSCriticalAlertStyle];
}
#pragma mark - menu buttons actions -
-(IBAction)close:(id)sender{
    if ([self.mainConfiguration isEmpty] == YES) {
        [self.window close];
        return;
    }
    [self closeConfiguration];
}
-(BOOL)windowShouldClose:(id)sender{
    
    if ([self.mainConfiguration isEmpty] == YES) {
        return YES;
    }
    [self closeConfiguration];
    return NO;
}
- (IBAction)loadConfiguration:(id)sender{
    self.loadJsonWindow =
    [[LoadJsonWindow alloc] initWithWindowNibName:@"LoadJsonWindow"];
    self.loadJsonWindow.delegate = self;
    [self.loadJsonWindow showWindow:self];
}
- (IBAction)printAll:(id)sender {
    
    NSDictionary *json = [MIAConfigurationPrinter printConfiguration:self.mainConfiguration adds:self.tmp_addings];
    [self printJson:json];
}

-(IBAction)saveConfiguration:(id)sender{
    [self saveConfiguration:sender completionBlock:^(BOOL success) {
        [Alert showAlertWithTitle:@"Configurazione salvata!" message:@"" confirmBlock:^{
            
        } cancelBlock:^{
            
        } inWindow:self.window style:NSInformationalAlertStyle];
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
#pragma mark - json load protocol -
-(void)loadJsonWindow:(LoadJsonWindow *)loadJsonWindow confirmJson:(NSDictionary *)jsonDict{
    if (jsonDict == nil) {
        return;
    }
    
    if ([self.mainConfiguration isEmpty]) {
        [self loadJson:jsonDict];
        return;
    }
    
    [Alert showAlertWithTitle:@"Vuoi salvare la tua configurazione?" message:@"" confirmBlock:^{
        [self saveConfiguration:nil completionBlock:^(BOOL success) {
            [self clear:nil completionBlock:^{
                [self loadJson:jsonDict];
            }];
        }];
    } cancelBlock:^{
        [self clear:nil completionBlock:^{
            [self loadJson:jsonDict];
        }];
    } inWindow:self.window style:NSWarningAlertStyle];
    
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
-(void)confirmComponentWindow:(ConfirmComponentWindow *)window didConfirmComponent:(MIAComponent *)component withAssociatedStyle:(MIAStyle *)style{
    BOOL added =  [self.mainConfiguration addComponent:component];
    if (!added) {
        return;
    }
    [self.componentsView addComponent:component];
    
    if (style == nil){
        return;
    }
    BOOL styleAdded = [self.mainConfiguration addStyle:style];
    if (!styleAdded) {
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
    
    NSMutableArray *stylesCopy = [[NSMutableArray alloc]initWithArray:[self.mainConfiguration styles]];
    for (MIAStyle *style in stylesCopy) {
        if ([[style componentUID] isEqualToString:uuid]) {
            BOOL removed = [self.mainConfiguration removeStyle:style];
            if (!removed) {
                continue;
            }
            [self.stylerView forceRemoveStyleWithId:style.uuid];
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
    self.jsonView.string = @"";
    NSString* string = [Utils dictToJsonString:json];
    string = [string stringByReplacingOccurrencesOfString:@"\\/"
                                               withString:@"/"];
    self.jsonView.string = string;
}

@end
