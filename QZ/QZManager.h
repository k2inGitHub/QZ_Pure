//
//  QZManager.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QZMissionModel.h"

static NSString *const QZMissionFinish = @"missionFinish";
//VPNCurrencyDidChangeNotification
static NSString *const QZCurrencyDidChangeNotification = @"currencyDidChangeNotification";

static NSString *const QZEnvelopNumDidChangeNotification = @"envelopNumDidChangeNotification";

@interface QZManager : NSObject

@property (nonatomic, strong, readonly) QZMissionModel* currentMission;

@property (nonatomic, assign) float currency;

@property (nonatomic, assign) int envelopeNum;

@property (nonatomic, strong) NSDate *firstDate;

+ (instancetype)sharedManager;

- (void)startMission:(QZMissionModel *)missionData;

- (void)stopMission;

- (BOOL)hasMission;

- (BOOL)isCurrentMissionFinish;

- (void)resignActive;

- (void)becomeActive;

- (void)addCurrency:(float)add;

- (BOOL)costCurrency:(float)cost;

- (BOOL)costEnvelopeNum:(int)num;

- (void)addEnvelopeNum:(int)add;

- (void)showAd;

@end
