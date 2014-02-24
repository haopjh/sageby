//
//  StoreChannel.m
//  Sageby
//
//  Created by LuoJia on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RewardChannel.h"
#import "VoucherChannel.h"

@implementation RewardChannel
@synthesize voucherList, errorMsg;

- (id)init
{
    self = [super init];
    if(self){
        voucherList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        NSArray *vouchers = [d objectForKey:@"redeems"];
        for(NSDictionary *voucher in vouchers){
            VoucherChannel *v = [[VoucherChannel alloc] init];
            [v readFromJSONDictionary:voucher];
            [voucherList addObject:v];
        }
    }
    @catch (NSException *e) {
        [self setErrorMsg:@"Please update Sageby Surveys to latest version"];
    }
    @finally {
        if ([d objectForKey:@"error"]) {
            [self setErrorMsg:[d objectForKey:@"error"]];
        }
    }
}

- (NSMutableArray *)getVoucherListSectionCategory
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i=0; i<[[self voucherList] count]; i++) {
        VoucherChannel *v = [voucherList objectAtIndex:i];
        unichar firstChar = [[v title] characterAtIndex:0];
        NSString *firstCharString = [[NSString stringWithFormat:@"%C", firstChar] uppercaseString];
        if (![list containsObject:firstCharString]) {
            [list addObject:firstCharString];
        }
    }
    [list sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return list;
}

- (NSMutableArray *)getVoucherListStatusCategory
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i=0; i<[[self voucherList] count]; i++) {
        VoucherChannel *v = [voucherList objectAtIndex:i];
        NSString *voucherStatus = nil;
        if ([v isUsed]) {
            voucherStatus = @"Used";
        } else {
            voucherStatus = @"Available";
        }
        
        if (![list containsObject:voucherStatus]) {
            [list addObject:voucherStatus];
        }
        
        if ([list count] == 2) {
            break;
        }
    }
    [list sortUsingSelector:@selector(caseInsensitiveCompare:)];
    return list;
}

- (NSMutableArray *)getVoucherListWithSection:(NSString *)section
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i=0; i<[[self voucherList] count]; i++) {
        VoucherChannel *v = [voucherList objectAtIndex:i];
        unichar firstChar = [[v title] characterAtIndex:0];
        NSString *firstCharString = [[NSString stringWithFormat:@"%C", firstChar] uppercaseString];
        if ([section isEqualToString:firstCharString]) {
            [list addObject:v];
        }
    }

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                 ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    NSMutableArray *sortedArray;
    sortedArray = (NSMutableArray *)[list sortedArrayUsingDescriptors:sortDescriptors];
    return list;
}

- (NSMutableArray *)getPurchasedVoucherListWithSection:(NSString *)section
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (int i=0; i<[[self voucherList] count]; i++) {
        VoucherChannel *v = [voucherList objectAtIndex:i];
        if ([section isEqualToString:@"Available"]) {
            if (![v isUsed]) {
                [list addObject:v];
            }
        } else if ([section isEqualToString:@"Used"]) {
            if ([v isUsed]) {
                [list addObject:v];
            }
        }
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                 ascending:YES];
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];
    NSMutableArray *sortedArray;
    sortedArray = (NSMutableArray *)[list sortedArrayUsingDescriptors:sortDescriptors];
    return list;
}

@end
