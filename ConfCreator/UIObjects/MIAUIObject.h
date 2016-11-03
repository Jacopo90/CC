//
//  MIAUIObject.h
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 29/10/16.
//  Copyright © 2016 private. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MIAUIObject;

@protocol MIAUIObjectProtocol <NSObject>

-(void)uiObject:(MIAUIObject *)uiobject remove:(BOOL)remove;
-(void)uiObject:(MIAUIObject *)uiobject tapped:(BOOL)tapped;
-(void)uiObject:(MIAUIObject *)uiobject up:(BOOL)up;

@end
@interface MIAUIObject : NSView
@property (nonatomic,weak) id <MIAUIObjectProtocol> delegate;
- (NSString *)uuid;
+ (id)loadFromWithUUID:(NSString *)uuid type:(NSString *)type frame:(CGRect)frame;
- (void)bindData:(NSDictionary *)data;
- (void)select:(BOOL)select;
- (void)selectStyle;
- (void)deselectStyle;
@end
