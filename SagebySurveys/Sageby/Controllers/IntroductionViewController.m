//
//  IntroductionViewController.m
//  Sageby
//
//  Created by LuoJia on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntroductionViewController.h"
#import "GANTracker.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"


@interface IntroductionViewController ()

@end

@implementation IntroductionViewController
@synthesize pageControl;
@synthesize images;
@synthesize scrollView;
@synthesize delegate;
@synthesize sourcevc;

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
    
    //This tracks the amount of clicks that the start button garnered.
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"StartIntroBtn"
                                         action:@"startIntro"
                                          label:@"Intro"
                                          value:1
                                      withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"StartIntroBtn GA");
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIImage *imgOne = [UIImage imageNamed:@"1Welcome.png"];
    UIImage *imgTwo = [UIImage imageNamed:@"2Survey.png"];
    UIImage *imgThree = [UIImage imageNamed:@"3Rewards.png"];
    UIImage *imgFour = [UIImage imageNamed:@"4Mapview.png"];
    UIImage *imgFive = [UIImage imageNamed:@"5QRcode.png"];
    self.images = [NSArray arrayWithObjects:imgOne, imgTwo, imgThree, imgFour, imgFive, nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    pageControl.numberOfPages = [self.images count];
    pageControl.currentPage = 0;

    for (int i = 0; i < [self.images count]; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *subview = [[UIImageView alloc] initWithFrame:frame];
        subview.image = [self.images objectAtIndex:i];
        [self.scrollView addSubview:subview];
    }
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.images count], scrollView.frame.size.height);
    [self.pageControlView bringSubviewToFront:self.scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"begin dragging");
    NSLog(@"begin pageControl: %d", self.pageControl.currentPage);
    if (self.pageControl.currentPage == 4) {
        if ([self.sourcevc isMemberOfClass:NSClassFromString(@"LoginViewController")]) {
            [self.delegate.loginvc goToSurvey];
        } else if ([self.sourcevc isMemberOfClass:NSClassFromString(@"SettingsViewController")]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"end dragging");
    NSLog(@"end pageControl: %d", self.pageControl.currentPage);
    pageControlUsed = NO;
}


- (IBAction)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [self setPageControl:nil];
    [self setImages:nil];
    [self setScrollView:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setPageControlView:nil];
    [super viewDidUnload];
}
@end
