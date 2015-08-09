//
//  PlacesMapViewController.m
//  Inbtwn
//
//  Created by Corey Schaf on 4/23/14.
//  Copyright (c) 2014 Rogue Bit Studios. All rights reserved.
//

#import "PlacesMapViewController.h"
#import "RBSLocation.h"
#import "InbtwnPlaceTableViewCell.h"
#import "Establishment.h"
#import "UIImageResizing.h"
#import "EstablishmentAnnotation.h"
#import "InbtwnAnnotation.h"
#import "Keyword.h"

#import <MapKit/MapKit.h>

#define kDismissStackedViewControllers @"com.roguebit.inbtwn.dismissstackedcontrollers"

#define kMetersPerMile 1609.344

#define UIColorFromRGB(rgbValue) [UIColor \
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
    blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface PlacesMapViewController (){
    CLLocationCoordinate2D midpointCoord;
}

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;


@end

@implementation PlacesMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // map view
    [self initMap];
    [self resizeMap];

    // table view
    self.tableView.dataSource = self;
    [self.tableView registerClass:[InbtwnPlaceTableViewCell class] forCellReuseIdentifier:@"cell"];
    UINib *cellNib = [UINib nibWithNibName:@"InbtwnPlaceTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self initLabel];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.userLocation = nil;
    self.friendLocation = nil;
    self.midpointLocation = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView beginUpdates];
    [self.tableView reloadData];
    [self.tableView endUpdates];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initLabel{
    if(self.selectedKeyword != nil){
        
        if(self.places.count > 1){
            NSString *k = self.selectedKeyword.multipleResultHeader;
            self.resultsLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)self.places.count, k];
        }else{
            NSString *k = self.selectedKeyword.singleResultHeader;
            self.resultsLabel.text = [NSString stringWithFormat:@"%lu %@", (unsigned long)self.places.count, k];
        }
        
    }else{
        self.resultsLabel.text = [NSString stringWithFormat:@"%lu Results", (unsigned long)[self.places count] ];
    }
}

#pragma mark MKMap Methods

-(void)initMap{

    _map.delegate = self;
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [self.midpointLocation.latitude doubleValue];
    zoomLocation.longitude = [self.midpointLocation.longitude doubleValue];

    MKCoordinateRegion viewRegion;// = MKCoordinateRegionMakeWithDistance(zoomLocation,
                                    //                                   0.5 * kMetersPerMile, 0.5 * kMetersPerMile);
   // [self.map setRegion:viewRegion animated:YES];
    
    
    CLLocationCoordinate2D userPoint = CLLocationCoordinate2DMake([self.userLocation.latitude doubleValue],
                                                               [self.userLocation.longitude doubleValue]);
    CLLocationCoordinate2D friendPoint = CLLocationCoordinate2DMake([self.friendLocation.latitude doubleValue],
                                                                   [self.friendLocation.longitude doubleValue]);
    CLLocationCoordinate2D midpoint = CLLocationCoordinate2DMake([self.midpointLocation.latitude doubleValue],
                                                                 [self.midpointLocation.longitude doubleValue]);
    midpointCoord = midpoint;
    
    // display on map
    for(id<MKAnnotation> annotation in self.map.annotations){
        [_map removeAnnotation:annotation];
    }
    
//    KMapRect zoomRect = MKMapRectNull;
//    for (id <MKAnnotation> annotation in mapView.annotations)
//    {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//        zoomRect = MKMapRectUnion(zoomRect, pointRect);
//    }
//    [mapView setVisibleMapRect:zoomRect animated:YES];
    
    // user
    EstablishmentAnnotation *userAnnotation = [[EstablishmentAnnotation alloc]
                                               initWithName:@"You" address:nil coordinate:userPoint];

    [_map addAnnotation:userAnnotation];
    
    EstablishmentAnnotation *friendAnnotation = [[EstablishmentAnnotation alloc]
                                                 initWithName:@"Friend" address:nil coordinate:friendPoint];
    [_map addAnnotation:friendAnnotation];
    
    InbtwnAnnotation *midpointAnnotation = [[InbtwnAnnotation alloc]
                                                   initWithName:@"Inbtwn" address:nil coordinate:midpoint];
    [_map addAnnotation:midpointAnnotation];
    
    
    viewRegion.center = midpoint;
    //viewRegion.center.latitude -= self.map.region.span.latitudeDelta * 0.40;
    // [self.map setCenterCoordinate:viewRegion animated:YES];
   // [self.map setRegion:viewRegion animated:YES];

    [_map showAnnotations:_map.annotations animated:YES];
    
}

-(void)resizeMap{
    
    [UIView animateWithDuration:1 animations:^{
        
        self.map.frame = self.view.bounds;
        self.map.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
       // [self.map layoutIfNeeded];
        
        CLLocationCoordinate2D center = midpointCoord;
        center.latitude -= self.map.region.span.latitudeDelta * 0.25;
        [self.map setCenterCoordinate:center animated:NO];
        
    }];
    
}

