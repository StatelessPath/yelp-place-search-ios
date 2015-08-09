//
//  RBSTransitioningDelegate.m
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "RBSTransitioningDelegate.h"
#import "RBSAnimatedTransitioning.h"

@implementation RBSTransitioningDelegate

-(id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    RBSAnimatedTransitioning *transitioning = [RBSAnimatedTransitioning new];
    return transitioning;
}

-(id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    RBSAnimatedTransitioning *transitioning = [RBSAnimatedTransitioning new];
    transitioning.reverse = YES;
    return transitioning;
}

@end
