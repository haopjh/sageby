//
//  SurveyCompleteViewController.m
//  Sageby
//
//  Created by Mervyn on 24/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyCompleteViewController.h"
#import "CreditChannel.h"
#import "SurveyListViewController.h"
#import "ShareViewController.h"
#import "GANTracker.h"
#import "AppDelegate.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SurveyCompleteViewController ()

@end

@implementation SurveyCompleteViewController
@synthesize lblCreditedAmount;
@synthesize surveyPageBtn;
@synthesize creditChannel;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = @"Congratulations!";
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"Survey Completed"
                                         action:@"Survey Completed in the phone"
                                          label:@"end"
                                          value:creditChannel.creditedAmount
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"SurveyCompleted GA");
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/SurveyCompleteViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"SurveyComplete GA");
    
    lblCreditedAmount.text = [NSString stringWithFormat:@"$SC %.2f", [creditChannel creditedAmount]];
}

- (void)didReceiveMemoryWarning
{
    [self setLblCreditedAmount:nil];
    [self setSurveyPageBtn:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (IBAction)goSurveyPage:(id)sender
{
//    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil]; 
//    SurveyListViewController *surveyListvc = [secondStoryBoard instantiateViewControllerWithIdentifier: @"SurveyListViewController"];
//    [self.navigationController pushViewController:surveyListvc animated:YES];
    [self.delegate.surveyListvc fetchEntries];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goTwitterShare:(id)sender
{
    //This tracks the amount of clicks that the Twitter button garnered.
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"Twitter Sharing button"
                                         action:@"twittershare"
                                          label:@"TwitterLabel"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    NSLog(@"Twitter GA");
    
    TWTweetComposeViewController *tweetsheet = [[TWTweetComposeViewController alloc] init];
    [tweetsheet setInitialText:@"I just got rewarded while doing survey! Check this out -> http://tinyurl.com/sagebysurveys"];
    [self presentModalViewController:tweetsheet animated:YES];
}

- (IBAction)goFaceBookShare:(id)sender
{
    //This tracks the amount of clicks that the Twitter button garnered.
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"Facebook Sharing button"
                                         action:@"facebookshare"
                                          label:@"FacebookLabel"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    
    NSLog(@"Facebook GA");
    
    if (FBSession.activeSession.isOpen) {
        ShareViewController *sharevc = [[ShareViewController alloc] init];
        [sharevc setShareType:ShareViewControllerShareTypeReferral];
        [self presentModalViewController:sharevc animated:YES];
    } else {
        [self.delegate openSessionWithAllowLoginUI:NO  withShareType:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
