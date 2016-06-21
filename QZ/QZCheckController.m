//
//  QZCheckController.m
//  QZ
//
//  Created by 宋扬 on 16/6/14.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZCheckController.h"

@implementation QZCheckController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setNavTitle:@"兑换"];
}

- (void)setNavTitle:(NSString *)string{
    
    if (self.tabBarController != nil) {
        self.tabBarController.navigationItem.title = string;
    } else {
        self.navigationItem.title = string;
    }
}

//- (NSArray *)titles {
//    return @[@"支付宝", @"微信"];
//}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{

//    NSLog(@"willEnterViewController = %@", viewController);
    
    
    [[QZManager sharedManager] showAd];
}

#pragma mark - WMPageController DataSource
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:self.titles[index]];
    return vc;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.menuItemWidth = 50;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 16;
        self.titleSizeNormal = 16;
        self.showOnNavigationBar = NO;
        self.menuBGColor = [UIColor clearColor];
        self.titleColorSelected = [UIColor qzRed];
        
        self.progressColor = [UIColor qzRed];//[UIColor colorWithRed:250.f/255.f green:179.f/255.f blue:0/255.f alpha:1];
//        self.itemsWidths = @[@46,@46,@58];
        //        self.menuHeight = 40.0;
        //        self.menuViewStyle = WMMenuViewStyleLine;
        //        self.menuItemWidth = 60;
        //        self.selectIndex = 2;
        
        self.titles = @[@"支付宝", @"微信"];
    }
    return self;
}

@end
