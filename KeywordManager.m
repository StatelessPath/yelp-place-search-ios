//
//  KeywordManager.m
//  Inbtwn
//
//  Created by Corey Schaf on 4/18/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "KeywordManager.h"
#import "Keyword.h"

@interface KeywordManager ()

@property (nonatomic, strong) NSMutableArray *keywordStrings;

@end

@implementation KeywordManager

static KeywordManager *s_sharedContext = nil;

+(KeywordManager *)getManager{
    if(!s_sharedContext){
        s_sharedContext = [[self alloc] init];
    }
    
    return s_sharedContext;
}

-(id)init{
    if(self = [super init]){
        [self initKeywords];
    }
    
    return self;
}

-(void)initKeywords{
    
    //self.keywordStrings = [[NSMutableArray alloc] init];
    
    self.keywords = [[NSMutableArray alloc] init];
    
    Keyword *k1 = [Keyword createWithName:@"Coffee" andCode:@"coffeeshops"
                                    andId:nil andSingle:@"Coffee Shop" andMultiple:@"Coffee Shops"];
    [self.keywords addObject:k1];
    
    Keyword *k2 = [Keyword createWithName:@"Bars" andCode:@"bars" andId:nil andSingle:@"Bar" andMultiple:@"Bars"];
    [self.keywords addObject:k2];
    
    Keyword *k3 = [Keyword createWithName:@"Restaurants" andCode:@"restaurants" andId:nil andSingle:@"Restaurant" andMultiple:@"Restaurants"];
    [self.keywords addObject:k3];
    
    Keyword *k4 = [Keyword createWithName:@"Nightlife" andCode:@"nightlife" andId:nil andSingle:@"Nightlife" andMultiple:@"Nightlife"];
    [self.keywords addObject:k4];
    
    Keyword *k5 = [Keyword createWithName:@"Clubs" andCode:@"danceclubs" andId:nil andSingle:@"Club" andMultiple:@"Clubs"];
    [self.keywords addObject:k5];
    
    Keyword *k6 = [Keyword createWithName:@"Music" andCode:@"musicvenues" andId:nil andSingle:@"Music Venue" andMultiple:@"Music Venues"];
    [self.keywords addObject:k6];
    
    Keyword *k7 = [Keyword createWithName:@"Movies" andCode:@"movietheaters" andId:nil andSingle:@"Movie Theater" andMultiple:@"Movie Theaters"];
    [self.keywords addObject:k7];
    
    
}
@end
