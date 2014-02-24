//
//  CheckboxViewController.m
//  checker
//
//  Created by Mervyn on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckboxViewController.h"
#import "TextboxTemplateViewController.h"
#import "RatingTemplateViewController.h"
#import "RadioTemplateViewController.h"
#import "ArrangableBoxesViewController.h"
#import "SageByAPIStore.h"
#import "CreditChannel.h"
#import "SurveyCompleteViewController.h"
#import <QuartzCore/CoreAnimation.h>
#import "SurveyQuestion.h"
#import "SurveyChannel.h"
#import "AppDelegate.h"
#import "ProgressView.h"
#import "ConfirmationPopupView.h"
#import "TabBarViewController.h"

@interface CheckboxViewController ()

@end

@implementation CheckboxViewController
@synthesize surveyChannel;
@synthesize surveyQuestion;
@synthesize arForTable = _arForTable;
@synthesize arForIPs = _arForIPs;
@synthesize questionsLabel;
@synthesize activityLoad;
@synthesize delegate;
@synthesize confirmationPopupView;
@synthesize qLabel;

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
    //Determine "Next" or "Submit" to be set as the right navigation bar button which comes with different functionality
    
    UIBarButtonItem *bbiRight;
    BOOL isLastQuestion = [[self surveyChannel] isLastQuestion:[surveyQuestion questionID]];
    if (!isLastQuestion) {
        bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                                style:UIBarButtonItemStylePlain target:self action:@selector(addNewQuestionTemplate:)];
    } else {
        bbiRight = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                               style:UIBarButtonItemStylePlain target:self action:@selector(submitAnswers:)];
    }
    [[self navigationItem] setRightBarButtonItem:bbiRight];
    
    UIBarButtonItem *bbiLeft;
    BOOL isFirstQuestion = [[self surveyChannel] isFirstQuestion:[surveyQuestion questionID]];
    if (isFirstQuestion){
        bbiLeft = [[UIBarButtonItem alloc] initWithTitle:@"Exit"
                                               style:UIBarButtonItemStylePlain target:self action:@selector(openExitSurveyPopup:)];
        [[self navigationItem] setLeftBarButtonItem:bbiLeft];
        
        self.confirmationPopupView = [[[NSBundle mainBundle] loadNibNamed:@"ConfirmationPopupView" owner:self options:nil] objectAtIndex:0];
        self.confirmationPopupView.frame = CGRectMake(20, 70, 280, 180);
        [self.view addSubview:self.confirmationPopupView];
        [[self confirmationPopupView] setConfirmationType:ConfirmationPopupViewTypeSurveyExit];
        [[self confirmationPopupView] setSourceVC:self];
    }
    
    //Progress Bar
    ProgressView *progressView = [[ProgressView alloc] init];
    progressView.progress = [[self surveyChannel] userProgress:[surveyQuestion questionID]];
    self.navigationItem.titleView = progressView;

    //Set the question content, answer options where necessary
    self.arForTable = [surveyQuestion answerOptions];
	if ([self arForIPs] == nil) {
        self.arForIPs=[NSMutableArray array];
    }
    NSString *question = [[self surveyChannel] questionContent:[surveyQuestion questionID]];
//    questionsLabel.text = [NSString stringWithFormat:@"%@\n\n", question];
//    questionsLabel.numberOfLines = 0;
//    [questionsLabel sizeToFit];
    qLabel.text = [NSString stringWithFormat:@"%@", question];
    //[qLabel sizeToFit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.leftBarButtonItem.enabled = YES;
    [self.confirmationPopupView setHidden:YES];
    
    TabBarViewController *tbvc = (TabBarViewController *)[self tabBarController];
    [tbvc setNeedConfirmationvc:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.surveyQuestion setQuestionVC:self];
    TabBarViewController *tbvc = (TabBarViewController *)[self tabBarController];
    [tbvc setNeedConfirmationvc:nil];
    [super viewWillDisappear:animated];
}

