//
//  ConfirmAddressViewController.m
//  Sageby
//
//  Created by LuoJia on 9/10/12.
//
//

#import "ConfirmAddressViewController.h"
#import "AppDelegate.h"
#import "VoucherChannel.h"
#import "SageByAPIStore.h"
#import "UserProfileChannel.h"
#import "VoucherPurchasedChannel.h"
#import "VoucherPurchasedViewController.h"

@interface ConfirmAddressViewController ()

@end

@implementation ConfirmAddressViewController

@synthesize firstNameField, lastNameField, postalCodeField, streetField, unitField, voucherChannel, confirmBtn, selectTagBtn, userProfileChannel;


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
}

/*********************************************************************
 CONTENT OFFSET WHEN KEYBOARD UP CODES
 *********************************************************************/
//Edit HERE to define how much to offset
#define kOFFSET_FOR_KEYBOARD 50.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.confirmBtn.enabled = NO;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    void (^completionBlock)(UserProfileChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(UserProfileChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    self.confirmBtn.enabled = YES;
                    firstNameField.text = [obj user_profile_first_name];
                    lastNameField.text = [obj user_profile_last_name];
                    postalCodeField.text = [obj user_address_postal_code];
                    streetField.text = [obj user_address_street];
                    unitField.text = [obj user_address_unit];

                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    self.confirmBtn.enabled = YES;
                }
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
                self.confirmBtn.enabled = YES;
            }
        } else if ([err code] == -1009) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            self.confirmBtn.enabled = YES;
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            self.confirmBtn.enabled = YES;
        }
    };
    
    //Call API to get users
    [[SageByAPIStore sharedStore] fetchUserProfileWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
}


- (void)didReceiveMemoryWarning
{
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setStreetField:nil];
    [self setUnitField:nil];
    [self setPostalCodeField:nil];
    [self setConfirmBtn:nil];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAddress:(id)sender
{
    self.confirmBtn.enabled = NO;
    if ([self validateFields]) {
        void (^completionBlock)(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err) =
        ^(VoucherPurchasedChannel *obj, NSHTTPURLResponse *res, NSError *err) {
            if(!err){
                if ([res statusCode] == 200) {
                    if (![obj errorMsg]) {
                        [self performSegueWithIdentifier:@"purchased" sender:obj];
                    } else {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    }
                } else if ([res statusCode] == 1092 ) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            } else if ([err code] == -1009) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
            self.confirmBtn.enabled = YES;
        };
        
        [[SageByAPIStore sharedStore] purchaseVoucherWithUserID:[self.delegate getNSDefaultUserID] withVoucherID:[self.voucherChannel voucherID] withVoucherCost:[[[voucherChannel voucherCostList] objectAtIndex:[self.selectTagBtn tag]] doubleValue] withUserInfo:userProfileChannel withCompletion:completionBlock];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Incomplete!"
                                                     message:@"Please fill in all blanks"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        self.confirmBtn.enabled = YES;
    }
}

- (BOOL)validateFields
{
    BOOL isValid = TRUE;
    
    if (firstNameField.text==NULL || [firstNameField.text length] == 0) {
        isValid = FALSE;
    }
    if (lastNameField.text==NULL || [lastNameField.text length] == 0) {
        isValid = FALSE;
    }
    if (postalCodeField.text==NULL || [postalCodeField.text length] == 0) {
        isValid = FALSE;
    }
    if (streetField.text==NULL || [streetField.text length] == 0) {
        isValid = FALSE;
    }
    if (unitField.text==NULL || [unitField.text length] == 0) {
        isValid = FALSE;
    }
    
    if (isValid) {
        userProfileChannel = [[UserProfileChannel alloc] init];
        [userProfileChannel setUser_profile_first_name:firstNameField.text];
        [userProfileChannel setUser_profile_last_name:lastNameField.text];
        [userProfileChannel setUser_address_street:streetField.text];
        [userProfileChannel setUser_address_unit:unitField.text];
        [userProfileChannel setUser_address_postal_code:postalCodeField.text];
        [userProfileChannel setUser_address_country_code:@"SG"];
    }
    return isValid;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"purchased"]) {
        // Get reference to the destination view controller
        VoucherPurchasedViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setVoucherPurchasedChannel:sender];
        [vc setVoucherChannel:[self voucherChannel]];
    }
}

@end
