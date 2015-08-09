//
//  GeocodeHelper.h
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBSLocation;

@interface GeocodeHelper : NSObject

+(RBSLocation*)getLocationBetween:(RBSLocation*)pointOne and:(RBSLocation*)pointTwo;

@end
