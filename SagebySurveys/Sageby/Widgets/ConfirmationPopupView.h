//
//  ConfirmationPopupView.h
//  Sageby
//
//  Created by LuoJia on 29/10/12.
//
//

#import <UIKit/UIKit.h>
@class BlockView;
@class AppDelegate;
@class VoucherDetailsViewController;
@class AppDelegate;
@class VoucherChannel;

typedef enum {
    ConfirmationPopupViewTypePurchase,
    ConfirmationPopupViewTypeSurveyExit
} ConfirmationPopupViewType;

@interface ConfirmationPopupView : UIView
{
    id channel;
}

@property (nonatomic, assign) ConfirmationPopupViewType confirmationType;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) BlockView *blockView;
@property (nonatomic, strong) UIViewController *sourceVC;
@property (nonatomic, strong) UIViewController *toProceedvc;
@property (nonatomic, strong) VoucherChannel *voucherChannel;
@property (nonatomic, strong) UIButton *selectTagBtn;


@property (weak, nonatomic) IBOutlet UILabel *confirmationMsgLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (IBAction)cancelConfirmation:(id)sender;
- (IBAction)proceedConfirmation:(id)sender;

- (void)showConfirmationView;

@end
