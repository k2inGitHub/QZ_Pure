//
//  QZMissionCell.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const missionCellIdentifier = @"QZMissionCell";


@interface QZMissionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *keyTextView;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
@property (assign, nonatomic) float fontSize;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainWidth;

@end
