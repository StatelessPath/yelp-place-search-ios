//
//  YelpDataParser.m
//  Inbtwn
//
//  Created by Corey Schaf on 5/21/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "YelpDataParser.h"
#import "Establishment.h"
#import "UIImageResizing.h"

@implementation YelpDataParser

+(NSArray *)buildEstablishmentsFromJSON:(NSData *)jsonData error:(NSError *__autoreleasing *)error{
    
    NSError *localError = nil;
    NSMutableDictionary *places = [NSJSONSerialization
                                   JSONObjectWithData:jsonData
                                   options:NSJSONReadingMutableContainers
                                   error:&localError];
    
    if([places objectForKey:@"error"] || localError != nil){
        NSLog(@"YelpDataParser: Error Getting Yelp Data");
        *error = localError;
        
        //#################################
        
        NSString *postParams = [NSString
                                stringWithFormat:@"&message[application_name]=%@&message[level]=%@&message[long_message]=%@&message[short_message]=%@", @"INBTWN-050", @"4", [places objectForKey:@"error"], @"Method: YelpDataParser.m <buildEstablishmentsFromJson>"];
        
        
            NSData *postData = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://restlog.herokuapp.com/api/v1/messages"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
       
        
        //################################
        
        return nil;
    }else{
        // Continue
        
        NSMutableArray *establishments = [[NSMutableArray alloc] init];
        
        NSArray *results = [places valueForKey:@"businesses"];
        NSLog(@"YelpDataParser: Count of businesses returned: %lu", (unsigned long)results.count);
        
        for(NSDictionary *businessesDict in results){
            Establishment *establishment = [[Establishment alloc] init];
            
            // name
            establishment.name = [businessesDict valueForKey:@"name"];
            
            //identifier
            establishment.identifier = [businessesDict valueForKey:@"id"];
            
            //imageUrl
            establishment.imageUrl = [businessesDict valueForKey:@"image_url"];
            
            //url
            establishment.url = [businessesDict valueForKey:@"url"];
            
            //phone
            establishment.phone = [businessesDict valueForKey:@"phone"];
            
            //displayPhone
            establishment.displayPhone = [businessesDict valueForKey:@"display_phone"];
            
            //categories
            establishment.imageUrl = [businessesDict valueForKey:@"image_url"];
            
            //rating
            establishment.rating = [businessesDict valueForKey:@"rating"];
            
            //rating img url small
            establishment.ratingImgUrlSmall = [businessesDict valueForKey:@"rating_img_url_large"];
            UIImage *ratingImg = [UIImage imageWithData:[NSData
                                                                dataWithContentsOfURL:[NSURL URLWithString:
                                                                                       establishment.ratingImgUrlSmall]]];
            establishment.ratingImage = [ratingImg scaleToSize:CGSizeMake(83.0f, 15.0f)];
            
            UIImage *thumb = [UIImage imageWithData:
                                       [NSData dataWithContentsOfURL:
                                        [NSURL URLWithString:establishment.imageUrl]]];
            establishment.thumbnail = [thumb scaleToSize:CGSizeMake(72.0f, 55.0f)];
            
            NSDictionary *location = [businessesDict objectForKey:@"location"];
            
            NSArray *address = [location objectForKey:@"address"];
            
            if(address.count > 0){
                establishment.addressOne = [address objectAtIndex:0];
            }
            
            establishment.postalCode = [location valueForKey:@"postal_code"];
            establishment.city = [location valueForKey:@"city"];
            establishment.stateCode = [location valueForKey:@"state_code"];
            establishment.addressTwo = [NSString stringWithFormat:@"%@, %@ %@", establishment.city,
                                        establishment.stateCode, establishment.postalCode];
            
            NSArray *categories = [businessesDict objectForKey:@"categories"];
            
            if(categories.count > 0){
                establishment.categories = [categories objectAtIndex:0];
            }
            
            
            
            [establishments addObject:establishment];
        }
        
        return establishments;
        
    }

    
    return nil;
}

@end
