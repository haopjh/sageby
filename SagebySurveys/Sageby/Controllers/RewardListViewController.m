//
//  RewardListViewController.m
//  Sageby
//
//  Created by LuoJia on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RewardListViewController.h"
#import "RewardChannel.h"
#import "SageByAPIStore.h"
#import "VoucherChannel.h"
#import "VoucherDetailsViewController.h"
#import "QRCodeViewController.h"
#import "GANTracker.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "BlockView.h"
#import "ProfileView.h"
#import "SVPullToRefresh.h"
#import "SVInfiniteScrolling.h"
#import "AsyncImageView.h"
#import "VendorAnnotation.h"

@interface RewardListViewController ()

@end

@implementation RewardListViewController
@synthesize rewardTypeControl;
@synthesize rewardTableView;
@synthesize activityLoad;
@synthesize storeRewardChannel;
@synthesize walletRewardChannel;
@synthesize delegate;
@synthesize profileView;
@synthesize errorImgView;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //track this pageview
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"/RewardListViewController" withError:&error]) {
        NSLog(@"Error: %@", error);
    }
    NSLog(@"RewardListViewController GA");
    
    [self.profileView setHidden:YES];
    self.blockView.hidden = YES;
    //[self fetchEntries];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [rewardTypeControl setSelectedSegmentIndex:0];
    [rewardTypeControl setSegmentedControlStyle:UISegmentedControlStyleBar];
    [rewardTypeControl addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventValueChanged];
    [[self navigationItem] setTitleView:rewardTypeControl];
    
    // Create an instance of UIView (FooView).
    profileView = [[[NSBundle mainBundle] loadNibNamed:@"ProfileView" owner:self options:nil] objectAtIndex:0];
    
    self.errorImgView= [[UIImageView alloc] initWithFrame:CGRectMake(0, -80, 320, 568)];
    
    // Tell it where to go. Otherwise, it'll appear in the upper left corner.
    profileView.frame = CGRectMake(20, 0, 280, 180);
    self.profileView.blockView = self.blockView;
    self.profileView.sourceVC = self;
    [self.view addSubview:self.profileView];
    
    [activityLoad startAnimating];
    [self fetchEntries];
    // setup pull-to-refresh
    [self.rewardTableView addPullToRefreshWithActionHandler:^{
        
        [self fetchEntries];
        
        int64_t delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            
            NSLog(@"Pull down started");
            NSDate *methodStart = [NSDate date];
            
            NSTimeInterval howRecent = [methodStart timeIntervalSinceNow];
            NSLog(@"Pull down stoped with timing with %f",howRecent);
            //[self.rewardTableView endUpdates];
            
            /* ... Do whatever you need to do ... */
            
            //[rewardTableView.pullToRefreshView stopAnimating];
            
        });
    }];
    
    // trigger the refresh manually at the end of viewDidLoad
    //[rewardTableView triggerPullToRefresh];
}

- (void)didReceiveMemoryWarning
{
    [self setRewardTypeControl:nil];
    [self setRewardTableView:nil];
    [self setStoreRewardChannel:nil];
    [self setWalletRewardChannel:nil];
    [self setActivityLoad:nil];
    [self setDelegate:nil];
    [super didReceiveMemoryWarning];
    // Release any retained subviews of the main view.
}

