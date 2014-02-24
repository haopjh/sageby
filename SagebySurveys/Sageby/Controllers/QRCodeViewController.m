//
//  QRCodeViewController.m
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QRCodeViewController.h"
#import "VoucherChannel.h"
#import "Barcode.h"
#import "GANTracker.h"

@interface QRCodeViewController ()

@end

@implementation QRCodeViewController
@synthesize voucherChannel;
@synthesize qrCodeImage;
@synthesize decription;

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
//    NSString *code = @"jhakdfjkadjfknvadjkcamlksmk";
    
    [self.decription setHidden:NO];
    
    Barcode *barcode = [[Barcode alloc] init];
    if ([[self voucherChannel] qrCodePathString]) {
        [barcode setupQRCode:[[self voucherChannel] qrCodePathString]];
        self.qrCodeImage.image = barcode.qRBarcode;
    } else {
        NSString *urlString = [[[self voucherChannel] qrCodePathURL] absoluteString];
        [barcode setupQRCode:urlString];
        self.qrCodeImage.image = barcode.qRBarcode;
    }
    
    if ([[self voucherChannel] securityCode]) {
        self.decription.text = [NSString stringWithFormat:@"Security Code: \n %@ \n Reference: \n %@", [[self voucherChannel] securityCode], [[self voucherChannel] reference]];
    } else if ([[self voucherChannel] resultMsg]) {
        self.decription.text = [[self voucherChannel] resultMsg];
    } else {
        [self.decription setHidden:YES];
    }
    
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/QRCodeViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"QRCodeViewController GA");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [self setVoucherChannel:nil];
    [self setQrCodeImage:nil];
    [self setDecription:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
