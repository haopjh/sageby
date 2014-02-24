//
//  NavigationTopViewController.m
//  Sageby
//
//  Created by Mervyn on 23/10/12.
//
//

#import "NavigationTopViewController.h"
#import "GANTracker.h"

@interface NavigationTopViewController ()

@end

@implementation NavigationTopViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/NotificationTopViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"NotificationTopView GA");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    //[self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
