//
//  TextboxTemplateViewController.m
//  Sageby
//
//  Created by Mervyn on 25/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SageByAPIStore.h"
#import "RatingTemplateViewController.h"
#import "SurveyQuestion.h"
#import "RadioTemplateViewController.h"
#import "TextboxTemplateViewController.h"
#import "CheckboxViewController.h"
#import "ArrangableBoxesViewController.h"
#import "CreditChannel.h"
#import "SurveyCompleteViewController.h"
#import "SurveyChannel.h"
#import "AppDelegate.h"
#import "ProgressView.h"
#import "ConfirmationPopupView.h"
#import "TabBarViewController.h"

@interface TextboxTemplateViewController ()

@end

@implementation TextboxTemplateViewController
@synthesize activityLoad;
@synthesize surveyChannel, surveyQuestion;
@synthesize delegate;
@synthesize confirmationPopupView;
@synthesize questionLabel;


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
    NSString *question = [[self surveyChannel] questionContent:[surveyQuestion questionID]];
    questionLabel.text = [NSString stringWithFormat:@"%@", question];
    //[questionLabel sizeToFit];
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

//Check if all required fields are filled in
- (BOOL)hasUserAnswered
{
    if (![surveyQuestion optional]) {
        if (answerField.text==NULL || [answerField.text length] == 0) {
            //alert pops up if user did not fulfil the question citeria
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Incomplete!" 
                                                         message:@"Please type your answer in the box"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            return NO;
        }
    }
    return YES;
}

//Store user's answer into the surveyModel
//@TODO Marcus, save here.
- (void)storeUserAnswer
{
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    [answers addObject:answerField.text];
    [[self surveyChannel] store:[surveyQuestion questionID] userAnswer:answers];
}

//To ensure when click done keyboard retracts
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField 
{
    [theTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [self setActivityLoad:nil];
    questionLabel = nil;
    [self setDelegate:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setQuestionLabel:nil];
    [super viewDidUnload];
}
@end
