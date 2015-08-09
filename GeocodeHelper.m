//
//  GeocodeHelper.m
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "GeocodeHelper.h"
#import "RBSLocation.h"

@implementation GeocodeHelper

// x1 + x2 / 2, for lat and long
+(RBSLocation *)getLocationBetween:(RBSLocation *)pointOne and:(RBSLocation *)pointTwo{
    
    double lat1 = pointOne.latitude.doubleValue;
    double long1 = pointOne.longitude.doubleValue;
    
    double lat2 = pointTwo.latitude.doubleValue;
    double long2 = pointTwo.longitude.doubleValue;
    
    double midpointLat = (lat1 + lat2) / 2;
    double midpointLong = (long1 + long2) / 2;
    
    RBSLocation* midpoint = [[RBSLocation alloc] init];
    midpoint.latitude = [NSString stringWithFormat:@"%f", midpointLat];
    midpoint.longitude = [NSString stringWithFormat:@"%f", midpointLong];
    
    return midpoint;
}

@end
