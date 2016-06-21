//
//  QZZfbController.m
//  QZ
//
//  Created by 宋扬 on 16/6/17.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZZfbController.h"

@interface QZZfbController ()

@property (nonatomic, weak) IBOutlet UITextField *tf1;

@property (nonatomic, weak) IBOutlet UITextField *tf2;

@property (nonatomic, weak) IBOutlet UILabel *currencyLabel;

@property (nonatomic, strong) NSArray *btns;

@end

@implementation QZZfbController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btns = @[[self.view viewWithTag:16], [self.view viewWithTag:17], [self.view viewWithTag:18]];
    [self onBtnClick:(UIButton *)self.btns[0]];
    
    [self updateLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:QZCurrencyDidChangeNotification object:nil];
}

- (void)updateLabel{
    self.currencyLabel.text = [NSString stringWithFormat:@"余额:%0.2f元", [QZManager sharedManager].currency];
}

- (IBAction)onBtnClick:(UIButton *)sender{
    
    for (UIButton *btn in self.btns) {
        btn.selected = NO;
    }
    sender.selected = YES;
}

- (IBAction)tapGesture:(id)sender {
    [self.tf1 resignFirstResponder];
    [self.tf2 resignFirstResponder];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QZCurrencyDidChangeNotification object:nil];
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
