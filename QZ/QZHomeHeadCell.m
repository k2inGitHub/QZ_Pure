//
//  QZHomeHeadCell.m
//  QZ
//
//  Created by 宋扬 on 16/6/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZHomeHeadCell.h"
#import "HLService.h"

@implementation QZHomeHeadCell

- (IBAction)onShowAd:(id)sender{

    [[HLAdManager sharedInstance] showButtonInterstitial:@"首页"];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
