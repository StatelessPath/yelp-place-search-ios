//
//  Establishment.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/23/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Establishment : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *displayPhone;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *ratingImgUrlSmall;
@property (nonatomic, strong) NSString *locationAddress;
@property (nonatomic, strong) NSString *addressOne;
@property (nonatomic, strong) NSString *addressTwo;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *stateCode;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *ratingImage;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@property (nonatomic, strong) NSDictionary *neighborhoods;


@end
