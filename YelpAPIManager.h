//
//  YelpAPIManager.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/29/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBSLocation;

@class Establishment;

@interface YelpAPIManager : NSObject<NSURLConnectionDelegate>

//+(YelpAPIManager *)getManager;

-(NSArray*)getEstablishmentsByUserLocation;
-(void)getYelpResponseData:(RBSLocation*)midpoint withParameters:(NSString*)parameters;

@end
