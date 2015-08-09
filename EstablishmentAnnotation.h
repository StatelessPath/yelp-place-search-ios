//
//  EstablishmentAnnotation.h
//  Inbtwn
//
//  Created by Corey Schaf on 7/22/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EstablishmentAnnotation : NSObject <MKAnnotation>

-(id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
-(MKMapItem *)mapItem;

@end
