//
//  QZBaseController.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZHttpManager.h"
#import "MJExtension.h"
#import "NSString+KT.h"
#import "UIImageView+AFNetworking.h"
#import "Masonry.h"
#import "QZManager.h"
#import "UIALertView+Blocks.h"
#import "KTUIFactory.h"
#import "UIColor+QZ.h"
#import "KTMathUtil.h"
#import "NSUserDefaults+KTAdditon.h"
#import "HLService.h"

@interface QZBaseController : UIViewController

- (void)addBackItem;

- (void)setNavTitle:(NSString *)string;

@end
