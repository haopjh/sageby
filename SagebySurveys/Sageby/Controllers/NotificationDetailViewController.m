//
//  NotificationDetailViewController.m
//  Sageby
//
//  Created by Mervyn on 22/10/12.
//
//

#import "NotificationDetailViewController.h"
#import "Notification.h"
#import "AppDelegate.h"
#import "SurveyListViewController.h"
#import "ECSlidingViewController.h"
#import "TabBarViewController.h"

@interface NotificationDetailViewController ()

@end

@implementation NotificationDetailViewController
@synthesize notification;
@synthesize htmlContent;

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
}

- (void) didReceiveMemoryWarning
{
    [self setFromLabel:nil];
    [self setTitleLabel:nil];
    [self setDateTimeLabel:nil];
    [self setBodyLabel:nil];
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    checkURL = NO;
    [self.titleLabel setText:[self.notification title]];
    [self.bodyLabel setText:@""];
    [self.dateTimeLabel setText:[self.delegate setFormatWithDate:[self.notification date]]];
    
    NSString *rootDocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [rootDocumentsPath stringByAppendingPathComponent:@"notification.html"];
    NSError *error = nil;
    NSString *notificationHTMLBody = [NSString stringWithFormat:@"<font face=\"Helvetica\" color=\"white\">%@</font>", [self.notification body]];
    if([notificationHTMLBody writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error])
    {
        NSLog(@"success");
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.htmlContent loadRequest:request];
    } else {
        NSLog(@"fail");
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    checkURL = NO;
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
    [self setHtmlContent:nil];
    [super viewDidUnload];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL returnValue = YES;
    if (checkURL) {
        NSString *urlString = [request.URL absoluteString];
        if ([urlString rangeOfString:@"survey"].location != NSNotFound) {
            NSLog(@"survey no");
            ECSlidingViewController *slidingvc = (ECSlidingViewController *)self.delegate.window.rootViewController;
            [slidingvc resetTopView];
        } else if ([urlString rangeOfString:@"redemption"].location != NSNotFound) {
            ECSlidingViewController *slidingvc = (ECSlidingViewController *)self.delegate.window.rootViewController;
            TabBarViewController *tabvc = (TabBarViewController *)slidingvc.topViewController;
            tabvc.selectedViewController = [tabvc.viewControllers objectAtIndex:1];
            [slidingvc resetTopView];
            NSLog(@"redemption no");
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Current not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        }
    } else {
        checkURL = YES;
    }
    return returnValue;
}

@end
