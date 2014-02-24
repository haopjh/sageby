//
//  IntroductionViewController.h
//  Sageby
//
//  Created by LuoJia on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;

@interface IntroductionViewController : UIViewController <UIScrollViewDelegate>
{
    BOOL pageControlUsed;
}

@property (nonatomic, strong) AppDelegate *delegate;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIViewController *sourcevc;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *pageControlView;

- (IBAction) changePage:(id)sender;

@end
