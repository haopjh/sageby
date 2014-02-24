//
//  MapViewController.m
//  Sageby
//
//  Created by Jun Hao Peh on 26/10/12.
//
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "VendorAnnotation.h"
#import "BlockView.h"
#import "RewardChannel.h"
#import "SageByAPIStore.h"
#import "VoucherDetailsViewController.h"
#import "VoucherChannel.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView,mapAnnotations, delegate, activityLoad, blockView, errorImgView;

#pragma mark -

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}
+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

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
	// Do any additional setup after loading the view.
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    mapView.delegate = self;
    
    self.errorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -80, 320, 568)];
    
    //Create Annotation for SIS
//    VendorAnnotation* vAnnot = [[VendorAnnotation alloc]init];
//    vAnnot.latitude = (NSNumber *) @"1.307601";
//    vAnnot.longitude = (NSNumber *) @"103.849597";
//    vAnnot.title = @"SMU SIS";
//    vAnnot.subtitle = @"Home of Sageby Surveys";
//    [self.mapAnnotations insertObject:vAnnot atIndex:0];
    
//    //Create Annotation for Junhao's house
//    VendorAnnotation* vAnnot2 = [[VendorAnnotation alloc]init];
//    vAnnot2.latitude = (NSNumber *) @"1.346138";
//    vAnnot2.longitude = (NSNumber *) @"103.773263";
//    vAnnot2.title = @"Junhao";
//    vAnnot2.subtitle = @"Home of Project Manager";
//    [self.mapAnnotations insertObject:vAnnot2 atIndex:1];
//    
//    //Create Annotation for Make Shake
//    VendorAnnotation* vAnnot3 = [[VendorAnnotation alloc]init];
//    vAnnot3.latitude = (NSNumber *) @"1.311663";
//    vAnnot3.longitude = (NSNumber *) @"103.855632";
//    vAnnot3.title = @"MakeShake";
//    vAnnot3.subtitle = @"Make Shake";
//    [self.mapAnnotations insertObject:vAnnot3 atIndex:2];
//    //Create Annotation for Make Shake
//    VendorAnnotation* vAnnot4 = [[VendorAnnotation alloc]init];
//    vAnnot4.latitude = (NSNumber *) @"1.310663";
//    vAnnot4.longitude = (NSNumber *) @"103.845632";
//    vAnnot4.title = @"Test";
//    vAnnot4.subtitle = @"Test Location";
//    [self.mapAnnotations insertObject:vAnnot4 atIndex:3];
//    //Create Annotation for Make Shake
//    VendorAnnotation* vAnnot5 = [[VendorAnnotation alloc]init];
//    vAnnot5.latitude = (NSNumber *) @"1.312663";
//    vAnnot5.longitude = (NSNumber *) @"103.865632";
//    vAnnot5.title = @"Test";
//    vAnnot5.subtitle = @"Test Location";
//    [self.mapAnnotations insertObject:vAnnot5 atIndex:4];

    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    //Set Location
    CLLocation* location = locationManager.location;
    NSLog(@"Location is: %@",location);
    if(location)
    {
        NSLog(@"Location is %@",[location description]);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000);
        [mapView setRegion:region animated:NO];
        NSLog(@"location manager started updating location");
        
        [self.mapView setShowsUserLocation:YES];
    }
    else
    {
        location = [[CLLocation alloc]initWithLatitude:[@"1.297614" doubleValue] longitude:[@"103.849597" doubleValue]];
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000);
        [mapView setRegion:region animated:NO];
        NSLog(@"location manager started updating location");
    }
    
    [self fetchEntries];
    
//    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
//    
//    [self.mapView addAnnotations:self.mapAnnotations];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Setting fetch Entries here will generate a random tag id assigned to a vendor annotation
    //when map->voucherdeatils->back->assigning of tags run again but its scrambled this time round.
    //[self fetchEntries];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    NSLog(@"the pic dropped");
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // handle vendor annotations
    //
    if ([annotation isKindOfClass:[VendorAnnotation class]]) // for Vendors
    {
        // try to dequeue an existing pin view first
        MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"vendorAnnotationIdentifier"];
        if (!pinView)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"vendorAnnotationIdentifier"];
            
            //Resize the image
            UIImage *teardrop = [UIImage imageNamed:@"sagebymapmarkerbig.png"];
            //UIImage *teardrop = [UIImage imageNamed:@"sagebypinbig.png"];
            
            CGRect resizeRect;
            
            resizeRect.size = teardrop.size;
            CGSize maxSize = CGRectInset(self.view.bounds,
                                         [MapViewController annotationPadding],
                                         [MapViewController annotationPadding]).size;
            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [MapViewController calloutHeight];
            if (resizeRect.size.width > maxSize.width)
                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
            if (resizeRect.size.height > maxSize.height)
                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
            
            resizeRect.origin = (CGPoint){-3.5f, 0.0f};
            UIGraphicsBeginImageContext(resizeRect.size);
            [teardrop drawInRect:resizeRect];
            UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            customPinView.image = resizedImage;
            
            //customPinView.image = [UIImage imageNamed:@"SageAppIcon.png"];
            customPinView.canShowCallout = YES;
        
            //UI for button for annotation
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            //[rightButton showsTouchWhenHighlighted];
            [rightButton addTarget:self
                            action:@selector(showDetails:)
                  forControlEvents:UIControlEventTouchUpInside];
            [rightButton setTag:[[(VendorAnnotation *)annotation voucherChannel] voucherID]];
            customPinView.rightCalloutAccessoryView = rightButton;
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }

    return nil;
    
}

