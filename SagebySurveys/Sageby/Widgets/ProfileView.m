//
//  ProfileView.m
//  Sageby
//
//  Created by Mervyn on 28/10/12.
//
//

#import "ProfileView.h"
#import "UserProfileChannel.h"
#import "AppDelegate.h"
#import "ErrorPageView.h"
#import "SageByAPIStore.h"
#import "BlockView.h"
#import "VoucherDetailsViewController.h"

@implementation ProfileView

@synthesize blockView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)closePopup:(id)sender
{
    [self setHidden:YES];
    [self.blockView clearBlockView];
}

- (void)showHideProfileView
{
    if ([self isHidden]) {
        if ([self sourceVC]) {
            [[(VoucherDetailsViewController *)[self sourceVC] view] bringSubviewToFront:self];
        }
        
        [self setHidden:NO];
        [self.blockView dimBlockView];
        delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self.imageLoad startAnimating];
        void (^completionBlock)(UserProfileChannel *obj, NSHTTPURLResponse *res, NSError *err) =
        ^(UserProfileChannel *obj, NSHTTPURLResponse *res, NSError *err) {
            if(!err){
                if ([res statusCode] == 200) {
                    if (![obj errorMsg]) {
                        userProfile = obj;
                        
                        NSString *name = [userProfile userName];
                        self.userName.text = [NSString stringWithFormat:@"%@", name];
                        
                        float credit = [userProfile userCredit];
                        self.userCredit.text = [NSString stringWithFormat:@"%.2f", credit];
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:[userProfile userImageFile]];
                        
                        if (imageData) {
                            self.userImage.image = [UIImage imageWithData:imageData];
                        }
                        else{
                            self.userImage.image = [UIImage imageNamed:@"111-user.png"];
                        }
                    } else {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    }
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            } else if ([err code] == -1009) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"No Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
            [self.imageLoad stopAnimating];
        };
        
        //Call API to get users
        [[SageByAPIStore sharedStore] fetchUserProfileWithUserID:[delegate getNSDefaultUserID] withCompletion:completionBlock];
    } else {
        [self setHidden:YES];
        [self.blockView clearBlockView];
    }
}

@end
