//
//  User.h
//  Poplr
//
//  Created by Corey Schaf on 3/30/14.
//  Copyright (c) 2014 Corey Schaf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface User : NSObject

@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) Location *userLocation;

+(User *) getUser;
//+(Location *)getUserLocation;

-(NSString*)getUserLatitude;
-(NSString*)getUserLongitude;

@end
