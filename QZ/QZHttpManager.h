//
//  QZHttpManager.h
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface QZHttpManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
