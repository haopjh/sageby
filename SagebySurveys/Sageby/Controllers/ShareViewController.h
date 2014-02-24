//
//  ShareViewController.h
//  Sageby
//
//  Created by Mervyn on 27/9/12.
//
//

#import <UIKit/UIKit.h>
@class AppDelegate;

typedef enum {
    ShareViewControllerShareTypeApp,
    ShareViewControllerShareTypeReferral
} ShareViewControllerShareType;

@interface ShareViewController : UIViewController

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, assign) ShareViewControllerShareType shareType;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButtonAction;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButtonAction;
@property (weak, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;

- (IBAction)sharePost:(id)sender;
- (IBAction)cancelPost:(id)sender;

@end
