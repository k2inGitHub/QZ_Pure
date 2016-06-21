//
//  QZHomeModel.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZHomeModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *descriptionText;

@property (nonatomic, assign) int remainNum;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, assign) float money;

@property (nonatomic, assign) BOOL isFinish;

@end
