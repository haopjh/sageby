//
//  NotificationViewController.m
//  Sageby
//
//  Created by Mervyn on 15/10/12.
//
//

#import "NotificationViewController.h"
#import "NotificationCell.h"
#import "SageByAPIStore.h"
#import "NotificationListChannel.h"
#import "Notification.h"
#import "AppDelegate.h"
#import "BlockView.h"
#import "NotificationDetailViewController.h"
#import "GANTracker.h"

@implementation NotificationViewController
@synthesize menuItems;
@synthesize blockView;
@synthesize delegate;
@synthesize notificationTableView;
@synthesize activityLoad;
@synthesize errorImgView;

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
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.errorImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -80, 320, 568)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.isViewLoaded && self.view.window) {
        // viewController is visible
        [self fetchEntries];
    }
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/NotificationViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"NotificationView GA");
}

- (void)didReceiveMemoryWarning
{
    [self setBlockView:nil];
    [self setNotificationTableView:nil];
    [self setActivityLoad:nil];
    [self setErrorImgView:nil];
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if ([[notificationListChannel notificationList] count] == 0) {
        return 1;
    } else {
        return [[notificationListChannel notificationList] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NotificationCell";
    
    NotificationCell *cell = [self.notificationTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if ([[notificationListChannel notificationList] count] == 0) {
        //@mervyn: style this when there's no notification
        [[cell timeDateLabel] setHidden:YES];
        [[cell bodyLabel] setHidden:YES];
        [[cell titleLabel] setText:@"No Notification"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    } else {
        Notification *notification = [[notificationListChannel notificationList] objectAtIndex:indexPath.row];
        [[cell timeDateLabel] setHidden:NO];
        [[cell titleLabel] setHidden:NO];
        [[cell bodyLabel] setHidden:NO];
        [[cell timeDateLabel] setText:[self.delegate setFormatWithDate:[notification date]]];
        [[cell titleLabel] setText:[notification title]];
        [[cell bodyLabel] setText:[notification convertEntiesInString:[notification body]]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[notificationListChannel notificationList] count] != 0) {
        Notification *selectedNotification = [[notificationListChannel notificationList]
                                              objectAtIndex:[indexPath row]];
        [self performSegueWithIdentifier:@"NotificationDetails" sender:selectedNotification];
        
        //GA
        NSError *error;
        if (![[GANTracker sharedTracker] trackEvent:@"user clicked on a notification cell"
                                             action:@"check notification"
                                              label:@"share"
                                              value:1
                                          withError:&error]) {
            NSLog(@"Error: %@", error);
        }
    }
}

- (void)fetchEntries
{
    [self.errorImgView removeFromSuperview];
    [self.blockView dimBlockView];
    [activityLoad startAnimating];
    void (^completionBlock)(NotificationListChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(NotificationListChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    notificationListChannel = obj;
                    [[self notificationTableView] reloadData];
                    [self.blockView clearBlockView];
                } else {
                    if (self.isViewLoaded && self.view.window) {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    }
                }
            } else {
                if (self.isViewLoaded && self.view.window) {
                    UIImage *img = [UIImage imageNamed:@"empty.jpg"];
                    errorImgView.image = img;
                    [self.view addSubview:self.errorImgView];
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            }
        } else if ([err code] == -1009) {
            if (self.isViewLoaded && self.view.window) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"No Connection" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        } else {
            if (self.isViewLoaded && self.view.window) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[err description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        }
        [activityLoad stopAnimating];
    };
    
    [[SageByAPIStore sharedStore] fetchUserNotificationsWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"NotificationDetails"])
    {
        // Get reference to the destination view controller
        NotificationDetailViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setNotification:sender];
    }
}

@end
