//
//  QZTopBar.m
//  QZ
//
//  Created by 宋扬 on 16/6/14.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZTopBar.h"
#import "QZManager.h"

@implementation QZTopBar

- (void)awakeFromNib{
    [self updateLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:QZCurrencyDidChangeNotification object:nil];
}

- (void)updateLabel{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%0.2f元", [QZManager sharedManager].currency]];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, str.length - 2)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(str.length - 1, 1)];
    self.currencyLabel.attributedText = str;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QZCurrencyDidChangeNotification object:nil];
}

@end
