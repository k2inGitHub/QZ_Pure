//
//  VPNSpinView.h
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPNSpinView : UIView

@property (nonatomic, strong) NSArray *rewards;

- (IBAction)startSelectNumber;

- (void)start;
- (void)stop;

@end
