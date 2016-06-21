//
//  UINavigationController+QZ.m
//  QZ
//
//  Created by 宋扬 on 16/6/20.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "UINavigationController+QZ.h"
#import "UIColor+QZ.h"

@implementation UINavigationController (QZ)

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [UIColor qzRed];
    
    NSDictionary * dict = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes = dict;
}

@end
