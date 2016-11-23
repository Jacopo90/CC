//
//  StackView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "StackView.h"

@interface FlippedView : NSView {
}
@end

@implementation FlippedView
- (BOOL) isFlipped
{
    return YES;
}
@end
@interface StackView(){
    NSInteger offsetY;
}
@property (nonatomic,strong) NSMutableArray <MIAUIObject *> *views;
@end
@implementation StackView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.views = [[NSMutableArray alloc]init];
        FlippedView *flippedView = [[FlippedView alloc] initWithFrame:self.bounds];
        offsetY = 10;
        [self setDocumentView:flippedView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidResize:) name:NSWindowDidEndLiveResizeNotification object:self.window];

    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidEndLiveResizeNotification object:self.window];
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.wantsLayer = YES;
    self.layer.masksToBounds    = NO;
    self.layer.shadowColor      = [NSColor blackColor].CGColor;
    self.layer.shadowOpacity    = 0.4;
    self.layer.shadowOffset     = CGSizeMake(0, 0);
    self.layer.shadowRadius     = 5.0;
    self.layer.shouldRasterize  = YES;
    // Drawing code here.
}
-(void)addView:(MIAUIObject *)view{
    
    if (!view || [self.views containsObject:view]) {
        return;
    }
    [self.views addObject:view];
    view.frame = NSMakeRect(view.frame.origin.x, offsetY, view.frame.size.width, view.frame.size.height);
    offsetY+=view.bounds.size.height;

    [[self contentView] addSubview:view];
    
    [self addSpace];
    [self updateScroller];
}
-(void)addSpace{
    offsetY+=10;
}
-(void)removeView:(MIAUIObject *)view{
    if (!view || ![self.views containsObject:view]) {
        return;
    }
    [self.views removeObject:view];
    offsetY-=view.bounds.size.height;
    view.frame = NSMakeRect(0, offsetY, view.frame.size.width, view.frame.size.height);
    [view removeFromSuperview];
   
    [self updateScroller];
}
-(void)removeAll{
    for (NSView *view in self.views) {
        [view removeFromSuperview];
    }
    [self.views removeAllObjects];
    [self updateScroller];
}
-(void)updateScroller{
    offsetY = 10;
    [self cycleObjects:^(MIAUIObject *object) {
        [[object animator] setFrame:CGRectMake(object.frame.origin.x,offsetY, object.frame.size.width, object.frame
                                              .size.height)];
        offsetY += object.frame
        .size.height;
        [self addSpace];
    }];
    ((NSView *)self.documentView).frame = NSMakeRect(0, 0, self.bounds.size.width, offsetY);
}
-(void)cycleObjects:(void(^)(MIAUIObject *object))cycle{
    for (MIAUIObject *obj in self->_views) {
        cycle(obj);
    }
}
-(void)updateObjectWithId:(NSString *)uid withData:(NSDictionary *)data{
    [self cycleObjects:^(MIAUIObject *object) {
        if ([object.uuid isEqualToString:uid]) {
            [object bindData:data];
        }
    }];
}
-(void)reorder:(NSArray <MIAObject *> *)objects{
    
    NSMutableArray *copiedViews = [[NSMutableArray alloc]initWithArray:self->_views];
    for (int i = 0; i<objects.count; i++){
        for (MIAUIObject *uiobj in copiedViews) {
            MIAObject  *obj = objects[i];
            if ([uiobj.uuid isEqualToString:obj.uuid]) {
                [self.views replaceObjectAtIndex:i withObject:uiobj];
                break;
            }
        }
    }
    [self updateScroller];
}
#pragma mark - selection -
-(void)applySelectionFromId:(NSString *)uidObject{
    [self cycleObjects:^(MIAUIObject *object) {
        [object select:[object.uuid isEqualToString:uidObject]];
    }];
}

-(void)applySelectStyle:(MIAUIObject *)uiobject{
    [self cycleObjects:^(MIAUIObject *object) {
        [object select:[object isEqual:uiobject]];
    }];
}
#pragma mark - uiobject delegate -
-(void)uiObject:(MIAUIObject *)uiobject up:(BOOL)up{}
-(void)uiObject:(MIAUIObject *)uiobject tapped:(BOOL)tapped{}
-(void)uiObject:(MIAUIObject *)uiobject remove:(BOOL)remove{}
#pragma mark  - window delegate -
-(void)windowDidResize:(id)object{
    [self updateScroller];
}

@end
