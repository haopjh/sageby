//
//  VoucherDetailsViewController.h
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProfileView;
@class VoucherChannel;
@class AppDelegate;
@class BlockView;
@class ConfirmationPopupView;

@interface VoucherDetailsViewController : UIViewController

@property (nonatomic, strong) VoucherChannel *voucherChannel;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) UIButton *selectTagBtn;
@property (nonatomic, strong) ConfirmationPopupView *confirmationPopupView;
@property (nonatomic, strong) ProfileView *profileView;

@property (weak, nonatomic) IBOutlet UILabel *voucherTitle;
@property (weak, nonatomic) IBOutlet UIImageView *voucherImage;
@property (weak, nonatomic) IBOutlet UILabel *voucherDescription;
@property (weak, nonatomic) IBOutlet BlockView *blockView;

- (void)openPurchaseConfirmationPopup:(id)sender;
- (IBAction)openUserProfilePopup:(id)sender;

@end
