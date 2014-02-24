
//
//  Voucher.m
//  Sageby
//
//  Created by LuoJia on 13/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VoucherChannel.h"
#import "VendorAnnotation.h"

@implementation VoucherChannel
@synthesize voucherID;
@synthesize title;
@synthesize type;
@synthesize voucherImageFile;
@synthesize voucherCostList;
@synthesize description;
@synthesize category;
@synthesize qrCodePathString;
@synthesize qrCodePathURL;
@synthesize securityCode;
@synthesize reference;
@synthesize isUsed;
@synthesize errorMsg;
@synthesize resultMsg;
@synthesize vendorAnnotationList;

- (id)init
{
    self = [super init];
    if(self){
        //Create the container for the surveyQuestions this channel has;
        voucherCostList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        [self setVoucherID:[[d objectForKey:@"voucher_sku_id"] intValue]];
        [self setTitle:[d objectForKey:@"voucher_name"]];
        [self setDescription:[d objectForKey:@"voucher_description"]];
        [self setType:[d objectForKey:@"voucher_type"]];
        [self setCategory:[d objectForKey:@"voucher_category"]];
        
        NSArray *voucherCosts = [d objectForKey:@"voucher_cost"];
        for(NSString *voucherCost in voucherCosts){
            [[self voucherCostList] addObject:[NSNumber numberWithDouble:[voucherCost doubleValue]]];
        }
        
        NSString *voucherImageFileString = [d objectForKey:@"voucher_image_url"];
        [self setVoucherImageFile:[NSURL URLWithString:voucherImageFileString]];
        
        if ([d objectForKey:@"QR_code_path_url"]) {
            NSString *qrCodePathURLString = [d objectForKey:@"QR_code_path_url"];
            [self setQrCodePathURL:[NSURL URLWithString:qrCodePathURLString]];
        }
        
        if ([d objectForKey:@"QR_code_path_string"]) {
            [self setQrCodePathString:[d objectForKey:@"QR_code_path_string"]];
        }
        
        if ([d objectForKey:@"security_code"]) {
            [self setSecurityCode:[d objectForKey:@"security_code"]];
        }
        
        if ([d objectForKey:@"reference"]) {
            [self setReference:[d objectForKey:@"reference"]];
        }
        
        if ([d objectForKey:@"voucher_status"]) {
            NSString *voucherStatus = [d objectForKey:@"voucher_status"];
            if ([voucherStatus isEqualToString:@"Unused"]) {
                self.isUsed = NO;
            } else {
                self.isUsed = YES;
            }
        }
        
        if ([d objectForKey:@"result"]) {
            [self setResultMsg:[d objectForKey:@"result"]];
        }
        
        if ([d objectForKey:@"locations"]) {
            vendorAnnotationList = [[NSMutableArray alloc] init];
            NSArray *locations = [d objectForKey:@"locations"];
            for(NSDictionary *location in locations){
                VendorAnnotation *v = [[VendorAnnotation alloc] init];
                [v readFromJSONDictionary:location];
                v.title = self.title;
                [self.vendorAnnotationList addObject:v];
            }
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

@end