- (void)showDetails:(id)sender
{
    // the detail view does not want a toolbar so hide it
//    [self.navigationController setToolbarHidden:YES animated:NO];
    
    UIButton *selectTagBtn = (UIButton *)sender;
    int tag = [selectTagBtn tag];
    VoucherChannel *voucher;
    for (int i=0; i<[self.rewardChannel.voucherList count]; i++) {
        voucher = [self.rewardChannel.voucherList objectAtIndex:i];
        //NSLog(@"Tag id is %d",[voucher voucherID]);
        if (tag == [voucher voucherID]) {
            NSLog(@"Tag id chosen is %d",tag);
            break;
        }
    }
    
    if (voucher) {
        [self performSegueWithIdentifier:@"VoucherDetailsMap" sender:voucher];
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.mapAnnotations = nil;
    [self setMapView:nil];
    [self setBlockView:nil];
    [self setActivityLoad:nil];
    [super viewDidUnload];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    //NSLog(@"location is updated! iOS6");
    
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"User's location is updated on Map iOS5");
}

- (IBAction)getUserLocation:(id)sender {
    [locationManager startUpdatingLocation];
    CLLocation* location = locationManager.location;
    if(location){
        NSLog(@"Location is %@",[location description]);
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 4000, 4000);
        [mapView setRegion:region animated:NO];
        NSLog(@"This arrow btn works! wht about the location manager: %@",locationManager);
    }
    else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"You have to allow Sageby Surveys to access Your Location. Head over to Settings -> Privacy -> Location Services and swipe 'yes' for Sageby Surveys!(:" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];

    }
    
}

- (void)fetchEntries
{
    [self.errorImgView removeFromSuperview];
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.blockView dimBlockView];
    [activityLoad startAnimating];
    void (^completionBlock)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    [self setRewardChannel:obj];
                    [self setVendorAnnotationWithRewardChannel];
                    [self.blockView clearBlockView];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            } else {
                UIImage *img = [UIImage imageNamed:@"empty.jpg"];
                self.errorImgView.image = img;
                [self.view addSubview:self.errorImgView];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        } else if ([err code] == -1009) {
            UIImage *img = [UIImage imageNamed:@"noconnection.jpg"];
            self.errorImgView.image = img;
            [self.view addSubview:self.errorImgView];
        } else {
            UIImage *img = [UIImage imageNamed:@"generalerror.jpg"];
            self.errorImgView.image = img;
            [self.view addSubview:self.errorImgView];
        }
        [activityLoad stopAnimating];
    };
    
    [[SageByAPIStore sharedStore] fetchAvailableVouchersWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
}

- (void)setVendorAnnotationWithRewardChannel
{
    self.mapAnnotations = [[NSMutableArray alloc] init];
    int count = 0;
    if ([self rewardChannel]) {
        for (int i=0; i<[self.rewardChannel.voucherList count]; i++) {
            VoucherChannel *voucher = [self.rewardChannel.voucherList objectAtIndex:i];
            if ([voucher vendorAnnotationList]) {
                for (int k=0; k<[[voucher vendorAnnotationList] count]; k++) {
                    VendorAnnotation *vendorAnnotation = [[voucher vendorAnnotationList] objectAtIndex:k];
                    [vendorAnnotation setVoucherChannel:voucher];
                    [self.mapAnnotations insertObject:vendorAnnotation atIndex:count];
                    
                    NSLog(@"Tag id is %d",[voucher voucherID]);
                    count ++;
                }
            }
        }
    }
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    
    [self.mapView addAnnotations:self.mapAnnotations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"VoucherDetailsMap"])
    {
        // Get reference to the destination view controller
        VoucherDetailsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setVoucherChannel:sender];
    }
}

@end
