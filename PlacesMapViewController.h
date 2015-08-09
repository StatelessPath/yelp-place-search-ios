//
//  PlacesMapViewController.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/23/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>

#import "SWTableViewCell.h"

@class Keyword;
@class RBSLocation;

@interface PlacesMapViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, SWTableViewCellDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) RBSLocation *userLocation;
@property (nonatomic, strong) RBSLocation *friendLocation;
@property (nonatomic, strong) RBSLocation *midpointLocation;
@property (nonatomic, strong) Keyword *selectedKeyword;

@property (nonatomic, strong) NSArray *places;

@end
