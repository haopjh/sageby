//
//  MapViewController.h
//  Sageby
//
//  Created by Jun Hao Peh on 26/10/12.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@class  AppDelegate;
@class VendorAnnotation;
@class BlockView;
@class RewardChannel;

@interface MapViewController : UIViewController <CLLocationManagerDelegate,MKMapViewDelegate,MKAnnotation>
{
    CLLocationManager *locationManager;
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, retain) NSMutableArray *mapAnnotations;
@property (nonatomic, strong) RewardChannel *rewardChannel;
@property (nonatomic, strong) UIImageView *errorImgView;

@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (IBAction)getUserLocation:(id)sender;
- (void)showDetails:(id)sender;



@end
