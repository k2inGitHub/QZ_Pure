//
//  QZTabBarController.m
//  QZ
//
//  Created by 宋扬 on 16/6/20.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZTabBarController.h"
#import "HLService.h"
#import "QZManager.h"

@implementation QZTabBarController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{

    
    UIViewController *vc = tabBarController.selectedViewController;
    if (vc != viewController) {
//        NSLog(@"did select vc = %@" , viewController);
        
        [[QZManager sharedManager] showAd];
        
    }
    return YES;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.delegate = self;
    
}

@end
