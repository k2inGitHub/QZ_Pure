//
//  QZHomeCell.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const homeCellIdentifier = @"QZHomeCell";


@interface QZHomeCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *iconView;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet UIButton *infoBtn;

@property (nonatomic, weak) IBOutlet UILabel *moneyLabel;

@end
