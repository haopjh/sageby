//
//  SurveyViewController.m
//  Sageby
//
//  Created by Mervyn on 12/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyListViewController.h"
#import "SurveyDetailsViewController.h"
#import "SurveyChannel.h"
#import "AvailableSurveyListChannel.h"
#import "SageByAPIStore.h"
#import <QuartzCore/QuartzCore.h>
#import "GANTracker.h"
#import "CustomCell.h"
#import "AppDelegate.h"
#import "BlockView.h"
#import "ProfileView.h"
#import "SVPullToRefresh.h"
#import "AsyncImageView.h"

@interface SurveyListViewController ()

@end

@implementation SurveyListViewController
@synthesize surveyTableView;
@synthesize activityLoad;
@synthesize delegate;
@synthesize blockView;
@synthesize profileView;
@synthesize errorImgView;

- (void)didReceiveMemoryWarning
{
    [self setSurveyTableView:nil];
    [self setActivityLoad:nil];
    [self setDelegate:nil];
    [self setBlockView:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[availableSurveyListChannel availableSurveyList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Cells are loading now!");
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [surveyTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    SurveyChannel *survey = [[availableSurveyListChannel availableSurveyList ] objectAtIndex:indexPath.row];
    
    [[cell primaryLabel] setText:[survey title]];
    
    [[cell secondaryLabel] setText:[survey description]];
    NSString *msg = [[NSString alloc] initWithFormat:@"Duration: %dmins SCredits: %0.2f \nExpiry: %@", [survey timeNeeded], [survey creditAmount], [self.delegate setFormatWithDate:[survey endDate]]];
    [[cell secondaryLabel] setText:msg];
    int left = [survey maximumParticipants] - [survey currentParticipants];
    [[cell responseLabel] setText:[[NSString alloc] initWithFormat:@"%d", left]];
    
    [activityLoad stopAnimating];
    
    
    /*
    NSData *imageData = [NSData dataWithContentsOfURL:[survey surveyImageFile]];
    if (imageData!=NULL) {
        [[cell myImageView] setImage:[UIImage imageWithData:imageData]];
    }
    else{
        [[cell myImageView] setImage:[UIImage imageNamed:@"AppIcon50.png"]];
    }
    
     */
    
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
    } else {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    
    CGRect frame;
    frame.size.width=50; frame.size.height=50;
    frame.origin.x=12; frame.origin.y=10;
    AsyncImageView* asyncImage = [[AsyncImageView alloc]
                                  initWithFrame:frame];
    asyncImage.tag = 999;
    //NSURL* url = [imageDownload thumbnailURLAtIndex:indexPath.row];
    [asyncImage loadImageFromURL:[survey surveyImageFile]];
    
    [cell.contentView addSubview:asyncImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SurveyChannel *selectedSurvey = [[availableSurveyListChannel availableSurveyList]
                                     objectAtIndex:[indexPath row]];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"SurveyDetails" sender:selectedSurvey];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate.surveyListvc = self;
    // Create an instance of UIView (FooView).
    profileView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
    
    // Tell it where to go. Otherwise, it'll appear in the upper left corner.
    profileView.frame = CGRectMake(20, 0, 280, 180);
    self.profileView.blockView = self.blockView;
    self.profileView.sourceVC = self;
    [self.view addSubview:self.profileView];
    
    self.errorImgView= [[UIImageView alloc] initWithFrame:CGRectMake(0, -80, 320, 568)];
    
    [activityLoad startAnimating];
    [self fetchEntries];
    // setup pull-to-refresh
    [self.surveyTableView addPullToRefreshWithActionHandler:^{
        
        [self fetchEntries];
        
        int64_t delayInSeconds = 1.4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            NSLog(@"Pull down started");
            NSDate *methodStart = [NSDate date];
            
            NSTimeInterval howRecent = [methodStart timeIntervalSinceNow];
            NSLog(@"Pull down stoped with timing with %f",howRecent);
            //[self.rewardTableView endUpdates];
            
            /* ... Do whatever you need to do ... */
            
            //[surveyTableView.pullToRefreshView stopAnimating];
            
        });
    }];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[NotificationViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"NavTop"];
    }
    
    // trigger the refresh manually at the end of viewDidLoad
    //[surveyTableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/SurveyListViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"SurveyList GA");
    
    //Notification View Codes
    [super viewWillAppear:animated];
    
    //Clear off profile view if it is still there
    [self.profileView setHidden:YES];
    self.blockView.hidden = YES;

    /*
     if (![self.slidingViewController.underRightViewController isKindOfClass:[UnderRightViewController class]]) {
     self.slidingViewController.underRightViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"UnderRight"];
     }
     */
//    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    //End of Notification View Codes

}

- (void) fetchEntries
{
    [self.errorImgView removeFromSuperview];
    [self.profileView setHidden:YES];
    [self.blockView dimBlockView];
    //[activityLoad startAnimating];
    void (^completionBlock)(AvailableSurveyListChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(AvailableSurveyListChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    availableSurveyListChannel = obj;
//                    availableSurveyListChannel = self.delegate.availableSurveyListChannel;
                    if ([[availableSurveyListChannel availableSurveyList]count] == 0) {
                        UIImage *img = [UIImage imageNamed:@"nosurvey.jpg"];
                        self.errorImgView.image = img;
                        [self.view addSubview:self.errorImgView];
                    }
                    [[self surveyTableView] reloadData];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            } else if ([res statusCode] == 1041 ) {
                UIImage *img = [UIImage imageNamed:@"nosurvey.jpg"];
                self.errorImgView.image = img;
                [self.view addSubview:self.errorImgView];
            } else {
                UIImage *img = [UIImage imageNamed:@"empty.jpg"];
                self.errorImgView.image = img;
                [self.view addSubview:self.errorImgView];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        } else if ([err code] == -1009) {
            UIImage *img = [UIImage imageNamed:@"noconnection.jpg"];
            self.errorImgView.image = img;
            [self.view addSubview:self.errorImgView];
        } else {
            UIImage *img = [UIImage imageNamed:@"generalerror.jpg"];
            self.errorImgView.image = img;
            [self.view addSubview:self.errorImgView];
        }
        [surveyTableView.pullToRefreshView stopAnimating];
        [self.blockView clearBlockView];
        [activityLoad stopAnimating];
    };
    
    [[SageByAPIStore sharedStore] fetchAvailableSurveysWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
    
    NSLog(@"Entries are fetching now!%@",completionBlock);
}

- (IBAction)openUserProfilePopup:(id)sender
{
    [self.profileView showHideProfileView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"SurveyDetails"])
    {
        // Get reference to the destination view controller
        SurveyDetailsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        SurveyChannel *abc = (SurveyChannel *)sender;
        NSLog(@"sender %@", [abc surveyImageFile]);
        [vc setChannel:sender];
    }
}

- (IBAction)revealMenu:(id)sender {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
