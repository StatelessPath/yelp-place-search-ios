//
//  YelpAPIManager.m
//  Inbtwn
//
//  Created by Corey Schaf on 4/29/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "YelpAPIManager.h"
#import "Establishment.h"
#import "AFOAuth1Client.h"
#import "User.h"
#import "RBSLocation.h"
#import "YelpDataParser.h"

#import "OAuthConsumer.h"


@interface YelpAPIManager(){

    NSData *_responseData;
    NSURLSession *_session;

}
@end

@implementation YelpAPIManager

#define kConsumerKey @""
#define kConsumerKeySecret @""
#define kToken @""
#define kTokenSecret @"-"


#define kApiPath @"http://api.yelp.com/v2/search"
#define kEstablishmentPattern @"/v2/search"

#define kYelpDidErrorOnGet @"com.roguebit.yelperror"

//static YelpAPIManager *s_sharedContext = nil;
//
//+(YelpAPIManager *)getManager{
//
//    if(!s_sharedContext){
//        s_sharedContext = [[self alloc] init];
//    }
//
//
//
//    return s_sharedContext;
//}

-(id) init{

    if(self = [super init]){

        NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];

        // 3
        _session = [NSURLSession sessionWithConfiguration:config];

        //NSString *params = @"test";

        //[self getEstablishmentOAConsumerWithParameters:params];
    }

    return self;
}

#pragma mark public methods
-(NSArray *)getEstablishmentsByUserLocation{

    NSString *locationParams = [self buildLocationParameters];

    //[self getEstablishmentOAConsumerWithParameters:locationParams];

    return nil;
}

#pragma mark Query Helpers
-(NSString *)buildLocationParameters{

    User *user = [User getUser];

    // check if user has their location saved to them
    NSString *lat = [user getUserLatitude];
    NSString *lng = [user getUserLongitude];

    NSString *locationParams = [NSString
                                stringWithFormat:@"latitude=%@&longitude=%@",
                                lat, lng];

    return locationParams;
}

#pragma mark Places Helpers


#pragma mark OAuth Configuration

-(OAMutableURLRequest*)getOAuthRequestWithParameters:(NSString*)parameters{

    NSString *fullQueryString = [NSString stringWithFormat:@"%@?%@", kApiPath, parameters];

    NSString *params1 = [parameters stringByReplacingOccurrencesOfString:@"&" withString:@"|"];
    NSString *params2 = [fullQueryString stringByReplacingOccurrencesOfString:@"&" withString:@"|"];
    params2 = [params2 stringByReplacingOccurrencesOfString:@"?" withString:@"|"];

    NSString *postParams = [NSString
                            stringWithFormat:@"&message[application_name]=%@&message[level]=%@&message[long_message]=%@&message[short_message]=%@", @"INBTWN-050", @"5",
                                [NSString stringWithFormat:@"URL %@, Params %@", params2, params1]
                            , @"Method: OAUth"];
    [self log:postParams];

    NSURL *url = [NSURL URLWithString:fullQueryString];
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerKeySecret];
    OAToken *token = [[OAToken alloc] initWithKey:kToken secret:kTokenSecret];

    id<OASignatureProviding, NSObject> provider = [[OAHMAC_SHA1SignatureProvider alloc] init];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:consumer
                                                                      token:token
                                                                      realm:nil
                                                          signatureProvider:provider];


    [request prepare];
    return request;


}

-(void)getYelpResponseData:(RBSLocation*)midpoint withParameters:(NSString*)parameters{

    // get oauth header
    OAMutableURLRequest *request = [self getOAuthRequestWithParameters:parameters];
    // call establisemtn api
    [[_session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"Completed Session Handler");


        if(error){
            NSLog(@"Error Occured");

            [[NSNotificationCenter defaultCenter] postNotificationName:kYelpDidErrorOnGet object:error];

            // Notify view of errors

        }else{
            // handle JSON error from YELP before sending to parser
            // get response
            // send response to establishent parser
            NSError *error;

            NSString *postParams = [NSString
                                    stringWithFormat:@"&message[application_name]=%@&message[level]=%@&message[long_message]=%@&message[short_message]=%@", @"INBTWN-050", @"4",
                                   [parameters stringByReplacingOccurrencesOfString:@"&" withString:@"|"] , @"Method: getYelpREsponseData"];
            [self log:postParams];

            NSArray *places = [YelpDataParser buildEstablishmentsFromJSON:data error:&error];

            if(places != nil){
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"com.roguebit.intbwn.yelpplaces"
                 object:places];
            }else{
                //TODO: Notify of Error
                [[NSNotificationCenter defaultCenter] postNotificationName:kYelpDidErrorOnGet object:error];
            }
        }
    }]resume];

        // TODO: Handle errors

}

#pragma mark RestLog
-(void)log:(NSString*)params{

    NSString *postParams = params;
    NSData *postData = [postParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://restlog.herokuapp.com/api/v1/messages"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

@end
