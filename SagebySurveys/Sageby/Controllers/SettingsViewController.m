//
//  SettingsViewController.m
//  Sageby
//
//  Created by LuoJia on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "ShareViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "GANTracker.h"
#import "ATConnect.h"
#import "ShareViewController.h"
#import "IntroductionViewController.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController
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
	// Do any additional setup after loading the view.
    tableData = [NSArray arrayWithObjects:@"Feedback", @"Social Share", @"Walkthrough", @"About Us", nil];
    tableLogoutData = [NSArray arrayWithObjects:@"Logout", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/SettingsViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"Settings GA");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    //Here you must return the number of sectiosn you want
    int returnValue = 2;
    
    return returnValue;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int returnValue = 0;
    if(section == 0){
        returnValue = 4;
    } else if(section == 1) {
        returnValue = 1;
    }
    
    return returnValue;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    if([indexPath section] == 0){
        cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    } else if([indexPath section] == 1) {
        cell.textLabel.text = [tableLogoutData objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor redColor];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section]== 1 && [indexPath row] == 0) {
        //GA
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"User logged out of app"
                                             action:@"logged out"
                                              label:@"end"
                                              value:0
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
        NSLog(@"SurveyCompleted GA");
        
        NSLog(@"selected again");
        [self userLogout];
    } else if ([indexPath section]==0 && [indexPath row]==0){
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"User clicked on the feedback button"
                                             action:@"feedback"
                                              label:@"feedback"
                                              value:1
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
        ATConnect *connection = [ATConnect sharedConnection];
        [connection presentFeedbackControllerFromViewController:self];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [connection setEmail:[defaults objectForKey:@"SagebyUserEmail"]];
        [[self tabBarController] setSelectedIndex:2];
    } else if([indexPath section]==0 && [indexPath row]==2){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        IntroductionViewController *walkthroughTutorial = [storyboard instantiateViewControllerWithIdentifier: @"IntroductionViewController"];
        [walkthroughTutorial setSourcevc:self];
        [self presentModalViewController:walkthroughTutorial animated:NO];
    } else if([indexPath section]==0 && [indexPath row]==3){
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"User clicked on the About button"
                                             action:@"about"
                                              label:@"end"
                                              value:1
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
        
        NSString *msg = [NSString stringWithFormat:@"Sageby Surveys Version 1.2.2 is proudly brought to you by \nSageby Pte Ltd.\n For more details, do checkout Sageby's website at www.sageby.com for more details."];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    } else {
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"Social Share button"
                                             action:@"notifications"
                                              label:@"end"
                                              value:1
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
        
        NSString *msg = [NSString stringWithFormat:@"Let's Share The App!"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Social Share" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [av addButtonWithTitle:@"Facebook"];
        [av addButtonWithTitle:@"Twitter"];
        [av show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Facebook"]) {
        NSLog(@"Clicked button index 0");
        //This tracks the amount of clicks that the Twitter button garnered.
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"Facebook Sharing button in Settings"
                                             action:@"facebookshare"
                                              label:@"FacebookLabel"
                                              value:1
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
        
        NSLog(@"Facebook GA");
        if (FBSession.activeSession.isOpen) {
            ShareViewController *sharevc = [[ShareViewController alloc] init];
            [sharevc setShareType:ShareViewControllerShareTypeApp];
            [self presentModalViewController:sharevc animated:NO];
        } else {
            [self.delegate openSessionWithAllowLoginUI:NO  withShareType:self];
        }
    } else if([title isEqualToString:@"Twitter"]) {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
        //This tracks the amount of clicks that the Twitter button garnered.
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"Twitter Sharing button in Settings"
                                             action:@"twittershare"
                                              label:@"TwitterLabel"
                                              value:1
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
        NSLog(@"Twitter GA");
        
        TWTweetComposeViewController *tweetsheet = [[TWTweetComposeViewController alloc] init];
        [tweetsheet setInitialText:@"I just got rewarded while doing survey! Check this out -> http://tinyurl.com/sagebysurveys"];
        [self presentModalViewController:tweetsheet animated:NO];
    }
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)userLogout
{
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]; 
//    LoginViewController *loginvc = [secondStoryBoard instantiateViewControllerWithIdentifier: @"LoginViewController"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"SagebyUserID"]) {
        if ([defaults objectForKey:@"FBAccessTokenKey"]) {
            if (FBSession.activeSession.isOpen) {
                [FBSession.activeSession closeAndClearTokenInformation];
            }
            [defaults removeObjectForKey:@"FBAccessTokenKey"];
            [defaults removeObjectForKey:@"FBExpirationDateKey"];
        }
        [defaults removeObjectForKey:@"SagebyUserID"];
        [defaults synchronize];
    }
    
    [[self tabBarController] setSelectedIndex:0];
    
    self.delegate.window.rootViewController = self.delegate.loginvc;
    [self.delegate.window.rootViewController dismissModalViewControllerAnimated:NO];
}

@end
