//
//  VoucherPurchasedViewController.h
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoucherPurchasedChannel;
@class VoucherChannel;
@class AppDelegate;

@interface VoucherPurchasedViewController : UIViewController

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) VoucherChannel *voucherChannel;
@property (nonatomic, strong) VoucherPurchasedChannel *voucherPurchasedChannel;
@property (weak, nonatomic) IBOutlet UILabel *purchasedDescription;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImage;
@property (weak, nonatomic) IBOutlet UIButton *useVoucherBtn;

- (IBAction)goToQRCodePage:(id)sender;
- (IBAction)goToRewardPage:(id)sender;

@end
