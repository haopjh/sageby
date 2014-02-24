//
//  CustomCell.h
//  Sageby
//
//  Created by Mervyn on 24/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell 
@property(nonatomic,retain) IBOutlet UILabel *primaryLabel;
@property(nonatomic,retain) IBOutlet UILabel *secondaryLabel;
@property(nonatomic,retain) IBOutlet UIImageView *myImageView;
@property(nonatomic,retain) IBOutlet UILabel *responseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mapIcon;
@end
