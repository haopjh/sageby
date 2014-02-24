//
//  NotificationViewController.h
//  Sageby
//
//  Created by Mervyn on 15/10/12.
//
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@class AppDelegate;
@class BlockView;
@class NotificationListChannel;

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITabBarControllerDelegate>
{
    NotificationListChannel *notificationListChannel;
}

@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) UIImageView *errorImgView;
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property (weak, nonatomic) IBOutlet UITableView *notificationTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
@property (nonatomic, strong) NSArray *menuItems;

@end
