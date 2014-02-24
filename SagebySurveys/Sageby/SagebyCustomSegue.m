//
//  SagebyCustomSegue.m
//  Sageby
//
//  Created by LuoJia on 10/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SagebyCustomSegue.h"
#import "LoginViewController.h"

@implementation SagebyCustomSegue

//this method is used for custom segue. Custom segue is useful as viewController can determine when to show which UIView with the integration of storyboard
- (void)perform
{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    //present modal UITabViewController when user has logged in
    if ([[self identifier] isEqualToString:@"login"] || [[self identifier] isEqualToString:@"signup"] || [[self identifier] isEqualToString:@"signupSuccessful"] || [[self identifier] isEqualToString:@"testing"]) {
        //NSLog(@"here");
        //NSLog(@"dst: %@",dst);
//        src.view.transform = CGAffineTransformMakeTranslation(0, 0);
//        dst.view.transform = CGAffineTransformMakeTranslation(0, -480);
        
        [src presentViewController:dst animated:NO completion:Nil];
        
//        [UIView animateWithDuration:0.0
//                         animations:^{
//                             [src presentModalViewController:dst animated:NO];                         }
//         ];
        //NSLog(@"Done!");

//        [UIView animateWithDuration:2.0
//                         animations:^{
//                             [src presentModalViewController:dst animated:NO];
//                             src.view.transform = CGAffineTransformMakeTranslation(0, 480);
//                             dst.view.transform = CGAffineTransformMakeTranslation(0, 0);
//                         }
//         ];
    }
}
@end
