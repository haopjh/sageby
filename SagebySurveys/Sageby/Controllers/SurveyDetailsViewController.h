//
//  SurveyQuestionViewController.h
//  Sageby
//
//  Created by LuoJia on 24/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SurveyChannel;
@class WebViewController;
@class AppDelegate;

@interface SurveyDetailsViewController : UIViewController

@property (nonatomic, strong) SurveyChannel *channel;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) UIImageView *errorImgView;
@property (weak, nonatomic) IBOutlet UIImageView *surveyImage;
@property (weak, nonatomic) IBOutlet UILabel *surveyTitle;
@property (weak, nonatomic) IBOutlet UILabel *surveyDescription;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (weak, nonatomic) IBOutlet UIButton *startSurveyBtn;


- (IBAction)fetchEntries:(id)sender;

@end
