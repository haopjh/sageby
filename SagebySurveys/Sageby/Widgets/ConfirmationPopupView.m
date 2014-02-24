//
//  ConfirmationPopupView.m
//  Sageby
//
//  Created by LuoJia on 29/10/12.
//
//

#import "ConfirmationPopupView.h"
#import "BlockView.h"
#import "VoucherDetailsViewController.h"
#import "AppDelegate.h"
#import "ErrorPageView.h"
#import "VoucherChannel.h"
#import "VoucherPurchasedChannel.h"
#import "SageByAPIStore.h"
#import "CheckboxViewController.h"
#import "TextboxTemplateViewController.h"
#import "RadioTemplateViewController.h"
#import "ArrangableBoxesViewController.h"
#import "RatingTemplateViewController.h"
#import "TabBarViewController.h"

@implementation ConfirmationPopupView

@synthesize voucherChannel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)cancelConfirmation:(id)sender
{
    [self setHidden:YES];
    [self.blockView clearBlockView];
}

- (IBAction)proceedConfirmation:(id)sender
{
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self confirmationType] == ConfirmationPopupViewTypePurchase) {
        [self purchaseVoucher];
    } else {
        [self exitFromSurvey];
    }
}

- (void)showConfirmationView
{
    if ([self confirmationType] == ConfirmationPopupViewTypePurchase) {
        [self.blockView dimBlockView];
        [self.confirmationMsgLabel setText: [NSString stringWithFormat:@"Confirm purchase of\n%@ \nwith SC$%0.2f?", [voucherChannel title], [[[voucherChannel voucherCostList] objectAtIndex:[self.selectTagBtn tag]] floatValue]]];
        [[(VoucherDetailsViewController *)[self sourceVC] view] bringSubviewToFront:self];
    } else {
        [self.confirmationMsgLabel setText:@"All data will be lost. Confirm exit?"];
    }
    
    [self setHidden:NO];
}

- (void)purchaseVoucher
{
    [self.activityLoad startAnimating];
    if([[voucherChannel type] isEqualToString:@"Digital"]){
        void (^completionBlock)(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err) =
        ^(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err) {
            if(!err){
                [self setHidden:YES];
                [self.activityLoad stopAnimating];
                if ([res statusCode] == 200) {
                    if (![obj errorMsg]) {
                        [(VoucherDetailsViewController *)self.sourceVC performSegueWithIdentifier:@"Purchased" sender:obj];
                    } else {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                        [self.blockView clearBlockView];
                    }
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    [self.blockView clearBlockView];
                }
            } else if ([err code] == -1009) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"No Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        };
        
        [[SageByAPIStore sharedStore] purchaseVoucherWithUserID:[self.delegate getNSDefaultUserID] withVoucherID:[voucherChannel voucherID] withVoucherCost:[[[voucherChannel voucherCostList] objectAtIndex:[self.selectTagBtn tag]] doubleValue] withCompletion:completionBlock];
    }else{
        [(VoucherDetailsViewController *)self.sourceVC performSegueWithIdentifier:@"confirmAddress" sender:self.selectTagBtn];
    }
}

- (void)exitFromSurvey
{
//    if ([self.sourceVC isMemberOfClass:[CheckboxViewController class]]) {
//        [[(CheckboxViewController *)[self sourceVC] navigationController] popToRootViewControllerAnimated:NO];
//    } else if ([self.sourceVC isMemberOfClass:[RadioTemplateViewController class]]) {
//        [[(RadioTemplateViewController *)[self sourceVC] navigationController] popToRootViewControllerAnimated:NO];
//    } else if ([self.sourceVC isMemberOfClass:[RatingTemplateViewController class]]) {
//        [[(RatingTemplateViewController *)[self sourceVC] navigationController] popToRootViewControllerAnimated:NO];
//    } else if ([self.sourceVC isMemberOfClass:[TextboxTemplateViewController class]]) {
//        [[(TextboxTemplateViewController *)[self sourceVC] navigationController] popToRootViewControllerAnimated:NO];
//    } else if ([self.sourceVC isMemberOfClass:[ArrangableBoxesViewController class]]) {
//        [[(ArrangableBoxesViewController *)[self sourceVC] navigationController] popToRootViewControllerAnimated:NO];
//    }
    
    if (self.toProceedvc) {
        TabBarViewController *tbvc = (TabBarViewController *)[self.sourceVC tabBarController];
        [tbvc tabBarController:tbvc didSelectViewController:self.toProceedvc];
        [self.sourceVC.tabBarController setSelectedViewController:self.toProceedvc];
        [self.sourceVC.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.sourceVC.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
