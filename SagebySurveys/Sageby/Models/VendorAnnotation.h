//
//  VendorAnnotation.h
//  Sageby
//
//  Created by Jun Hao Peh on 27/10/12.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>
#import "JSONSerializable.h"
#import "VoucherChannel.h"

@interface VendorAnnotation : NSObject <MKAnnotation, JSONSerializable>
{
    UIImage *image;
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) int locationID;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@property (nonatomic, weak) VoucherChannel *voucherChannel;

@property (nonatomic, strong) NSString *errorMsg;


@end