- (void)openExitSurveyPopup:(id)sender
{
    [self.confirmationPopupView showConfirmationView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.arForTable count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	if([self.arForIPs containsObject:indexPath]){
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        cell.backgroundColor = [UIColor colorWithRed:0.75 green:0.8 blue:0.9 alpha:1];
	} else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.backgroundColor = [UIColor clearColor];
	}
    NSArray *values = [self.arForTable allValues];
	cell.textLabel.text=[values objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if([self.arForIPs containsObject:indexPath]){
		[self.arForIPs removeObject:indexPath];
	} else {
		[self.arForIPs addObject:indexPath];
	}
	[tableView reloadData];
}

- (void)addNewQuestionTemplate:(id)sender
{        
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if ([self hasUserAnswered]) {
        [self storeUserAnswer];
        [self performTransaction];
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (void)performTransaction
{
    UIViewController *vc;
    //Determine which survey template to use based on the question type
    SurveyQuestion *nextQuestion = [surveyChannel nextQuestion:[surveyQuestion questionID]];
    if ([nextQuestion questionVC]) {
        [[self navigationController] pushViewController:[nextQuestion questionVC] animated:YES];
    } else {
        if([[nextQuestion questionType] isEqual:@"Range"]){
            vc = [[RatingTemplateViewController alloc] init];
            [(RatingTemplateViewController *)vc setSurveyChannel:surveyChannel];
            [(RatingTemplateViewController *)vc setSurveyQuestion:nextQuestion];
        } else if ([[nextQuestion questionType] isEqual:@"SCQ"]){
            vc = [[RadioTemplateViewController alloc] init];
            [(RadioTemplateViewController *)vc setSurveyChannel:surveyChannel];
            [(RadioTemplateViewController *)vc setSurveyQuestion:nextQuestion];
        } else if([[nextQuestion questionType] isEqual:@"Text"]){
            vc = [[TextboxTemplateViewController alloc] init];
            [(TextboxTemplateViewController *)vc setSurveyChannel:surveyChannel];
            [(TextboxTemplateViewController *)vc setSurveyQuestion:nextQuestion];
        } else if([[nextQuestion questionType] isEqual:@"MCQ"]){
            vc = [[CheckboxViewController alloc] init];
            [(CheckboxViewController *)vc setSurveyChannel:surveyChannel];
            [(CheckboxViewController *)vc setSurveyQuestion:nextQuestion];
        } else if([[nextQuestion questionType] isEqual:@"Rank"]){
            vc = [[ArrangableBoxesViewController alloc] init];
            [(ArrangableBoxesViewController *)vc setSurveyChannel:surveyChannel];
            [(ArrangableBoxesViewController *)vc setSurveyQuestion:nextQuestion];
        }
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (void)submitAnswers:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if ([self hasUserAnswered]) {
        [self storeUserAnswer];
        void (^completionBlock)(CreditChannel *obj, NSHTTPURLResponse *res, NSError *err) =
        ^(CreditChannel *obj, NSHTTPURLResponse *res, NSError *err) {
            if(!err){
                if ([res statusCode] == 200) {
                    [activityLoad stopAnimating];
                    SurveyCompleteViewController *completedvc = [[SurveyCompleteViewController alloc] init];
                    [completedvc setCreditChannel:obj];
                    [[self navigationController] pushViewController:completedvc animated:YES];
                } else if ([res statusCode] == 1061 ) {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
                
            } else if ([err code] == -1009) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sageby Surveys is under construction. Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
            [activityLoad stopAnimating];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            self.navigationItem.leftBarButtonItem.enabled = YES;
        };
        
        [[SageByAPIStore sharedStore] submitSurveyWithUserID:[self.delegate getNSDefaultUserID] withSurvey:[self surveyChannel] withCompletion:completionBlock];
        [activityLoad startAnimating];
        NSLog(@"Submit");
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (BOOL)hasUserAnswered
{
    if (![surveyQuestion optional]) {
        if ([self.arForIPs count] < 1) {
            //alert pops up if user did not fulfil the question citeria
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Incomplete!" 
                                                         message:@"Please select at least one option"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return NO;
        }
        
    }
    return YES;
}

- (void)storeUserAnswer
{
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    NSArray *keys = [self.arForTable allKeys];
    for (int i=0; i<[self.arForIPs count]; i++) {
        int index = [[self.arForIPs objectAtIndex:i] row];
        [answers addObject:[keys objectAtIndex:index]];
    }
    [[self surveyChannel] store:[surveyQuestion questionID] userAnswer:answers];
}

- (void)didReceiveMemoryWarning
{
    [self setActivityLoad:nil];
    [self setQuestionsLabel:nil];
    [self setDelegate:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidUnload {
    [self setQLabel:nil];
    [super viewDidUnload];
}
@end
