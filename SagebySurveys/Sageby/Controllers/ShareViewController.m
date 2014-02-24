//
//  ShareViewController.m
//  Sageby
//
//  Created by Mervyn on 27/9/12.
//
//

#import "ShareViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "GANTracker.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize shareType;
@synthesize postMessageTextView;
@synthesize activityLoad;

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
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.shareButtonAction.enabled = YES;
    [self.activityLoad stopAnimating];
    
    if (shareType == ShareViewControllerShareTypeReferral) {
        self.postMessageTextView.text = @"I just earned credits by doing this survey! Join Sageby to do surveys and earn credits with me!";
    }
    
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/ShareViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"ShareViewController GA");
}

- (void)didReceiveMemoryWarning
{
    [self setCancelButtonAction:nil];
    [self setShareButtonAction:nil];
    [self setPostMessageTextView:nil];
    [self setPostImageView:nil];
    [self setPostNameLabel:nil];
    [self setPostCaptionLabel:nil];
    [self setPostDescriptionLabel:nil];
    [self setActivityLoad:nil];
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sharePost:(id)sender
{
    self.shareButtonAction.enabled = NO;
    [self.activityLoad startAnimating];
    [self.postMessageTextView resignFirstResponder];
    UIImage *img = [[UIImage alloc] initWithContentsOfFile:@"AppIcon50.png"];
    
    NSString *facebookMessage = self.postMessageTextView.text;
    NSString *link = @"http://itunes.apple.com/us/app/sageby-surveys/id550037522?ls=1&mt=8";
    
    if (shareType == ShareViewControllerShareTypeReferral) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        link = [defaults objectForKey:@"SagebyReferral"];
    }
    //@"187316361329840", @"app_id",

    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   facebookMessage,
                                   @"message",
                                   link, @"link",
                                   img, @"picture",
                                   @"Sageby Surveys", @"name",
                                   @"Get Rewarded while doing survey!", @"caption",
                                   @"Share it now!!!", @"description",nil];

    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         [self.activityLoad stopAnimating];
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
             self.shareButtonAction.enabled = YES;
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted successfully"];
             sleep(3);
             [self dismissModalViewControllerAnimated:YES];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
    //GA
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"user is sharing the completion of a survey"
                                         action:@"sharing survey"
                                          label:@"share"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
}

- (IBAction)cancelPost:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    //GA
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"user does not want to share the completion of a survey"
                                         action:@"not sharing survey"
                                          label:@"share"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
}
@end
