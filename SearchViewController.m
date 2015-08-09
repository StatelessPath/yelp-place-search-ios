//
//  SearchViewController.m
//  Inbtwn
//
//  Created by Corey Schaf on 4/7/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "SearchViewController.h"
#import "StyleManager.h"
#import "User.h"
#import "YelpAPIManager.h"
#import "SearchPlacesViewController.h"
#import "RBSTransitioningDelegate.h"
#import "KeywordManager.h"
#import "Keyword.h"


#define kDismissStackedViewControllers @"com.roguebit.inbtwn.dismissstackedcontrollers"

@interface SearchViewController (){
    NSMutableData *_responseData;
    
    NSArray *searchTerms;
    
    NSString *selectedCategoryCode;
    
    BOOL userIsUsingGeoLocation;
    
}

@property (weak, nonatomic) IBOutlet UILabel *inLabel;
@property (weak, nonatomic) IBOutlet UILabel *btwnLabel;
@property (weak, nonatomic) IBOutlet UIImage *dividerImage;
@property (weak, nonatomic) IBOutlet UITextField *userLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *friendLocationTextField;
@property (weak, nonatomic) IBOutlet UILabel *questionPromptLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (nonatomic, assign) id currentResponder;


@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.inLabel.textColor = [StyleManager getManager].secondary;
        self.btwnLabel.textColor = [StyleManager getManager].secondary;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userIsUsingGeoLocation = NO;
   
    // touch to remove keyboard
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTouch:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    self.userLocationTextField.delegate = self;
    self.friendLocationTextField.delegate = self;
    
    YelpAPIManager *mng = [[YelpAPIManager alloc] init];
    KeywordManager *keywordMng = [KeywordManager getManager];
    
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.type = iCarouselTypeLinear;
    
    // listen for our places view controller to send dismiss message
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissStackedControllers:) name:kDismissStackedViewControllers object:nil];

}

-(void)viewDidAppear:(BOOL)animated{
    
    //self.navigationController.
    
    NSLog(@"SearchViewController - viewDidAppear");
    self.friendLocationTextField.text = @"";
    self.userLocationTextField.text = @"";
    self.userLocationTextField.placeholder = @"Where are you now?";
    userIsUsingGeoLocation = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getUserLocation:(id)sender{
    
    if(!userIsUsingGeoLocation){
        userIsUsingGeoLocation = YES;
        User *user = [User getUser];
        //self.userLocationTextField.text = [NSString stringWithFormat:@"%@ , %@", user.getUserLatitude, user.getUserLongitude];
        self.userLocationTextField.placeholder = @"Using Your Location";
    }else{
        userIsUsingGeoLocation = NO;
        self.userLocationTextField.placeholder = @"Where are you now?";
    }
    
    
}

-(IBAction)searchForPlaces:(id)sender{

    if(self.userLocationTextField.text.length > 0 || userIsUsingGeoLocation == YES){
        if(self.friendLocationTextField.text.length > 0){
            
            // get the selected category form the carousel
            Keyword *keyword = [self getSelectedCategory];
         
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                SearchPlacesViewController *loadingView = [SearchPlacesViewController new];
                
                
               // id<UIViewControllerTransitioningDelegate> transDelegate = [RBSTransitioningDelegate new];
                //loadingView.transitioningDelegate = transDelegate;
                
                loadingView.friendsLocationAddressString = self.friendLocationTextField.text;
                loadingView.categoryCode = keyword.code;
                loadingView.keyword = keyword;
               
                loadingView.willUseUserCoordinates = YES;
               // [self presentViewController:loadingView animated:YES completion:nil];
                [self.navigationController pushViewController:loadingView animated:NO];
            }];
            
         
            
        }
    }

}

-(Keyword *)getSelectedCategory{
    
    NSInteger selectedIndex = _carousel.currentItemIndex;
    
    KeywordManager *mngr = [KeywordManager getManager];
    Keyword *keyword = [[mngr keywords] objectAtIndex:selectedIndex];
    
   // NSString *code = keyword.code;
    
    // TODO: Check nulls or empty, default to something
    
    return keyword;
    
}


#pragma mark UITextField Delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.currentResponder = nil;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.currentResponder = textField;
}

-(void)resignOnTouch:(id)sender{
    [self.currentResponder resignFirstResponder];
}

#pragma mark NSNotification Listener Methods
-(void)dismissStackedControllers:(NSNotification *)notif{
    NSLog(@"SearchViewController: dismissStackedControllers");
    
}

#pragma mark iCarousel Protocol

-(NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    
    return [[[KeywordManager getManager] keywords] count];
}

-(UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view{
    
    UILabel *label = nil;
    
    if(view == nil){
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150.0f, 50.0f)];
        
        view.contentMode = UIViewContentModeCenter;
        
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.tag = 1;
        
       // label.font = [UIFont fontWithName:@"BrandonGrotesque-Light" size:19.0f];
        [view addSubview:label];
    }else{
        label = (UILabel *)[view viewWithTag:1];
    }
    
    Keyword *keyword = [[[KeywordManager getManager] keywords] objectAtIndex:index];
    label.text = [NSString stringWithFormat:@" %@ ", keyword.name];
    label.font = [label.font fontWithSize:21];
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    
    switch (option) {
        case iCarouselOptionSpacing:
            return value / 1.2f;
            
        case iCarouselOptionFadeMin:
            return -0.4;
            
        case iCarouselOptionFadeMax:
            return 0.2;
            
        case iCarouselOptionFadeRange:
            return 2.0;
            
          
        default:
            return value;
    }

}




@end












