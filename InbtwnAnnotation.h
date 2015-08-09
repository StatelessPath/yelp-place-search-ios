//
//  InbtwnAnnotation.h
//  Inbtwn
//
//  Created by Corey Schaf on 8/2/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface InbtwnAnnotation : NSObject <MKAnnotation>

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
-(MKMapItem *)mapItem;

@end
