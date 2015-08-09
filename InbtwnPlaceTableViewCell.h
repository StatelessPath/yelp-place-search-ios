//
//  InbtwnPlaceTableViewCell.h
//  Inbtwn
//
//  Created by Corey Schaf on 5/22/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class Establishment;

@interface InbtwnPlaceTableViewCell : SWTableViewCell


@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImage;
@property (nonatomic, weak) IBOutlet UILabel *placeName;
@property (nonatomic, weak) IBOutlet UILabel *addressOne;
@property (nonatomic, weak) IBOutlet UILabel *addressTwo;
@property (nonatomic, weak) IBOutlet UIImageView *ratingImage;
@property (nonatomic, weak) IBOutlet UILabel *category;


@property (nonatomic, strong) Establishment *establishment;

@end
