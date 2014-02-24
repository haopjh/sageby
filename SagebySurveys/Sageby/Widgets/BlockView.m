//
//  BlockView.m
//  Sageby
//
//  Created by LuoJia on 29/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BlockView.h"

@implementation BlockView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setHidden:YES];
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

- (void) dimBlockView
{
    [self setHidden:NO];
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 0.0f;
    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.0];
    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    [UIView setAnimationRepeatAutoreverses:YES];
    self.alpha = 0.5f;
    [UIView commitAnimations];
}

- (void) clearBlockView
{
    self.backgroundColor = [UIColor grayColor];
    self.alpha = 0.5f;
    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    //    [UIView setAnimationRepeatAutoreverses:YES];
    self.alpha = 0.0f;
    [UIView commitAnimations];
}

@end
