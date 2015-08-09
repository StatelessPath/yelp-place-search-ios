//
//  User.m
//  Poplr
//
//  Created by Corey Schaf on 3/30/14.
//  Copyright (c) 2014 Corey Schaf. All rights reserved.
//

#import "User.h"
#import "RBSLocation.h"

@implementation User

static User *s_sharedContext = nil;

+(User *) getUser{
    if(!s_sharedContext){
        s_sharedContext = [[self alloc] init];
        
    }
    
    return s_sharedContext;
}

-(id)init{
    
    if(self = [super init]){
        [self initLocationServices];
        
    }
    
    return self;
}

#pragma mark CLLocation Services
-(void)initLocationServices{
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager startUpdatingLocation];
    
}

-(NSString*)getUserLatitude{
    
    // TODO null checks for not using location services
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}

-(NSString*)getUserLongitude{
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}

-(RBSLocation*)getUserLocationItem{
    RBSLocation *loc = [[RBSLocation alloc] init];
    loc.latitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
    loc.longitude = [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
    
    return loc;
    
}

-(void)updateLocation{
    [self.locationManager startUpdatingLocation];
}

@end
