//
//  AppDelegate.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/2/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SearchViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
