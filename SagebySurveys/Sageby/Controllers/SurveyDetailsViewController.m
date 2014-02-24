//
//  SurveyQuestionViewController.m
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SurveyDetailsViewController.h"
#import "../SageByAPIStore.h"
#import "SurveyChannel.h"
#import "SurveyQuestion.h"
#import "RatingTemplateViewController.h"
#import "RadioTemplateViewController.h"
#import "TextboxTemplateViewController.h"
#import "CheckboxViewController.h"
#import "WebViewController.h"
#import "ArrangableBoxesViewController.h"
#import "GANTracker.h"
#import "AppDelegate.h"
#import "AsyncImageView.h"
#import "AvailableSurveyListChannel.h"

@interface SurveyDetailsViewController ()

@end

@implementation SurveyDetailsViewController
@synthesize channel;
@synthesize surveyImage;
@synthesize surveyTitle;
@synthesize surveyDescription;
@synthesize activityLoad;
@synthesize delegate;
@synthesize errorImgView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.errorImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0, -80, 320, 568)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    
    /*
    NSData *imageData = [NSData dataWithContentsOfURL:[channel surveyImageFile]];
    if (imageData!=NULL) {
        surveyImage.image = [UIImage imageWithData:imageData];
    }
    
    
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
    } else {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }
    */
    CGRect frame;
    frame.size.width=100; frame.size.height=100;
    frame.origin.x=30; frame.origin.y=20;
    AsyncImageView* asyncImage = [[AsyncImageView alloc]
                                  initWithFrame:frame];
    asyncImage.tag = 999;
    //NSURL* url = [imageDownload thumbnailURLAtIndex:indexPath.row];
    [asyncImage loadImageFromURL:[channel surveyImageFile]];
    [self.view addSubview:asyncImage];
    
    surveyTitle.text = [channel title];
    surveyTitle.adjustsFontSizeToFitWidth = YES;
    surveyDescription.text = [channel description];
    //[surveyDescription sizeToFit];
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/SurveyDetailsController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"SurveyDetails GA");
}

- (void)didReceiveMemoryWarning
{
    [self setSurveyImage:nil];
    [self setSurveyTitle:nil];
    [self setSurveyDescription:nil];
    [self setActivityLoad:nil];
    [self setDelegate:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)fetchEntries:(id)sender
{
    [self.errorImgView removeFromSuperview];
    void (^completionBlock)(SurveyChannel *obj, NSHTTPURLResponse *res, NSError *err) = 
    ^(SurveyChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        [activityLoad stopAnimating];
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    AvailableSurveyListChannel *availableSurveyListChannel = [self.delegate availableSurveyListChannel];
                    NSString *chosenTaskIDString = [NSString stringWithFormat:@"%d", [[self channel] taskID]];
                    for (int i=0; i<[[availableSurveyListChannel availableSurveyList] count]; i++) {
                        SurveyChannel *s = [[availableSurveyListChannel availableSurveyList] objectAtIndex:i];
                        
                        NSString *taskIDString = [NSString stringWithFormat:@"%d", [s taskID]];
                        if ([chosenTaskIDString isEqualToString:@"1"]) {
                            if ([taskIDString isEqualToString:chosenTaskIDString]) {
                                channel = s;
                                break;
                            }
                        } else {
                            channel = obj;
                            break;
                        }
                    }
                    
                    //Determine which survey template to use based on the question type
                    NSArray *questions = [channel surveyQuestions];
                    SurveyQuestion *question = [questions objectAtIndex:0];
                    UIViewController *vc;
                    if([[question questionType] isEqual:@"Range"]){
                        vc = [[RatingTemplateViewController alloc] init];
                        [(RatingTemplateViewController *)vc setSurveyChannel:channel];
                        [(RatingTemplateViewController *)vc setSurveyQuestion:question];
                    } else if ([[question questionType] isEqual:@"SCQ"]){
                        vc = [[RadioTemplateViewController alloc] init];
                        [(RadioTemplateViewController *)vc setSurveyChannel:channel];
                        [(RadioTemplateViewController *)vc setSurveyQuestion:question];
                    } else if([[question questionType] isEqual:@"Text"]){
                        vc = [[TextboxTemplateViewController alloc] init];
                        [(TextboxTemplateViewController *)vc setSurveyChannel:channel];
                        [(TextboxTemplateViewController *)vc setSurveyQuestion:question];
                    } else if([[question questionType] isEqual:@"MCQ"]){
                        vc = [[CheckboxViewController alloc] init];
                        [(CheckboxViewController *)vc setSurveyChannel:channel];
                        [(CheckboxViewController *)vc setSurveyQuestion:question];
                    } else if([[question questionType] isEqual:@"Rank"]){
                        vc = [[ArrangableBoxesViewController alloc] init];
                        [(ArrangableBoxesViewController *)vc setSurveyChannel:channel];
                        [(ArrangableBoxesViewController *)vc setSurveyQuestion:question];
                    }
                    [[self navigationController] pushViewController:vc animated:YES];
                    
                    NSLog(@"done");
                    //This tracks the amount of clicks that the start button garnered.
                    NSError *error;
                    if (![[GANTracker sharedTracker] trackEvent:@"StartSurveyBtn"
                                                         action:@"startsurvey"
                                                          label:@"start"
                                                          value:1
                                                      withError:&error]) {
                        NSLog(@"Error: %@", error);
                    }
                    NSLog(@"StartSurveyBtn GA");
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            } else if ([res statusCode] == 1051 || [res statusCode] == 1052 ) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
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
        self.startSurveyBtn.enabled = YES;
    };

    //Call API to get survery questions
    self.startSurveyBtn.enabled = NO;
    if ([[self channel] surveyType] == 7) {
        [[SageByAPIStore sharedStore] fetchSurveyDetailsWithUserID:[self.delegate getNSDefaultUserID] withTaskID:[[self channel] taskID] withCompletion:completionBlock];
    } else {
         [self performSegueWithIdentifier:@"LimeSurvey" sender:[self channel]];
    }
   
    [activityLoad startAnimating];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"LimeSurvey"])
    {
        // Get reference to the destination view controller
        WebViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setSurveyChannel:sender];
        [[vc navigationItem] setTitle:[[self channel] title]];
    }
}
    
- (void)viewDidUnload {
    [self setStartSurveyBtn:nil];
    [super viewDidUnload];
}
@end
