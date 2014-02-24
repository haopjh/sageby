//
//  RewardListViewController.h
//  Sageby
//
//  Created by LuoJia on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RewardChannel;
@class AppDelegate;
@class BlockView;
@class ProfileView;

typedef enum {
    RewardListViewControllerRewardTypeStore,
    RewardListViewControllerRewardTypeWallet
} RewardListViewControllerRewardType;

@interface RewardListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    RewardListViewControllerRewardType rewardType;
}

@property (nonatomic, strong) RewardChannel *storeRewardChannel;
@property (nonatomic, strong) RewardChannel *walletRewardChannel;
@property (nonatomic, strong) AppDelegate *delegate;
@property (nonatomic, strong) ProfileView *profileView;
@property (nonatomic, strong) UIImageView *errorImgView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *rewardTypeControl;
@property (weak, nonatomic) IBOutlet UITableView *rewardTableView;
@property (weak, nonatomic) IBOutlet BlockView *blockView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoad;
- (IBAction)openUserProfilePopup:(id)sender;


@end
