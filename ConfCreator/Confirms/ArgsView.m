//
//  ArgsView.m
//  ConfCreator
//
//  Created by Jacopo Pappalettera on 09/11/16.
//  Copyright © 2016 private. All rights reserved.
//

#import "ArgsView.h"
#import "Utils.h"

@interface ArgsView()<NSTextViewDelegate>{
    NSString *_json;
    NSMutableArray *_params;
}
@end

@implementation ArgsView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.delegate = self;
        self->_params = [[NSMutableArray alloc]init];
        self.font = [NSFont fontWithName:@"Menlo-Regular" size:13];
        self.automaticQuoteSubstitutionEnabled = NO;
    }
    return self;
}
- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    // Drawing code here.
}
-(void)addParameters:(NSArray *)inputParameters{
    for (id value in inputParameters) {
        [self addParameter:value];
    }
    [self print];
}
-(void)addParameter:(id)param{
    [self->_params addObject:param];
}

-(void)print{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (id param in self->_params) {
        
        
        [dict setObject:@"" forKey:param];
    }
    [self printJson:(NSDictionary *)dict];
}
-(void)printJson:(NSDictionary *)json{
    NSString* string = [Utils dictToJsonString:json];
    string = [string stringByReplacingOccurrencesOfString:@"\\/"
                                               withString:@"/"];
    self.string = string;
}
-(void)clean{
    [self->_params removeAllObjects];
    self.string = nil;
}


-(NSDictionary *)dictionary{
    NSDictionary *jsonDict = [self validate];
    NSMutableDictionary *filledDictionary = [[NSMutableDictionary alloc]init];
    
    for (NSString *key in jsonDict) {
        id value = [jsonDict objectForKey:key];
        if ( value == nil || [value length] == 0) {
            continue;
        }
        [filledDictionary setObject:[jsonDict objectForKey:key] forKey:key];
    }
    if(filledDictionary == nil || filledDictionary.count == 0){
        return nil;
    }
    return filledDictionary;
}
-(NSDictionary *)validate{
    NSError *error;
    NSDictionary *dict = [Utils dictionaryFromString:self.string error:&error];
    if (error) {
        return nil;
    }
    return dict;
}
-(void)textViewDidChangeSelection:(NSNotification *)notification{

    NSDictionary *json = [self dictionary];
    if (json == nil) {
        // to do change label validation
        return;
    }
    
    if ([self.argsViewdelegate respondsToSelector:@selector(argsView:validDictionary:)]) {
        [self.argsViewdelegate argsView:self validDictionary:json];
    }
}

@end
