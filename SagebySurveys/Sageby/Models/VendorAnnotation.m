//
//  VendorAnnotation.m
//  Sageby
//
//  Created by Jun Hao Peh on 27/10/12.
//
//

#import "VendorAnnotation.h"

@implementation VendorAnnotation
@synthesize image,latitude,longitude,title,subtitle,voucherChannel,locationID, errorMsg;


- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [latitude doubleValue];
    theCoordinate.longitude = [longitude doubleValue];
    return theCoordinate;
}

- (void)readFromJSONDictionary:(NSDictionary *)d
{
    @try {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        [self setLocationID:[[d objectForKey:@"location_id"] intValue]];
        
        [self setSubtitle:[d objectForKey:@"location_name"]];
        
        [self setLatitude:[f numberFromString:[d objectForKey:@"latitude"]]];
        [self setLongitude:[f numberFromString:[d objectForKey:@"longtitude"]]];
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
