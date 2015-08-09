//
//  RBSLocation.m
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "RBSLocation.h"

@implementation RBSLocation

+(id) createWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude{
    return [[self alloc] initWithLatitude:latitude andLongitude:longitude];
}

-(id) initWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude{
    
    if(self = [super init]){
        
        _latitude = [latitude copy];
        _longitude = [longitude copy];
        
    }
               
    return self;
}

@end
