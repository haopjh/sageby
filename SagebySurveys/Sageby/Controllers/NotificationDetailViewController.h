//
//  NotificationDetailViewController.h
//  Sageby
//
//  Created by Mervyn on 22/10/12.
//
//

#import <UIKit/UIKit.h>
@class Notification;
@class AppDelegate;

@interface NotificationDetailViewController : UIViewController <UIWebViewDelegate>
{
    BOOL checkURL;
}

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) Notification *notification;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *bodyLabel;
@property (weak, nonatomic) IBOutlet UIWebView *htmlContent;

@end
