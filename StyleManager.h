//
//  StyleManager.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/14/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StyleManager : NSObject

+(StyleManager *)getManager;

@property (strong) UIColor *primary;
@property (strong) UIColor *secondary;
@property (strong) UIColor *alternate;
@property (strong) UIColor *textGrey;

@end
