//
//  WebViewController.m
//  Sageby
//
//  Created by LuoJia on 27/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebViewController.h"
#import "SurveyChannel.h"
#import "AppDelegate.h"
#import "CreditChannel.h"
#import "SurveyCompleteViewController.h"
#import "SageByAPIStore.h"
#import "TabBarViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
@synthesize externalSurveyView;
@synthesize activityLoad;
@synthesize exitSurveyPopupView;
@synthesize surveyChannel;
@synthesize delegate;
@synthesize responseData;
@synthesize toProceedvc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[self activityLoad] stopAnimating];
    [[self exitSurveyPopupView] setHidden:YES];
    
    UIBarButtonItem *bbi;   

    bbi = [[UIBarButtonItem alloc] initWithTitle:@"Exit"
                                        style:UIBarButtonItemStylePlain target:self action:@selector(openExitSurveyPopup:)];
    [[self navigationItem] setLeftBarButtonItem:bbi];
      
    NSURL *url = [[self surveyChannel] remoteURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [[self externalSurveyView] loadRequest:req];
    TabBarViewController *tbvc = (TabBarViewController *)[self tabBarController];
    [tbvc setNeedConfirmationvc:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.externalSurveyView isLoading])
        [self.externalSurveyView stopLoading];
    [[self activityLoad] stopAnimating];
    
    TabBarViewController *tbvc = (TabBarViewController *)[self tabBarController];
    [tbvc setNeedConfirmationvc:nil];
    [self setToProceedvc:nil];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.externalSurveyView setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [self setExitSurveyPopupView:nil];
    [self setExternalSurveyView:nil];
    [self setActivityLoad:nil];
    [self setToProceedvc:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)openExitSurveyPopup:(id)sender
{
    [[self exitSurveyPopupView] setHidden:NO];
}

- (IBAction)closeExitSurveyPopup:(id)sender
{
    [[self exitSurveyPopupView] setHidden:YES];
}

- (IBAction)confirmExitSurveyView:(id)sender
{
    NSString *currentURL = [self.externalSurveyView stringByEvaluatingJavaScriptFromString:@"window.location.href"]; 
    NSString *newStr = [currentURL stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    [[self surveyChannel] setEndSurveyURL:newStr];
    [[SageByAPIStore sharedStore] submitSurveyWithSynchronousRequestWithUserID:[self.delegate getNSDefaultUserID] withSurvey:[self surveyChannel]];
    if (toProceedvc) {
        TabBarViewController *tbvc = (TabBarViewController *)[self tabBarController];
        [tbvc tabBarController:tbvc didSelectViewController:toProceedvc];
        [self.tabBarController setSelectedViewController:toProceedvc];
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([error code] != NSURLErrorCancelled) {
        if ([error code] == -1009) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        } else {
            NSLog(@"err: %d", [error code]);
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sageby Surveys is under construction. Please try again later!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
        NSLog(@"error code: %d", [error code]);
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    [[self activityLoad] startAnimating];
  
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *currentURL = [webView stringByEvaluatingJavaScriptFromString:@"window.location.href"]; 
    NSString *newStr = [currentURL stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    [[self surveyChannel] setEndSurveyURL:newStr];
    NSDictionary *responseDict = [self detectEndSurvey];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)[responseDict objectForKey:@"response"];
    if (httpResponse) {
        if ([httpResponse statusCode] == 200) {
            [self.externalSurveyView setDelegate:nil];
            [self.externalSurveyView setHidden:YES];
            self.responseData = [responseDict objectForKey:@"data"];
            [self showSurveyCompletedWithCreditChannel:[responseDict objectForKey:@"data"]];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[responseDict objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    }
    [[self activityLoad] stopAnimating];
}

- (NSDictionary *)detectEndSurvey
{
    return [[SageByAPIStore sharedStore] submitSurveyWithSynchronousRequestWithUserID:[self.delegate getNSDefaultUserID] withSurvey:[self surveyChannel]];
}

- (void)showSurveyCompletedWithCreditChannel:(NSData *)data
{
    [self.externalSurveyView stopLoading];
    CreditChannel *creditChannel = [[CreditChannel alloc] init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [creditChannel readFromJSONDictionary:dict];
    SurveyCompleteViewController *completedvc = [[SurveyCompleteViewController alloc] init];
    [completedvc setCreditChannel:creditChannel];    
    [[self navigationController] pushViewController:completedvc animated:YES];
}

@end