#pragma mark UITableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger numberOfRowsInAll = 0;
    
    if(self.places.count > 0){
        NSInteger seperatorsCount = self.places.count -1;
        numberOfRowsInAll = self.places.count + seperatorsCount;
    }
    
    return numberOfRowsInAll;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *mainCellIdentifier = @"cell";
    static NSString *seperatorCellIdentifier = @"seperator";
    
    InbtwnPlaceTableViewCell *cell = nil;
    
    if(indexPath.row % 2 == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:mainCellIdentifier];
        
        
        if(cell == nil){
            // NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"InbtwnPlaceTableViewCell" owner:self options:nil];
            cell = [[InbtwnPlaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainCellIdentifier];
          
        }
        
        NSInteger indexRow = indexPath.row / 2;
        Establishment *place = self.places[indexRow];
        
        cell.establishment = place;
        cell.placeName.text = place.name;
        cell.addressOne.text = place.addressOne;
        cell.addressTwo.text = place.addressTwo;
        
        cell.category.text = @"";
        if(place.categories.count > 0){
            cell.category.text = [place.categories objectAtIndex:0];
        }
        cell.imageView.image = place.thumbnail;
        cell.imageView.frame = CGRectMake(0, 0, 60, 60);
        cell.ratingImage.image = place.ratingImage;
        
        cell.rightUtilityButtons = [self rightButtons];
        cell.delegate = self;

    }else{
  
        cell = [tableView dequeueReusableCellWithIdentifier:seperatorCellIdentifier];
        
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"InbtwnSeperatorTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // even, this determines our "clear" spacing, as table view does not contain this natively
    if(indexPath.row % 2 == 0){
        return 76.0f;
    }
    
    return 10.0f;
}

#pragma mark Interface Actions
-(IBAction)backBtnSelected:(id)sender{
    NSLog(@"PlacesMapViewController: backBtnSelected");
    //[[NSNotificationCenter defaultCenter] postNotificationName:kDismissStackedViewControllers object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(IBAction)settingsBtnSelected:(id)sender{
    NSLog(@"settingsSelected");
    [self resizeMap];
}

#pragma mark MKMapviewDelegates
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    static NSString *identifier = @"Location";
    static NSString *inbtwnIdentifier = @"Inbtwn";
    
    if([annotation isKindOfClass:[EstablishmentAnnotation class]]){
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if(annotationView == nil){
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"map-icon-half.png"];
            
            
        }else{
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }else if([annotation isKindOfClass:[InbtwnAnnotation class]]){
        MKAnnotationView *annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:inbtwnIdentifier];
       
        if(annotationView == nil){
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:inbtwnIdentifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"results-bracket-half.png"];
            
            
        }else{
            annotationView.annotation = annotation;
        }

        return annotationView;
    }
    
    return nil;
}

#pragma mark SWTableView Delegate
-(NSArray *)rightButtons{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    UIColor *bg = UIColorFromRGB(0x009dcb);
    
   // [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor orangeColor] title:@"Txt"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:bg icon:[UIImage imageNamed:@"icon_text.png"]];
   // [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor greenColor] title:@"Mail"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:bg icon:[UIImage imageNamed:@"icon_email.png"]];
   // [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor blueColor] title:@"Fb"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:bg icon:[UIImage imageNamed:@"icon_facebook.png"]];
    
   // [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"Map"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:bg icon:[UIImage imageNamed:@"icon_map.png"]];
    
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell scrollingToState:(SWCellState)state
{
    switch (state) {
        case 0:
            NSLog(@"utility buttons closed");
            break;
        case 1:
            NSLog(@"left utility buttons open");
            break;
        case 2:
            NSLog(@"right utility buttons open");
            break;
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            NSLog(@"left button 0 was pressed");
            break;
        case 1:
            NSLog(@"left button 1 was pressed");
            break;
        case 2:
            NSLog(@"left button 2 was pressed");
            break;
        case 3:
            NSLog(@"left btton 3 was pressed");
        default:
            break;
    }
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
            // Text Message
        case 0:
        {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Establishment *establishment = [self.places objectAtIndex:indexPath.row/2];
            
            if(![MFMessageComposeViewController canSendText]){
                UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [warningAlert show];
                return;
            }
            
            NSString *message = [NSString stringWithFormat:@"Meet me INBTWN at %@, %@, %@", establishment.name,
                                 establishment.addressOne, establishment.addressTwo];
            
            MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
            messageController.messageComposeDelegate = self;
           // [messageController setRecipients:recipents];
            [messageController setBody:message];
            
            // Present message view controller on screen
            [self presentViewController:messageController animated:YES completion:nil];
            
//            
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
            // Mail Message
        case 1:
        {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            Establishment *establishment = [self.places objectAtIndex:indexPath.row/2];
            
  
            
            break;
        }
            // Facebook
        case 2:{
            
        }
            //map
        case 3:{
            
        }
            
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}

- (BOOL)swipeableTableViewCell:(SWTableViewCell *)cell canSwipeToState:(SWCellState)state
{
    switch (state) {
        case 1:
            // set to NO to disable all left utility buttons appearing
            return NO;
            break;
        case 2:
            // set to NO to disable all right utility buttons appearing
            return YES;
            break;
        default:
            break;
    }
    
    return YES;
}

#pragma mark MFMessageComposeViewControllerDelegate
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch(result){
        case MessageComposeResultCancelled:{
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
            
        case MessageComposeResultFailed:{
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
        case MessageComposeResultSent:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
            
        default:
            break;
    }
}

@end













