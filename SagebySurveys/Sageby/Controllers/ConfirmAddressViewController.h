//
//  ConfirmAddressViewController.h
//  Sageby
//
//  Created by LuoJia on 9/10/12.
//
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@class VoucherChannel;
@class UserProfileChannel;

@interface ConfirmAddressViewController : UIViewController

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) VoucherChannel *voucherChannel;
@property (nonatomic, strong) UserProfileChannel *userProfileChannel;
@property (nonatomic, strong) UIButton *selectTagBtn;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *unitField;
@property (weak, nonatomic) IBOutlet UITextField *postalCodeField;
@property (weak, nonatomic) IBOutlet UILabel *confirmBtn;

- (IBAction)confirmAddress:(id)sender;

@end
