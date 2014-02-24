//
//  ProfileView.h
//  Sageby
//
//  Created by Mervyn on 28/10/12.
//
//

#import <UIKit/UIKit.h>
@class UserProfileChannel;
@class AppDelegate;
@class BlockView;

@interface ProfileView : UIView
{
    UserProfileChannel *userProfile;
    AppDelegate *delegate;
}

@property (nonatomic, strong) BlockView *blockView;
@property (nonatomic, strong) UIViewController *sourceVC;

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UILabel *userCredit;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoad;


- (IBAction)closePopup:(id)sender;

- (void)showHideProfileView;

@end
