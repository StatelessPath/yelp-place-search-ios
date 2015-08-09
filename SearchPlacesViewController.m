//
//  SearchPlacesViewController.m
//  Inbtwn
//
//  Created by Corey Schaf on 5/19/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "SearchPlacesViewController.h"
#import "YelpAPIManager.h"
#import "Establishment.h"
#import "RBSLocation.h"
#import "RBSTransitioningDelegate.h"
#import "GeocodeHelper.h"
#import "PlacesMapViewController.h"
#import "User.h"
#import "RSLoadingIndicator.h"

#import <CoreLocation/CoreLocation.h>

#define kGeoCodingCompletionNotification @"com.roguebit.inbtwn.geocode"
#define kYelpDataParsedNotification @"com.roguebit.intbwn.yelpplaces"
#define kYelpDidErrorOnGet @"com.roguebit.yelperror"

@interface SearchPlacesViewController (){
    RSLoadingIndicator *indicator;
    
    NSTimer *ticker;
    
    NSTimer *stopTimer;
}

@property (nonatomic, strong) CLGeocoder *geoCoder;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) RBSLocation *userLocation;
@property (nonatomic, strong) RBSLocation *friendLocation;
@property (nonatomic, strong) RBSLocation *midpoint;

@end

@implementation SearchPlacesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _geoCoder = [[CLGeocoder alloc] init];
        self.friendLocation = [[RBSLocation alloc] init];
        self.userLocation = [[RBSLocation alloc] init];
        self.midpoint = [[RBSLocation alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    self.geoCoder = nil;
    self.locationManager = nil;
    self.userLocation = nil;
    self.friendLocation = nil;
    self.midpoint = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    
   // [self initLoaderIndicator];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getYelpEstablishments:)
                                                 name:kGeoCodingCompletionNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveApiResponseObjects:)
                                                 name:kYelpDataParsedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didErrorOnYelpData:)
                                                 name:kYelpDidErrorOnGet object:nil];

    
    NSLog(@"View 2 - SearchPlaces - viewDidAppear");
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        // Geocode friends address string
        [self geocodeFriendAddressFromString:self.friendsLocationAddressString];
        
        
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    
}

#pragma mark Loading Indicator
-(void)initLoaderIndicator{
    indicator = [[RSLoadingIndicator alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    indicator.delegate = self;
    [self.view addSubview:indicator];
    
    indicator.backgroundColor = [UIColor clearColor];
    
    ticker = [NSTimer scheduledTimerWithTimeInterval:1.0f/33.0f
                                              target:self
                                            selector:@selector(tickIndicator)
                                            userInfo:nil
                                             repeats:YES];
}


#pragma mark Geocoding methods
-(void)geocodeFriendAddressFromString:(NSString *)address{

    // need to ensure friends location is proper address, or just allow error handler to transition back to view

    [_geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error){
            NSLog(@"Error geocoding string %@", error.description);
            
            // ########################################
            if(![self.presentedViewController isBeingDismissed] && ![self.presentedViewController isBeingPresented]){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                    
                    
                    // shold dismiss view controller and display error
                    id<UIViewControllerTransitioningDelegate> transDelegate = [RBSTransitioningDelegate new];
                    //self.transitioningDelegate = transDelegate;
                    [self dismissViewControllerAnimated:YES completion:nil];
               
                }];
            }
            
        }else{
            
            NSString *postParams = [NSString
                                    stringWithFormat:@"&message[application_name]=%@&message[level]=%@&message[long_message]=%@&message[short_message]=%@", @"INBTWN-050", @"1", address, @"Method: geocodeAddressString"];
         //   [self log:postParams];
            
            
            CLPlacemark *friendGeocodedAddress = [placemarks lastObject];
                        NSString *latitude = [NSString stringWithFormat:@"%f", friendGeocodedAddress.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", friendGeocodedAddress.location.coordinate.longitude];
            
            self.friendLocation.latitude = [latitude copy];
            self.friendLocation.longitude = [longitude copy];
            
            RBSLocation *userLoc = [[RBSLocation alloc] init];
            userLoc.latitude = @"42.908185";
            userLoc.longitude = @"-78.735426";
            
            self.userLocation = userLoc;
            // comment out while on simulator
            if(self.willUseUserCoordinates){
                userLoc.latitude = [[User getUser] getUserLatitude];
                userLoc.longitude = [[User getUser] getUserLongitude];
            }
            
            RBSLocation *midpoint = [GeocodeHelper getLocationBetween:userLoc and:self.friendLocation];
            
            NSLog(@"Geocoded friends address %@ %@", self.friendLocation.latitude,
                  self.friendLocation.longitude);
            
            NSLog(@"Midpoint calculation: %@,%@", midpoint.latitude, midpoint.longitude);
            
            // notify notifaction center of thread completion
            [[NSNotificationCenter defaultCenter] postNotificationName:kGeoCodingCompletionNotification
                                                                object:midpoint];

            
        }
    }];

    
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

#pragma mark Yelp API Methods
-(void)getYelpEstablishments:(NSNotification *)notif{
    RBSLocation *midpoint = [notif object];
    self.midpoint = midpoint;
    
    // TODO: Create transfer object class for location, and parameters
    NSLog(@"SearchPlacesViewController: getYelpEstablishments");
    
    
    
    
    NSString *parameters = [NSString
                            stringWithFormat:@"ll=%@,%@&category_filter=%@",
                            midpoint.latitude, midpoint.longitude, self.categoryCode];
    
    
    
    
    
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        YelpAPIManager *yelpManager = [[YelpAPIManager alloc]init];
//        [yelpManager getYelpResponseData:nil withParameters:parameters];
//    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        YelpAPIManager *yelpManager = [[YelpAPIManager alloc]init];
        [yelpManager getYelpResponseData:nil withParameters:parameters];

    });

}

-(void)didReceiveApiResponseObjects:(NSNotification *)notif{
    NSLog(@"SearchPlacesViewController: didReceiveApiResponseObjects");
    NSArray *places = [notif object];
    NSLog(@"SearchPlacesViewController: Places Count: %lu", (unsigned long)[places count]);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        PlacesMapViewController *placesTableView = [PlacesMapViewController new];
      //  id<UIViewControllerTransitioningDelegate> transDelegate = [RBSTransitioningDelegate new];
        
        // establish view parameters and properties
        //placesTableView.transitioningDelegate = transDelegate;
        if(!self.navigationController.presentingViewController.isBeingPresented){
            placesTableView.places = places;
            placesTableView.userLocation = self.userLocation;
            placesTableView.friendLocation = self.friendLocation;
            placesTableView.midpointLocation = self.midpoint;
            placesTableView.selectedKeyword = self.keyword;
            [self.navigationController pushViewController:placesTableView animated:NO];
        }
     
   }];
    
    
    
 
    
}

-(void)didErrorOnYelpData:(NSNotification *)notif{
    
    NSLog(@"didErrorOnYelpDara");
    
   // if(![self.presentedViewController isBeingDismissed] && ![self.presentedViewController isBeingPresented]){

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // shold dismiss view controller and display error
           // id<UIViewControllerTransitioningDelegate> transDelegate = [RBSTransitioningDelegate new];
           // self.transitioningDelegate = transDelegate;
          //  [self dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
            //send error to parent controller
        
        
        }];
        
    //}
}

@end














