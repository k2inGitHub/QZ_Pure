//
//  QZMissionModel.m
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZMissionModel.h"
#import "MJExtension.h"

@implementation QZMissionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"descriptionText":@"summary",
             @"remainNum":@"remain_num",
             @"iconUrl":@"icon"};
}

+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[@"startDate", @"isFinish"];
}

- (void)setIsFinish:(BOOL)isFinish{
    _isFinish = isFinish;

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_finish",self.id]];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (instancetype)init{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _isFinish = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_finish",self.id]];
    
    return self;
}

@end
