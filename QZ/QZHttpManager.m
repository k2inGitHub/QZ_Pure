//
//  QZHttpManager.m
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZHttpManager.h"

static NSString * const QZBaseURLString = @"http://203.195.187.176/";

@implementation QZHttpManager

+ (instancetype)sharedManager{
    static QZHttpManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[QZHttpManager alloc] initWithBaseURL:[NSURL URLWithString:QZBaseURLString]];
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return _sharedClient;
}

@end
