//
//  BackgroundView.h
//  Sageby
//
//  Created by LuoJia on 27/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BackgroundViewMedium,
    BackgroundViewLarge
} BackgroundViewSizeType;

@interface ErrorPageView : UIImageView

@property (nonatomic, assign) BackgroundViewSizeType sizeType;
@property (nonatomic, assign) CGSize targetSize;

- (UIImage*)imageByScalingAndCroppingWithImage:(UIImage *)img;
- (void)initializeTargetSize;

@end
