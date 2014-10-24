//
//  PrepareViewController.m
//  MailCat
//
//  Created by Lanston Peng on 10/23/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

#import "PrepareViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MailCatUtil.h"
#import "LetterModel.h"
#import <AVOSCloud/AVOSCloud.h>
#import "WritingViewController.h"


#define friendImageName @"testQQ"
#define yourImageName   @"anotherTestQQ"

@interface PrepareViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yourImageView;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UIButton *beginWriteButton;

@property (strong,nonatomic)LetterModel* letterModel;

@end

@implementation PrepareViewController
{
    BOOL canStartPan;
    CGPoint initPoint;
    CGRect friImageViewOriginalFrame;
    CGRect yourImageViewOriginalFrame;
    MKPolyline *routeLine;
    UIImageView* currentImageView;
    NSString* currentImageName;
}

- (IBAction)clickBeginWriteButton:(UIButton *)sender {
    
}

- (void)hanelPanWithImageView:(UIImageView*)imgView withRecognizer:(UIPanGestureRecognizer*)recognizer
{
    currentImageView = imgView;
    
    if (canStartPan) {
        CGPoint changedPoint;
        switch (recognizer.state) {
            case UIGestureRecognizerStateBegan:
                initPoint = [recognizer locationInView:currentImageView];
                break;
            case UIGestureRecognizerStateChanged:
                changedPoint = [recognizer locationInView:currentImageView];
                self.friendImageView.frame = CGRectOffset(currentImageView.frame,changedPoint.x - initPoint.x ,changedPoint.y - initPoint.y );
                break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            {
                CGPoint touchPoint = [recognizer locationInView:self.mapView];
                if ( CGRectContainsPoint(self.mapView.frame, touchPoint) ) {
                    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
                    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
                    [self dropAnnotation:location];
                    currentImageView.alpha = 0.3;
                    currentImageView.userInteractionEnabled = NO;
                    
                    NSLog(@"%f",self.friendImageView.alpha + self.yourImageView.alpha);
                    if(self.friendImageView.alpha + self.yourImageView.alpha < 0.7)
                    {
                        [self getRouteLayer:currentLocation toLocation:location];
                    }
                    
                    if (currentImageView.tag == 100) {
                        self.letterModel.senderCity = [NSString stringWithFormat:@"%f,%f",location.longitude,location.latitude];
                    }
                    else
                    {
                        self.letterModel.receiverCity = [NSString stringWithFormat:@"%f,%f",location.longitude,location.latitude];
                    }
                }
                else
                {
                    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:4 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        if (currentImageView.tag == 100) {
                            currentImageView.frame = yourImageViewOriginalFrame;
                        }
                        else
                        {
                            currentImageView.frame = friImageViewOriginalFrame;
                        }
                    } completion:^(BOOL finished) {
                    }];
                }
            }
            default:
                break;
        }
    }

}
- (IBAction)handelPan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.view.tag == 100) {
        currentImageName = yourImageName;
        [self hanelPanWithImageView:self.yourImageView withRecognizer:recognizer];
    }
    else
    {
        currentImageName = friendImageName;
        [self hanelPanWithImageView:self.friendImageView withRecognizer:recognizer];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    friImageViewOriginalFrame = self.friendImageView.frame;
    yourImageViewOriginalFrame = self.yourImageView.frame;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    canStartPan = YES;
    self.beginWriteButton.layer.cornerRadius = 3;
    
//    CALayer* deliveryLabelBackgroundLayer = [CALayer layer];
//    deliveryLabelBackgroundLayer.bounds = self.deliveryLabel.bounds;
//    deliveryLabelBackgroundLayer.backgroundColor = [UIColor blackColor].CGColor;
//    [self.deliveryLabel.layer insertSublayer:deliveryLabelBackgroundLayer atIndex:0];
    self.deliveryLabel.layer.cornerRadius = 3;
    
    [locationManager requestAlwaysAuthorization];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self showUserLocation];
    self.friendImageView.userInteractionEnabled = YES;
    self.yourImageView.userInteractionEnabled = YES;
    currentImageName = yourImageName;
    
    self.letterModel = [LetterModel new];
    if ([AVUser currentUser]) {
        self.letterModel.senderEmail = [AVUser currentUser].email;
    }
    else
    {
        NSString* randomEmail = [NSString stringWithFormat:@"cat_%ld@mailcat.com",arc4random()% 10000000000];
        self.letterModel.senderEmail = randomEmail;
        [[NSUserDefaults standardUserDefaults]setObject:randomEmail forKey:@"randomEmail"];
    }
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showUserLocation{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [locationManager requestWhenInUseAuthorization];
    } else {
        [locationManager startUpdatingLocation];
        [[MailCatUtil singleton]showLoadingView:self.view];
    }
}

