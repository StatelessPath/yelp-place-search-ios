//
//  SearchPlacesViewController.h
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSLoadingIndicator.h"
#import "Keyword.h"

@interface SearchPlacesViewController : UIViewController 

@property (nonatomic, strong) NSString* friendsLocationAddressString;
@property (nonatomic, strong) NSString* userAddressString;
@property (nonatomic, strong) NSString* categoryCode;
@property (nonatomic, strong) Keyword* keyword;
@property (assign) BOOL willUseUserCoordinates;

@end
