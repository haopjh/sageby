//
//  VoucherPurchasedViewController.m
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoucherPurchasedViewController.h"
#import "RewardListViewController.h"
#import "VoucherChannel.h"
#import "VoucherPurchasedChannel.h"
#import "QRCodeViewController.h"
#import "Barcode.h"
#import "GANTracker.h"

@interface VoucherPurchasedViewController ()

@end

@implementation VoucherPurchasedViewController
@synthesize voucherPurchasedChannel;
@synthesize purchasedDescription;
@synthesize useVoucherBtn;
@synthesize voucherChannel;
@synthesize qrCodeImage;

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
    [super viewWillAppear:YES];
	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    [useVoucherBtn setHidden:YES];
    
    [self.purchasedDescription setHidden:NO];
    
    Barcode *barcode = [[Barcode alloc] init];
    if ([[self voucherPurchasedChannel] qrCodePathString]) {
        [barcode setupQRCode:[[self voucherPurchasedChannel] qrCodePathString]];
        self.qrCodeImage.image = barcode.qRBarcode;
    } else if ([[self voucherPurchasedChannel] qrCodePathURL]){
        NSString *urlString = [[[self voucherPurchasedChannel] qrCodePathURL] absoluteString];
        [barcode setupQRCode:urlString];
        self.qrCodeImage.image = barcode.qRBarcode;
    }
    
    
    if ([[self voucherPurchasedChannel] securityCode]) {
        self.purchasedDescription.text = [NSString stringWithFormat:@"Security Code: \n %@ \n Reference: \n %@ \n Credits Left: %0.2f", [[self voucherPurchasedChannel] securityCode], [[self voucherPurchasedChannel] reference], [[self voucherPurchasedChannel] userCredit]];
    } else if ([[self voucherPurchasedChannel] resultMsg]) {
        self.purchasedDescription.text = [NSString stringWithFormat:@"%@ \n Credits Left: %0.2f", [[self voucherPurchasedChannel] resultMsg], [[self voucherPurchasedChannel] userCredit]];
    } else {
        [self.purchasedDescription setHidden:YES];
    }
    
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/VoucherPurchasedViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"VoucherPurchasedViewController GA");
}

- (void)didReceiveMemoryWarning
{
    [self setPurchasedDescription:nil];
    [self setUseVoucherBtn:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goToQRCodePage:(id)sender
{
    [self.voucherChannel setQrCodePathString:[[self voucherPurchasedChannel] qrCodePathString]];
    [self.voucherChannel setQrCodePathURL:[[self voucherPurchasedChannel] qrCodePathURL]];
    [self performSegueWithIdentifier:@"UseNow" sender:[self voucherChannel]];
}

- (IBAction)goToRewardPage:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"UseNow"])
    {
        // Get reference to the destination view controller
        QRCodeViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setVoucherChannel:sender];
    }
}

- (void)viewDidUnload {
    [self setQrCodeImage:nil];
    [super viewDidUnload];
}
@end
