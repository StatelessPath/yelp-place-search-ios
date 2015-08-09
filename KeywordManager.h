//
//  KeywordManager.h
//  Inbtwn
//
//  Created by Corey Schaf on 4/18/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

// This class will handle and store all the keywords used in the search
@interface KeywordManager : NSObject

@property (nonatomic, strong) NSMutableArray *keywords;

+(KeywordManager *)getManager;


@end
