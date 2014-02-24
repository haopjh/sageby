//
//  ProgressView.m
//  Sageby
//
//  Created by Mervyn on 30/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressView.h"

@implementation ProgressView

- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(100,100,100,20);
        self.trackTintColor = [UIColor clearColor];
        self.progressTintColor = [UIColor greenColor];
        self.progress = 0.0f;
    }
    return self;
}

- (void) setProgressView:(float) progress;
{
//    Set the progress number here.
//    self.trackTintColor = [UIColor clearColor];
//    self.progressTintColor = [UIColor greenColor];
    self.progress = progress;
}

@end