- (void)changeType:(id)sender
{
    rewardType = [sender selectedSegmentIndex];
    [self.errorImgView removeFromSuperview];
    [self fetchEntries];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    //Here you must return the number of sections you want
    int returnValue = 0;
    if (rewardType == RewardListViewControllerRewardTypeStore) {
        NSMutableArray *sections = [[self storeRewardChannel] getVoucherListSectionCategory];
        returnValue = [sections count];
    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
        NSMutableArray *statuses = [[self walletRewardChannel] getVoucherListStatusCategory];
        returnValue = [statuses count];
    }
    return returnValue;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    //For each section, you must return here it's label
    NSString *returnValue = [[NSString alloc] init];
    if (rewardType == RewardListViewControllerRewardTypeStore) {
        NSMutableArray *sections = [[self storeRewardChannel] getVoucherListSectionCategory];
        returnValue = [sections objectAtIndex:section];
    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
        NSMutableArray *statuses = [[self walletRewardChannel] getVoucherListStatusCategory];
        returnValue = [statuses objectAtIndex:section];
    }
    return returnValue;
}
                     
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //Here, for each section, you must return the number of rows it will contain
    int count = 0;
    if (rewardType == RewardListViewControllerRewardTypeStore) {
        NSMutableArray *sections = [[self storeRewardChannel] getVoucherListSectionCategory];
        NSString *index = [sections objectAtIndex:section];
        NSMutableArray *voucherListDisplayed = [[self storeRewardChannel] getVoucherListWithSection:index];
        count = [voucherListDisplayed count];
    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
        NSMutableArray *statuses = [[self walletRewardChannel] getVoucherListStatusCategory];
        NSString *index = [statuses objectAtIndex:section];
        NSMutableArray *voucherListDisplayed = [[self walletRewardChannel] getPurchasedVoucherListWithSection:index];
        count = [voucherListDisplayed count];
    }
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *methodStart = [NSDate date];

    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = [rewardTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    VoucherChannel *voucher = [[VoucherChannel alloc] init];
    
    if (rewardType == RewardListViewControllerRewardTypeStore) {
        NSMutableArray *sections = [[self storeRewardChannel] getVoucherListSectionCategory];
        NSString *index = [sections objectAtIndex:[indexPath section]];
        NSMutableArray *voucherListDisplayed = [[self storeRewardChannel] getVoucherListWithSection:index];
        voucher = [voucherListDisplayed objectAtIndex:indexPath.row];
    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
        NSMutableArray *statuses = [[self walletRewardChannel] getVoucherListStatusCategory];
        NSString *index = [statuses objectAtIndex:[indexPath section]];
        NSMutableArray *list = [[self walletRewardChannel] getPurchasedVoucherListWithSection:index];
        voucher = [list objectAtIndex:[indexPath row]];
    }
    [[cell primaryLabel] setText:[voucher title]];
    
    NSMutableArray *locArray = [voucher vendorAnnotationList];
    VendorAnnotation *loc;
    double distance;
    if(locArray.count==1){
        loc = locArray[0];
        distance = [self.delegate getDistance:loc];
        
    }else{
        for(int i=0; i<locArray.count;i++){
            if(i==0){
                loc = locArray[0];
                distance = [self.delegate getDistance:loc];
            }else{
                double distance2 = [self.delegate getDistance:locArray[i]];
                if(distance>distance2){
                    distance = distance2;
                    loc = locArray[i];
                }
            }
        }
    }
    if(distance == -1.0){
        cell.mapIcon.hidden=YES;
        [[cell secondaryLabel] setText:[NSString stringWithFormat:@"%@ \n%@", [loc subtitle], [voucher type]]];
    }else{
        cell.mapIcon.hidden=NO;
        [[cell secondaryLabel] setText:[NSString stringWithFormat:@"%@ \n    %0.2fkm", [loc subtitle], distance]];
    }
    
    if (cell == nil) {
    //cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]autorelease];
    } else {
        AsyncImageView* oldImage = (AsyncImageView*)
        [cell.contentView viewWithTag:999];
        [oldImage removeFromSuperview];
    }

    CGRect frame;
    frame.size.width=50; frame.size.height=50;
    frame.origin.x=12; frame.origin.y=10;
    AsyncImageView* asyncImage = [[AsyncImageView alloc]
    initWithFrame:frame];
    asyncImage.tag = 999;
    //NSURL* url = [imageDownload thumbnailURLAtIndex:indexPath.row];
    [asyncImage loadImageFromURL:[voucher voucherImageFile]];

    [cell.contentView addSubview:asyncImage];
    
    
    
    NSTimeInterval howRecent = [methodStart timeIntervalSinceNow];
    NSLog(@"Cell was loaded with %fs",(howRecent*-1));
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [activityLoad startAnimating];
    if (rewardType == RewardListViewControllerRewardTypeStore) {
        NSMutableArray *sections = [[self storeRewardChannel] getVoucherListSectionCategory];
        NSString *index = [sections objectAtIndex:[indexPath section]];
        NSMutableArray *voucherListDisplayed = [[self storeRewardChannel] getVoucherListWithSection:index];
        VoucherChannel *selectedVoucher = [voucherListDisplayed objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"VoucherDetails" sender:selectedVoucher];
    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
        NSMutableArray *statuses = [[self walletRewardChannel] getVoucherListStatusCategory];
        NSString *index = [statuses objectAtIndex:[indexPath section]];
        NSMutableArray *list = [[self walletRewardChannel] getPurchasedVoucherListWithSection:index];
        VoucherChannel *selectedVoucher = [list objectAtIndex:[indexPath row]];
        [self performSegueWithIdentifier:@"RedemptionDetails" sender:selectedVoucher];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [activityLoad stopAnimating];
}


- (void)fetchEntries
{
    NSLog(@"Entries are fetching now!");
    [self.errorImgView removeFromSuperview];
    [self.blockView dimBlockView];
    //[activityLoad startAnimating];
    void (^completionBlock)(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err) =
    ^(RewardChannel *obj, NSHTTPURLResponse *res, NSError *err) {
        if(!err){
            if ([res statusCode] == 200) {
                if (![obj errorMsg]) {
                    if (rewardType == RewardListViewControllerRewardTypeStore) {
                        [self setStoreRewardChannel:obj];
                        if ([[[self storeRewardChannel] voucherList] count] == 0) {
                            UIImage *img = [UIImage imageNamed:@"novoucher.jpg"];
                            self.errorImgView.image = img;
                            [self.view addSubview:self.errorImgView];
                        }
                    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
                        [self setWalletRewardChannel:obj];
                        if ([[[self walletRewardChannel] voucherList] count] == 0) {
                            UIImage *img = [UIImage imageNamed:@"nousablevoucher.jpg"];
                            self.errorImgView.image = img;
                            [self.view addSubview:self.errorImgView];
                        }
                    }
                    [[self rewardTableView] reloadData];
                } else {
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av show];
                }
            } else {
                UIImage *img = [UIImage imageNamed:@"empty.jpg"];
                self.errorImgView.image = img;
                [self.view addSubview:self.errorImgView];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:[obj errorMsg] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av show];
            }
        } else if ([err code] == -1009) {
            UIImage *img = [UIImage imageNamed:@"noconnection.jpg"];
            self.errorImgView.image = img;
            [self.view addSubview:self.errorImgView];
        } else {
            UIImage *img = [UIImage imageNamed:@"generalerror.jpg"];
            self.errorImgView.image = img;
            [self.view addSubview:self.errorImgView];
        }
        [rewardTableView.pullToRefreshView stopAnimating];
        [activityLoad stopAnimating];
        [self.blockView clearBlockView];
    };
    
    if (rewardType == RewardListViewControllerRewardTypeStore) {
        [[SageByAPIStore sharedStore] fetchAvailableVouchersWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
    } else if (rewardType == RewardListViewControllerRewardTypeWallet) {
        [[SageByAPIStore sharedStore] fetchUserRedemptionsWithUserID:[self.delegate getNSDefaultUserID] withCompletion:completionBlock];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"VoucherDetails"])
    {
        // Get reference to the destination view controller
        VoucherDetailsViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        [vc setVoucherChannel:sender];
    } else if ([[segue identifier] isEqualToString:@"RedemptionDetails"]) {
        QRCodeViewController *vc = [segue destinationViewController];
        [vc setVoucherChannel:sender];
    }
}

- (void)viewDidUnload {
    [self setBlockView:nil];
    [super viewDidUnload];
}
- (IBAction)openUserProfilePopup:(id)sender {
    [self.profileView showHideProfileView];
}
@end
