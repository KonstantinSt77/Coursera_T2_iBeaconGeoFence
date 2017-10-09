//
//  ViewController.m
//  GeofenceAppByKS
//
//  Created by Kostya on 06.10.2017.
//  Copyright © 2017 SKS. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL mapIsMoving;
@property (strong, nonatomic) MKPointAnnotation* currentAnnotation;
@property (strong, nonatomic) CLRegion* geoRegion;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    self.mapIsMoving = NO;
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 3; //meters
    
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self addCurrentAnnotation];
    
  //  [self setUpGeoRegion];
    
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]] == YES)
    {
        [self setUpGeoRegion];
        
        CLAuthorizationStatus currentstatus = [CLLocationManager authorizationStatus];
        if((currentstatus == kCLAuthorizationStatusAuthorizedWhenInUse)||
           (currentstatus == kCLAuthorizationStatusAuthorizedAlways))
        {
            
        }
        else
        {
            [self.locationManager requestAlwaysAuthorization];
        }
        
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    else
    {
    }
        self.mapView.showsUserLocation = YES;
        [self.locationManager startMonitoringForRegion:self.geoRegion];
        [self.locationManager startUpdatingLocation];
}

-(void)addCurrentAnnotation
{
    self.currentAnnotation = [[MKPointAnnotation alloc] init];
    self.currentAnnotation.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnnotation.title = @"My Location";
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
    if((currentStatus == kCLAuthorizationStatusAuthorizedWhenInUse)||
       (currentStatus == kCLAuthorizationStatusAuthorizedAlways))
    {
        
    }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.mapIsMoving = YES;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.mapIsMoving = NO;
}

-(void)setUpGeoRegion
{
    self.geoRegion= [[CLRegion alloc]initCircularRegionWithCenter:CLLocationCoordinate2DMake(50.023375,36.216452)
                                                           radius:10
                                                       identifier:@"MyRegionIdentifier"];
 
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake(50.023375,36.216452);
    point.title = @"Misto Shop";
    [self.mapView addAnnotation:point];
}



- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    self.currentAnnotation.coordinate = locations.lastObject.coordinate;
    if(self.mapIsMoving == NO)
    {
        [self centerMap:self.currentAnnotation];
    }
}

-(void)centerMap:(MKPointAnnotation *)centrePoint
{
    [self.mapView setCenterCoordinate:centrePoint.coordinate animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
//    UILocalNotification *note = [[UILocalNotification alloc]init];
//    note.fireDate = nil;
//    note.repeatInterval = NO;
//    note.alertTitle = @"Exit";
//    note.alertBody = @"Exit";
//    [[UIApplication sharedApplication]scheduleLocalNotification:note];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(nonnull CLRegion *)region
{
    UILocalNotification *note = [[UILocalNotification alloc]init];
    note.fireDate = nil;
    note.repeatInterval = NO;
    note.alertTitle = @"Hello! Welcome to K.S Shop!";
    note.alertBody = @"Coupon code worth 10% off a purchase in the next 30 minutes. Coupon = <KSWORK18>";
    [[UIApplication sharedApplication]scheduleLocalNotification:note];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hello! Welcome to our Shop!"
                                                    message:@"Coupon code worth 10% off a purchase in the next 30 minutes. Coupon = <KSWORK18>"
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
