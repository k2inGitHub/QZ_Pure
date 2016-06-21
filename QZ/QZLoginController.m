//
//  QZLoginController.m
//  QZ
//
//  Created by 宋扬 on 16/6/17.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZLoginController.h"

@interface QZLoginController ()

@property (nonatomic, weak) IBOutlet UITextField *tf1;

@property (nonatomic, weak) IBOutlet UITextField *tf2;

@end

@implementation QZLoginController

+(BOOL)finished{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"QZ_finished" defaultValue:NO];
}

+(void)setFinished:(BOOL)value{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"QZ_finished"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)onLogin:(id)sender{

    [QZLoginController setFinished:YES];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)tapGesture:(id)sender {
    [self.tf1 resignFirstResponder];
    [self.tf2 resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
