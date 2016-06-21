//
//  QZPopupEnvelope.m
//  QZ
//
//  Created by 宋扬 on 16/6/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZPopupEnvelope.h"
#import "AppDelegate.h"
#import "QZManager.h"
#import "QZBaseController.h"

@interface QZPopupEnvelope ()

@property (nonatomic, weak) IBOutlet UILabel *numLabel;



@property (nonatomic, strong) NSNumber *num;

@end

@implementation QZPopupEnvelope

+(BOOL)loginFinished{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"QZ_envelope_finished" defaultValue:NO];
}

+(void)setLoginFinished:(BOOL)value{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"QZ_envelope_finished"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (instancetype)showWithNum:(NSNumber *)num
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    QZPopupEnvelope *view = [[[NSBundle mainBundle] loadNibNamed:@"QZPopupEnvelope" owner:nil options:nil] lastObject];
    view.num = num;
    view.descriptionLabel.text = @"恭喜您获得红包(点击领取)";
    UIView *showView = app.window.rootViewController.view;
    view.frame = CGRectMake(0.0, 0.0, showView.frame.size.width, showView.frame.size.height);
    [view refresh];
    [showView addSubview:view];
    
    return view;
}

- (void)refresh{
    self.numLabel.text = [NSString stringWithFormat:@"%@元", self.num];
}

- (IBAction)onClick:(id)sender{
    
    [[QZManager sharedManager] addCurrency:[self.num floatValue]];
    if (self.onDismiss != nil) {
        self.onDismiss(self);
    }
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
