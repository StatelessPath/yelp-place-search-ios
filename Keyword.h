//
//  Keyword.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/18/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Keyword : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *singleResultHeader;
@property (nonatomic, strong) NSString *multipleResultHeader;
@property (assign) int identifier;

+(id) createWithName:(NSString*)name andCode:(NSString *)code andId:(int)identifier andSingle:(NSString*)single
         andMultiple:(NSString*)multiple;

@end