- (void)updateMapView
{
    MKUserLocation *userLocation = self.mapView.userLocation;
    MKCoordinateSpan span =  MKCoordinateSpanMake(0, 360/pow(2, 6) * self.mapView.frame.size.width/256);
    MKCoordinateRegion zoomRegion = MKCoordinateRegionMake(userLocation.coordinate, span);
    [self.mapView setRegion:zoomRegion animated:YES];
    //[self dropAnnotation];
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //[self updateMapView];
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status != kCLAuthorizationStatusNotDetermined) {
        [locationManager startUpdatingLocation];
        self.yourImageView.alpha = 0.3;
        self.yourImageView.userInteractionEnabled = NO;
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager error %@",error);
}

- (void)dropAnnotation:(CLLocationCoordinate2D)location
{
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc]init];
    annotation.coordinate = location;
    //annotation.title = @"sucker";
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView* annotationView = [[MKAnnotationView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    annotationView.image = [UIImage imageNamed:currentImageName];
    annotationView.draggable = YES;
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newState
   fromOldState:(MKAnnotationViewDragState)oldState
{
    if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling) {
        [annotationView setDragState:MKAnnotationViewDragStateNone animated:YES];
        NSLog(@"MKAnnotation %f",((MKPointAnnotation*)annotationView.annotation).coordinate.latitude);
        [self getRouteLayer:currentLocation toLocation:((MKPointAnnotation*)annotationView.annotation).coordinate];
    }
}

- (void)getRouteLayer:(CLLocationCoordinate2D)sourceLocation toLocation:(CLLocationCoordinate2D)toLocation
{
    if (routeLine) {
        [self.mapView removeOverlay:routeLine];
    }
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:sourceLocation addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:toLocation addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAny];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        int dayNeeded;
        if (error) {
            dayNeeded = arc4random() % 3;
        }
        else
        {
            __block double totalTime = 0;
            NSArray *arrRoutes = [response routes];
            [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                
                MKRoute *rout = obj;
                totalTime += rout.expectedTravelTime;
                
                routeLine = [rout polyline];
                [self.mapView addOverlay:routeLine];
            }];
            //NSLog(@"expectedTime:%f",totalTime / 86400);
            //NSLog(@"expectedTime:%f",totalTime / 43200);
            dayNeeded = (int)ceil(totalTime / 43200);
        }
        self.deliveryLabel.text = [NSString stringWithFormat:@"信件大概 %d天后 送达",dayNeeded];
        self.deliveryLabel.hidden = NO;
        self.letterModel.receiveDate = [[NSDate alloc]initWithTimeInterval:86400 * dayNeeded sinceDate:[NSDate new]];
    }];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay {
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView* aView = [[MKPolylineView alloc]initWithPolyline:(MKPolyline*)overlay] ;
        aView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        aView.lineWidth = 10;
        return aView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    currentLocation = userLocation.coordinate;
    self.letterModel.senderCity = [NSString stringWithFormat:@"%f,%f",currentLocation.longitude,currentLocation.latitude];
    [[MailCatUtil singleton]hideLodingView];
}

#pragma mark --
#pragma mark TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (![[MailCatUtil singleton] validateEmail:textField.text] ) {
        [[MailCatUtil singleton]displayToastMsg:@"请输入正确的邮件地址" inView:self.view];
        self.beginWriteButton.hidden = YES;
    }
    else
    {
        self.letterModel.sendToEmail = textField.text;
        self.beginWriteButton.hidden = NO;
    }
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    WritingViewController* writingVC = (WritingViewController*)segue.destinationViewController;
    writingVC.letterModel = self.letterModel;
}
- (IBAction)unwind:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
