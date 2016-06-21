//
//  QZManager.m
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZManager.h"
#import "UIALertView+Blocks.h"
#import "NSUserDefaults+KTAdditon.h"
#import "HLService.h"


@interface QZManager ()

@property (nonatomic, strong) QZMissionModel* currentMission;

@end

@implementation QZManager

- (void)showAd{
    int num = [[NSUserDefaults standardUserDefaults] integerForKey:@"qz_local_num" defaultValue:0];
    num++;
    int show_ad_num = [HLAnalyst intValue:@"qz_showad_num" defaultValue:0];
    if (show_ad_num != 0 && num >= show_ad_num) {
        
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
        num = 0;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"qz_local_num"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setEnvelopeNum:(int)envelopeNum{
    if (_envelopeNum != envelopeNum) {
        _envelopeNum = envelopeNum;
        
        [[NSUserDefaults standardUserDefaults] setFloat:_envelopeNum forKey:@"QZ_envelopeNum"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:QZEnvelopNumDidChangeNotification object:nil];
    }
}

- (BOOL)costEnvelopeNum:(int)num{
    if (num > _envelopeNum) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"你已经没有抽奖机会了，快去获得吧" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
            
        }];
        return NO;
    }
    self.envelopeNum -= num;
    return YES;
}

- (void)addEnvelopeNum:(int)add{
    self.envelopeNum += add;
}

- (void)addCurrency:(float)add {
    self.currency += add;
}

- (void)setCurrency:(float)currency
{
    if (_currency != currency) {
        _currency = currency;
        [[NSUserDefaults standardUserDefaults] setFloat:_currency forKey:@"VPN_Currency"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:QZCurrencyDidChangeNotification object:nil];
    }
}

- (BOOL)costCurrency:(float)cost {
    
    if (cost > _currency) {
        
//        if (_currency < 50) {
//            [KTUIFactory showAlertViewWithTitle:nil message:@"您已经没有金币了，观看完整视频广告可获得500金币！" delegate:self tag:0 cancelButtonTitle:@"拒绝" otherButtonTitles:@"免费金币", nil];
//        } else
        {
            
            [UIAlertView showWithTitle:nil message:@"金币不足,去赚钱！" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
//                [self performSelector:@selector(setSelectIdx) withObject:nil afterDelay:0];
            }];
        }
        
        return NO;
    }
    self.currency -= cost;
    return YES;
}

- (void)resignActive{
    
}

- (void)becomeActive{

    if ([self isCurrentMissionFinish]) {
        [UIAlertView showWithTitle:nil message:[NSString stringWithFormat:@"恭喜你完成任务%@,获得%0.1f元和一次抽红包机会!", self.currentMission.title,self.currentMission.money] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
           
            [self addCurrency:self.currentMission.money];
            [self addEnvelopeNum:1];
            [self finishMission];
            [[NSNotificationCenter defaultCenter] postNotificationName:QZMissionFinish object:nil];
        }];
    }
}

- (BOOL)isCurrentMissionFinish{
    if (self.currentMission == nil || self.currentMission.startDate == nil) {
        return false;
    }
    int interval = [[NSDate date] timeIntervalSinceDate:self.currentMission.startDate];
    
    if (interval > (self.currentMission.valid_time1 * 60) && interval < (self.currentMission.valid_time2 * 60)) {
        return true;
    }
    return false;
}

- (BOOL)hasMission{
    return self.currentMission != nil;
}

- (void)startMission:(QZMissionModel *)missionData{

    self.currentMission = missionData;
    self.currentMission.startDate = [NSDate date];
}

- (void)stopMission{
    self.currentMission = nil;
}

- (void)finishMission{
    self.currentMission.isFinish = YES;
    [self stopMission];
}

- (instancetype)init{
    self = [super init];
    
    if (self == nil) {
        return  nil;
    }
    
    _currency = [[NSUserDefaults standardUserDefaults] floatForKey:@"VPN_Currency" defaultValue:0];
    
    _envelopeNum = [[NSUserDefaults standardUserDefaults] floatForKey:@"QZ_envelopeNum" defaultValue:0];
    
    self.firstDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"QZ_first_date"];
    if (self.firstDate == nil) {
        self.firstDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:self.firstDate forKey:@"QZ_first_date"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    return self;
}

+ (instancetype)sharedManager{

    static QZManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[QZManager alloc] init];
    });
    
    return _sharedClient;
}



@end
