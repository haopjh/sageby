//
//  QRCodeViewController.h
//  Sageby
//
//  Created by LuoJia on 14/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VoucherChannel;

@interface QRCodeViewController : UIViewController

@property (nonatomic, strong) VoucherChannel *voucherChannel;

@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImage;
@property (weak, nonatomic) IBOutlet UILabel *decription;

@end
