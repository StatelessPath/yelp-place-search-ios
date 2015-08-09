//
//  Keyword.m
//  Inbtwn
//
//  Created by Corey Schaf on 4/18/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "Keyword.h"

@implementation Keyword

+(id)createWithName:(NSString *)name andCode:(NSString *)code andId:(int)identifier andSingle:(NSString*)single
        andMultiple:(NSString*)multiple{
    return [[self alloc] initWithname:name andCode:code andId:identifier andSingle:single andMultiple:multiple];
}

-(id)initWithname:(NSString *)name andCode:(NSString*)code andId:(int)identifier andSingle:(NSString*)single
      andMultiple:(NSString*)multiple{
    if(self = [super init]){
        self.name = name;
        self.code = code;
        self.identifier = identifier;
        self.singleResultHeader = single;
        self.multipleResultHeader = multiple;
    }
    
    return self;
}

@end
