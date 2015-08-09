//
//  YelpDataParser.h
//  Inbtwn
//
//  Created by Corey Schaf on 5/21/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpDataParser : NSObject

+(NSArray *)buildEstablishmentsFromJSON:(NSData *)jsonData error:(NSError **)error;

@end
