//
//  StyleManager.m
//  Inbtwn
//
//  Created by Corey Schaf on 4/14/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "StyleManager.h"

@implementation StyleManager

#define UIColorFromRGB(rgbValue) [UIColor \
        colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
        green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
        blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static StyleManager *s_sharedContext = nil;

+(StyleManager *)getManager{
    if(!s_sharedContext){
        s_sharedContext = [[self alloc] init];
    }
    
    return s_sharedContext;
}

-(id)init{
    if(self = [super init]){
        [self initColors];
    }
    
    return self;
}

#pragma mark private methods
-(void)initColors{
    
    self.primary = UIColorFromRGB(0x009DCB);
    self.secondary = UIColorFromRGB(0x6FBEE5);
    self.alternate = UIColorFromRGB(0x7CBFB7);
    self.textGrey = UIColorFromRGB(0x828282);
    
}

@end
