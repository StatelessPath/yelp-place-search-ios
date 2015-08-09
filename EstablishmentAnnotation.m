//
//  EstablishmentAnnotation.m
//  Inbtwn
//
//  Created by Corey Schaf on 7/22/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "EstablishmentAnnotation.h"
#import <AddressBook/AddressBook.h>

@interface EstablishmentAnnotation ()

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

@end

@implementation EstablishmentAnnotation

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"N/A";
        }
        self.address = address;
        self.theCoordinate = coordinate;
           }
    return self;
}

- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

#pragma mark MKAnnotation Protocol

-(MKMapItem *)mapItem{
    
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;

    
    return mapItem;
}

@end
