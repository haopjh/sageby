//
//  LoginViewController.m
//  Sageby
//
//  Created by Mervyn on 29/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UserChannel.h"
#import "SageByAPIStore.h"
#import "IntroductionViewController.h"
#import "SurveyListViewController.h"
#import "GANTracker.h"
#import "UserProfileChannel.h"
#import "TabBarViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize activityLoad;
@synthesize scrollView;
@synthesize permissions;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize delegate;

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
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    /***********************************************************************************
     ALERT!!!!!! Disable below if you wish to run from the xib file instead of storyboard
     ************************************************************************************/
    //[[NSBundle mainBundle] loadNibNamed:@"LoginViewController" owner:self options:nil];
    // Initialize permissions
}

/*********************************************************************
 CONTENT OFFSET WHEN KEYBOARD UP CODES
 *********************************************************************/
//Edit HERE to define how much to offset
#define kOFFSET_FOR_KEYBOARD 150.0

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.facebookButton.enabled = YES;
    self.manualButton.enabled = YES;
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [activityLoad stopAnimating];
    
    [super viewWillDisappear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"BeginWalkthrough"])
    {
        // Get reference to the destination view controller
        IntroductionViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setSourcevc:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [self setActivityLoad:nil];
    [self setScrollView:nil];
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setDelegate:nil];
    [self setFacebookButton:nil];
    [self setManualButton:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//To ensure when click done keyboard retracts
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField
{
    [theTextField resignFirstResponder];
    return YES;
}

//for facebook login button
- (IBAction)loginViaFacebook:(id)sender
{
    //GA
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"User logging into app via facebook account"
                                         action:@"facebook login"
                                          label:@"login"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    [self.delegate openSessionWithAllowLoginUI:YES  withShareType:nil];
}

- (BOOL)validateManualLoginFields
{
    BOOL isValid = TRUE;
    if (usernameTextField.text==NULL || [usernameTextField.text length] == 0) {
        isValid = FALSE;
    }
    if (passwordTextField.text==NULL || [passwordTextField.text length] == 0) {
        isValid = FALSE;
    }
    return isValid;
}

- (void)storeLoginUserDetailsWithUserChannel:(UserChannel *)userChannel
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:[userChannel userID]] forKey:@"SagebyUserID"];
    [defaults synchronize];
}

- (void)fbDidLoginWithSession:(FBSession *)session withUserDetails:(NSDictionary<FBGraphUser> *)userInfo
{
    NSLog(@"facebook logging in...");
    self.facebookButton.enabled = NO;
    self.manualButton.enabled = NO;
    [activityLoad startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[session accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[session expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    void (^completionBlock)(UserChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(UserChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        [self enterSurveyPageWithUser:obj withResponse:res withError:err];
    };
    
    [[SageByAPIStore sharedStore] fetchSessionWithFacebookID:[userInfo id] withAccessToken:[session accessToken] withCompletion:completionBlock];
}

- (void)enterSurveyPageWithUser:(UserChannel *)obj withResponse:(NSHTTPURLResponse *)res withError:(NSError *)err
{
    if(!err){
        if ([res statusCode] == 200) {
            [self storeLoginUserDetailsWithUserChannel:obj];
            void (^completionBlock)(UserProfileChannel *userProfile, NSHTTPURLResponse *res, NSError *err) =
            ^(UserProfileChannel *userProfile, NSHTTPURLResponse *res, NSError *err) {
                if(!err){
                    [activityLoad stopAnimating];
                    if ([res statusCode] == 200) {
                        if (![userProfile errorMsg]) {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:[userProfile userEmail] forKey:@"SagebyUserEmail"];
                            [defaults setObject:[userProfile referrelURL] forKey:@"SagebyReferral"];
                            [defaults synchronize];
                            
                            [self viewWalkthroughPage];
                        } else {
                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[userProfile errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [av show];
                            self.facebookButton.enabled = YES;
                        }
                    } else {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                        self.facebookButton.enabled = YES;
                    }
                } else if ([err code] == -1009) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    self.facebookButton.enabled = YES;
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                    self.facebookButton.enabled = YES;
                }
            };
            
            //Call API to get users
            [[SageByAPIStore sharedStore] fetchUserProfileWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
        } else {
            self.manualButton.enabled = YES;
            self.facebookButton.enabled = YES;
            NSString *msg = [NSString stringWithFormat:@"Sorry. Incorrect Credentials"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    } else if ([err code] == -1009) {
        self.manualButton.enabled = YES;
        self.facebookButton.enabled = YES;
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    } else {
        self.manualButton.enabled = YES;
        self.facebookButton.enabled = YES;
        NSLog(@"err: %d", [err code]);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sageby Surveys is under construction. Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    if (err || [res statusCode] != 200) {
        [activityLoad stopAnimating];
    }
}

//for manual login button
- (IBAction)loginViaSageby:(id)sender
{
    self.manualButton.enabled = NO;
    self.facebookButton.enabled = NO;
    //GA
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"User logging into app via sageby account"
                                         action:@"sageby login"
                                          label:@"login"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    [activityLoad startAnimating];
    if ([self validateManualLoginFields]) {
        void (^completionBlock)(UserChannel *obj, NSHTTPURLResponse *res, NSError *err) =
        ^(UserChannel *obj, NSHTTPURLResponse *res, NSError *err) {
            [self enterSurveyPageWithUser:obj withResponse:res withError:err];
        };
        
        if ([self.usernameTextField.text isEqualToString:@"testuser"] && [self.passwordTextField.text isEqualToString:@"password"]) {
            UserProfileChannel *u = [[UserProfileChannel alloc] init];
            u.userName = @"testuser";
            UserChannel *s = [[UserChannel alloc] init];
            s.user = u;
            [self viewWalkthroughPage];
        } else {
            [[SageByAPIStore sharedStore] fetchSessionWithEmail:usernameTextField.text withPassword:passwordTextField.text withCompletion:completionBlock];
        }
    } else {
        self.manualButton.enabled = YES;
        self.facebookButton.enabled = YES;
        NSString *errorMsg = @"Please fill in your username and password.";
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [activityLoad stopAnimating];
    }
}

- (void)viewWalkthroughPage
{
    BOOL skipWalkthrough = NO;
    NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"SagebyAppVersion"]) {
        NSString *currentAppVersion = [defaults objectForKey:@"SagebyAppVersion"];
        if ([currentAppVersion isEqualToString:appversion]) {
            skipWalkthrough = YES;
        }
    }
    
    if (skipWalkthrough) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        TabBarViewController *tabvc = [storyboard instantiateViewControllerWithIdentifier: @"TabBarViewController"];
        self.delegate.slidingViewController.topViewController = tabvc;
        [self presentModalViewController:self.delegate.slidingViewController animated:NO];
        [self.delegate startSignificantChangeUpdates];
    } else {
        [self performSegueWithIdentifier:@"BeginWalkthrough" sender:self];
    }
}

- (void)goToSurvey
{    
    [self dismissModalViewControllerAnimated:YES];
    
    //slight pause to let the modal page dismiss and then start the segue
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissModalViewControllerAnimated:YES];
        TabBarViewController *tabvc = (TabBarViewController *)self.delegate.slidingViewController.topViewController;
        tabvc.selectedViewController = [tabvc.viewControllers objectAtIndex:0];
        [self presentModalViewController:self.delegate.slidingViewController animated:NO];
        [self.delegate startSignificantChangeUpdates];
        NSString *appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:appversion forKey:@"SagebyAppVersion"];
        [defaults synchronize];
    });
}



@end
