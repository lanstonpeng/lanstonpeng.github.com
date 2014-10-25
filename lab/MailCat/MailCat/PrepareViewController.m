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
#define friendImageNameShadow @"testQQ_shadow"

#define yourImageName   @"anotherTestQQ"
#define yourImageNameShadow   @"anotherTestQQ_shadow"

@interface PrepareViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentLocation;
    CLLocationCoordinate2D destinationLocation;
}
@property (weak, nonatomic) IBOutlet UITextField *emaiTextField;

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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //validate form
    if (![[MailCatUtil singleton]validateEmail: self.emaiTextField.text]) {
        [[MailCatUtil singleton]shakeView:self.emaiTextField];
        [[MailCatUtil singleton]displayToastMsg:@"请填写收信人的邮箱" inView:self.view afterDelay:1.5];
        return NO;
    }
    if (self.yourImageView.alpha > 0.5) {
        [[MailCatUtil singleton]shakeView:self.yourImageView];
        [[MailCatUtil singleton]displayToastMsg:@"请确认你的寄信位置" inView:self.view afterDelay:1.5];
        return NO;
    }
    if (self.friendImageView.alpha > 0.5) {
        [[MailCatUtil singleton]shakeView:self.friendImageView];
        [[MailCatUtil singleton]displayToastMsg:@"请确认收信人的位置" inView:self.view afterDelay:1.5];
        return NO;
    }
    return YES;
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
                if (currentImageView.tag == 1000) {
                    currentImageView.image = [UIImage imageNamed:yourImageNameShadow];
                }
                else
                {
                    currentImageView.image = [UIImage imageNamed:friendImageNameShadow];
                }
                break;
            case UIGestureRecognizerStateChanged:
                changedPoint = [recognizer locationInView:currentImageView];
                currentImageView.frame = CGRectOffset(currentImageView.frame,changedPoint.x - initPoint.x ,changedPoint.y - initPoint.y );
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
                    
                    
                    if (currentImageView.tag == 1000) {
                        self.letterModel.senderCity = [NSString stringWithFormat:@"%f,%f",location.longitude,location.latitude];
                        currentLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude);
                        currentImageName = yourImageNameShadow;
                    }
                    else
                    {
                        self.letterModel.receiverCity = [NSString stringWithFormat:@"%f,%f",location.longitude,location.latitude];
                        destinationLocation = CLLocationCoordinate2DMake(location.latitude, location.longitude);
                        currentImageName = friendImageNameShadow;
                    }
                    
                    if([self isTwoPeplePlaceInMap])
                    {
                        [self getRouteLayer:currentLocation toLocation:destinationLocation];
                    }
                }
                else
                {
                    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:4 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        if (currentImageView.tag == 1000) {
                            currentImageView.frame = yourImageViewOriginalFrame;
                            currentImageView.image = [UIImage imageNamed:yourImageName];
                        }
                        else
                        {
                            currentImageView.frame = friImageViewOriginalFrame;
                            currentImageView.image = [UIImage imageNamed:friendImageName];
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
    currentImageName = yourImageName;
    [self hanelPanWithImageView:self.yourImageView withRecognizer:recognizer];
}
- (IBAction)handlePanFriendImage:(UIPanGestureRecognizer*)recognizer {
    currentImageName = friendImageName;
    [self hanelPanWithImageView:self.friendImageView withRecognizer:recognizer];
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
    [[MailCatUtil singleton]hideLodingView];
    [[MailCatUtil singleton]displayToastMsg:@"定位失败,请手动选择你的位置" inView:self.view];
    self.yourImageView.alpha = 1;
    self.yourImageView.userInteractionEnabled = YES;
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
    if (newState == MKAnnotationViewDragStateStarting) {
        [UIView animateWithDuration:0.1 animations:^{
            [annotationView setFrame:CGRectOffset(annotationView.frame, 0, -5)];
        } completion:^(BOOL finished) {
        }];
    }
    if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateCanceling) {
        [annotationView setDragState:MKAnnotationViewDragStateNone animated:YES];
        NSLog(@"MKAnnotation %f",((MKPointAnnotation*)annotationView.annotation).coordinate.latitude);
        if ([self isTwoPeplePlaceInMap]) {
            [self getRouteLayer:currentLocation toLocation:((MKPointAnnotation*)annotationView.annotation).coordinate];
        }
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
            NSLog(@"get route error:%@",error);
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
        if (self.deliveryLabel.alpha < 0.1) {
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.deliveryLabel.alpha = 1;
            } completion:nil];
        }
        self.letterModel.receiveDate = [[NSDate alloc]initWithTimeInterval:86400 * dayNeeded sinceDate:[NSDate new]];
        self.letterModel.sendDate = [NSDate new];
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
    }
    else
    {
        self.letterModel.sendToEmail = textField.text;
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

- (BOOL)isTwoPeplePlaceInMap
{
    return self.friendImageView.alpha + self.yourImageView.alpha < 0.7;
}

@end
