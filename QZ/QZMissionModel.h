//
//  QZMissionModel.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZMissionModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *descriptionText;

@property (nonatomic, assign) int remainNum;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, assign) float money;

@property (nonatomic, copy) NSString *keyword;

@property (nonatomic, copy) NSString *detail;

@property (nonatomic, assign) int limit_time;

@property (nonatomic, assign) int valid_time1;

@property (nonatomic, assign) int valid_time2;

@property (nonatomic, strong) NSDate *startDate;

@property (nonatomic, assign) BOOL isFinish;

@end
