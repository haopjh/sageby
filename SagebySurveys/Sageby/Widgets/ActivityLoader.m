//
//  Con_Pop.m
//  sageby
//
//  Created by Gao chenyang on 12-6-11.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ActivityLoader.h"

@implementation ActivityLoader
@synthesize activityLoad;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //custom
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[activityLoad startAnimating];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setActivityLoad:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
