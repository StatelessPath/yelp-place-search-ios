//
//  SearchViewController.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/7/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"



@interface SearchViewController : UIViewController<NSURLConnectionDelegate,
UITextFieldDelegate,
    iCarouselDataSource,
    iCarouselDelegate>

@property (nonatomic, strong) IBOutlet iCarousel *carousel;

@end
