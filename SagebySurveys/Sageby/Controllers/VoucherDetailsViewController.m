//
//  VoucherDetailsViewController.m
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoucherDetailsViewController.h"
#import "VoucherPurchasedViewController.h"
#import "VoucherChannel.h"
#import "VoucherPurchasedChannel.h"
#import "SageByAPIStore.h"
#import "GANTracker.h"
#import "AppDelegate.h"
#import "UserProfileChannel.h"
#import "ConfirmAddressViewController.h"
#import "ConfirmationPopupView.h"
#import "BlockView.h"
#import "ProfileView.h"
#import "AsyncImageView.h"

@interface VoucherDetailsViewController ()

@end

@implementation VoucherDetailsViewController
@synthesize voucherChannel;
@synthesize voucherTitle;
@synthesize voucherDescription;
@synthesize voucherImage;
@synthesize delegate;
@synthesize selectTagBtn;
@synthesize blockView;
@synthesize confirmationPopupView;
@synthesize profileView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Create an instance of UIView (FooView).
    self.confirmationPopupView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmationPopupView" owner:self options:nil] objectAtIndex:0];
    
    // Tell it where to go. Otherwise, it'll appear in the upper left corner.
    self.confirmationPopupView.frame = CGRectMake(20, 70, 280, 180);
    self.confirmationPopupView.blockView = self.blockView;
    [self.view addSubview:self.confirmationPopupView];
    [[self confirmationPopupView] setConfirmationType:ConfirmationPopupViewTypePurchase];
    [[self confirmationPopupView] setSourceVC:self];
    
    profileView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
    
    // Tell it where to go. Otherwise, it'll appear in the upper left corner.
    profileView.frame = CGRectMake(20, 0, 280, 180);
    self.profileView.blockView = self.blockView;
    self.profileView.sourceVC = self;
    [self.view addSubview:self.profileView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[self confirmationPopupView] setHidden:YES];
    voucherTitle.text = [voucherChannel title];
    voucherDescription.text = [voucherChannel description];
    /*
    NSData *imageData = [NSData dataWithContentsOfURL:[voucherChannel voucherImageFile]];
    if (imageData!=NULL) {
        voucherImage.image = [UIImage imageWithData:imageData];
    }
    */
    CGRect frame;
    frame.size.width=100; frame.size.height=100;
    frame.origin.x=40; frame.origin.y=20;
    AsyncImageView* asyncImage = [[AsyncImageView alloc]
                                  initWithFrame:frame];
    asyncImage.tag = 999;
    //NSURL* url = [imageDownload thumbnailURLAtIndex:indexPath.row];
    [asyncImage loadImageFromURL:[voucherChannel voucherImageFile]];
    [self.view addSubview:asyncImage];

    
    [self createRedemptionButtonArray];

    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/VoucherDetailsViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"VoucherDetailsViewController GA");

    [self.profileView setHidden:YES];
}

- (void)createRedemptionButtonArray
{
    NSMutableArray *btnArr = [[NSMutableArray alloc] init];
    NSArray *cost = [voucherChannel voucherCostList];
    float initYAxis = 200.0;
    for (int i=0; i<[cost count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(openPurchaseConfirmationPopup:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:[NSString stringWithFormat:@"SC$%@ for $%@",[cost objectAtIndex:i],[cost objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTag:i];
        [button setBackgroundImage:[UIImage imageNamed:@"ipad-button-green.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
        button.frame = CGRectMake(60.0, initYAxis, 205.0, 37.0);
        [self.view addSubview:button];
        [btnArr addObject:button];
        initYAxis += 40;
    }
    [self.view bringSubviewToFront:self.blockView];
}

- (void)didReceiveMemoryWarning
{
    [self setVoucherTitle:nil];
    [self setVoucherImage:nil];
    [self setDelegate:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (void)openPurchaseConfirmationPopup:(id)sender
{
    self.selectTagBtn = (UIButton *)sender;
    [self.confirmationPopupView setVoucherChannel:self.voucherChannel];
    [self.confirmationPopupView setSelectTagBtn:(UIButton *)sender];
    [self.confirmationPopupView showConfirmationView];
}

- (IBAction)openUserProfilePopup:(id)sender {
    [self.profileView showHideProfileView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"Purchased"]) {
        // Get reference to the destination view controller
        VoucherPurchasedViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setVoucherPurchasedChannel:sender];
        [vc setVoucherChannel:[self voucherChannel]];
    } else if ([[segue identifier] isEqualToString:@"confirmAddress"]) {
        // Get reference to the destination view controller
        ConfirmAddressViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        UIButton *selectedButton = (UIButton *)sender;
        [vc setSelectTagBtn:selectedButton];
        [vc setVoucherChannel:[self voucherChannel]];
    }
}

@end
