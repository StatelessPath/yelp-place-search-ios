//
//  RBSLocation.h
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RBSLocation : NSObject

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, assign) CLLocationCoordinate2D *coordinates;

+(id) createWithLatitude:(NSString *)latitude andLongitude:(NSString *)longitude;

@end
