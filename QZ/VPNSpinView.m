//
//  VPNSpinView.m
//  VPN-iOS
//
//  Created by 宋扬 on 16/2/24.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "VPNSpinView.h"
#import "KTMathUtil.h"
#import "Canvas.h"
#import "QZManager.h"
#import "UIAlertView+Blocks.h"
#import "UIColor+QZ.h"
#import "QZPopupEnvelope.h"
#import "HLService.h"

@interface VPNSpinView ()

@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (nonatomic, weak) UIButton *lastClickBtn;
@property (nonatomic, strong) NSArray *btns;
@property (nonatomic, strong) CADisplayLink *display;
@property (weak, nonatomic) IBOutlet UIView *centerView;
// 按钮初始化时的角度
@property (nonatomic, assign) CGFloat angle;

@property (nonatomic, strong) NSArray* choices;



//@property (nonatomic, strong) NSArray* multiples;

@property (nonatomic, weak) IBOutlet UIView *rewardView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, assign) NSUInteger spinCost;

@property (nonatomic, assign) int itemNum;

@property (nonatomic, weak) UILabel *envelopeLabel;

@end

@implementation VPNSpinView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QZEnvelopNumDidChangeNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return  nil;
    }
    self.itemNum = 10;
    
    _choices = @[@0,
                 @0.05,
                 @0.05,
                 @0,
                 @0.1,
                 @0.0,
                 @0.3,
                 @0.1,
                 @0,
                 @0.4];
    _rewards = @[@20,
                 @0.5,
                 @0.1,
                 @1,
                 @0.2,
                 @10,
                 @0.05,
                 @0.4,
                 @5,
                 @0.02];
//    _multiples = @[@0,@5,@2,@3,@0,@4,@2,@3];
    
    _spinCost = 0;//[[QZManager sharedManager].currencyDic[@"spinCost"] integerValue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabel) name:QZEnvelopNumDidChangeNotification object:nil];
    
    return self;
}

- (void)updateLabel{
    self.envelopeLabel.text = [NSString stringWithFormat:@"你还有%d次机会", [QZManager sharedManager].envelopeNum];
}

- (void)awakeFromNib
{
    [self addBtns];
    self.angle = 0;
//    [self hideRewardView];
//    [self start];
    
//    _descriptionLabel.text = [NSString stringWithFormat:@"抢红包说明:\n
//                              1.每做一次任务获取一次机会
//                              2.红包是随机的，额度大小全凭人品
//                              3.签到也可获得抢红包机会"];
    
    self.envelopeLabel = [_rewardView viewWithTag:22];
    [self updateLabel];
}

//+ (instancetype)wheelView
//{
//    return [[[NSBundle mainBundle] loadNibNamed:@"LuckyWheel" owner:nil options:nil] lastObject];
//}



- (void)addBtns
{
//    UIImage *bgImg = [UIImage imageNamed:@"LuckyAstrology"];
//    UIImage *selImg = [UIImage imageNamed:@"LuckyAstrologyPressed"];
//    NSArray *images = @[@"0",@"5",@"2",@"3",@"0",@"4",@"2",@"3"];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:self.itemNum];
    int count = self.itemNum;
    for (int i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        CGFloat btnX = 0;
        CGFloat btnY = 0;
        CGFloat btnW = 65;
        CGFloat btnH = 180;
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btn.layer.anchorPoint = CGPointMake(0.5, 1);
        btn.layer.position = self.centerView.center;
        CGFloat angle = i * (M_PI * 2 / count) ;
        btn.transform = CGAffineTransformMakeRotation(angle);
        [self.centerView addSubview:btn];
        
        // 计算裁剪的尺寸
//        CGFloat scale = [UIScreen mainScreen].scale;
//        CGFloat imgY = 0;
//        CGFloat imgW = (bgImg.size.width / 12) * scale;
//        CGFloat imgX = i * imgW;
//        CGFloat imgH = bgImg.size.height * scale;
//        CGRect imgRect = CGRectMake(imgX, imgY, imgW, imgH);
//        
//        // 裁剪图片
//        CGImageRef cgImg = CGImageCreateWithImageInRect(bgImg.CGImage, imgRect);
//        [btn setImage:[UIImage imageWithCGImage:cgImg] forState:UIControlStateNormal];
//        
//        CGImageRef selCgImg = CGImageCreateWithImageInRect(selImg.CGImage, imgRect);
//        [btn setImage:[UIImage imageWithCGImage:selCgImg] forState:UIControlStateSelected];
        
        btn.userInteractionEnabled = NO;
        [btn setTitle:[NSString stringWithFormat:@"%@", self.rewards[i] ] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor qzRed] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:[_multiples[i] stringValue]] forState:UIControlStateNormal];
//        btn.contentEdgeInsets = UIEdgeInsetsMake(20, 15, 20, 17);
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        
        btn.tag = i;
        if (i == 0) {
            [self btnClick:btn];
        }
        [arr addObject:btn];
    }
    _btns = arr;
}

- (void)btnClick:(UIButton *)sender
{
    self.lastClickBtn.selected = NO;
    sender.selected = YES;
    // 每次点击一个按钮，都减去一个按钮的角度值
    self.angle -= sender.tag * M_PI / 4;
    self.lastClickBtn = sender;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    [self bringSubviewToFront:self.centerBtn];
}

- (void)addDisplayLink
{
    [self.display invalidate];
    self.display = nil;
    self.userInteractionEnabled = YES;
    // 添加定时刷新
    if (self.display == nil) {
//        CADisplayLink *display = [CADisplayLink displayLinkWithTarget:self selector:@selector(changeTransform)];
//        self.display = display;
//        [display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)changeTransform
{
    self.centerView.transform = CGAffineTransformRotate(self.centerView.transform, M_PI / 900);
    self.angle += M_PI / 900;
    // 转一圈以后，将角度重新置为0
    if (self.angle >= M_PI * 2) {
        self.angle = 0;
    }
}

- (void)start
{
    [self addDisplayLink];
}

- (void)stop
{
    [self.display invalidate];
    self.display = nil;
}


- (IBAction)startSelectNumber {
    
    if (![[QZManager sharedManager] costEnvelopeNum:1]) {
        return;
    }
//    [HLAnalyst event:@"玩幸运转盘次数"];
    int idx = [KTMathUtil randomChoice:_choices];
    
    self.angle -= idx * M_PI * 2 / self.itemNum;
    self.lastClickBtn = _btns[idx];
    
    
    [self stop];
    
    // 禁止交互
    self.userInteractionEnabled = NO;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    // 计算核心动画旋转的角度
    animation.toValue = @(M_PI * 2 * 4 - self.lastClickBtn.tag * M_PI * 2 / self.itemNum);
    animation.duration = 2;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    
    [self.centerView.layer addAnimation:animation forKey:@"animation"];
    
//    
//    CGRect frame = self.centerView.frame;
//    frame.origin = CGPointZero;
//    self.centerView.frame = frame;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    // 将view旋转到顶部
    
    self.centerView.transform = CGAffineTransformMakeRotation( -( self.lastClickBtn.tag * M_PI * 2 / self.itemNum));
    self.angle = -self.lastClickBtn.tag * M_PI * 2 / self.itemNum;
    // 移除核心动画
    [self.centerView.layer removeAnimationForKey:@"animation"];
    // 1秒后添加转动
    [self performSelector:@selector(addDisplayLink) withObject:nil afterDelay:1];
//    int multiple = [_multiples[_lastClickBtn.tag] intValue];
    NSNumber *toAdd = self.rewards[_lastClickBtn.tag];
    
    QZPopupEnvelope *popup = [QZPopupEnvelope showWithNum:toAdd];
    popup.onDismiss = ^(QZPopupEnvelope *popup){
        if ([HLAnalyst boolValue:@"qz_show_spin" defaultValue:NO]) {
            if([[HLAdManager sharedInstance] isEncourageInterstitialLoaded]){
                [[HLAdManager sharedInstance] showEncourageInterstitial];
            }
            else {
                [[HLAdManager sharedInstance] showUnsafeInterstitial];
            }
        }
    };
//    UILabel *lbl = [_rewardView viewWithTag:22];
//    NSString *text = [NSString stringWithFormat:@"获得%0.1f元", toAdd];
    
//    lbl.text = text;
//    _rewardView.hidden = NO;
//    [_rewardView startCanvasAnimation];
//    [self performSelector:@selector(hideRewardView) withObject:nil afterDelay:2];
//    if (multiple != 0) {
//        [UIAlertView showWithTitle:nil message:[NSString stringWithFormat:@"恭喜你，获得%@金币", toAdd] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
    
//            if ([[HLAdManager sharedInstance] isEncourageInterstitialLoaded]) {
//                [[HLAdManager sharedInstance] showEncourageInterstitial];
//            } else {
//                [[HLAdManager sharedInstance] showUnsafeInterstitial];
//            }
//        }];
//    } else {
//        [QZManager showAd1];
//    }
}

- (void)hideRewardView{
    _rewardView.hidden = YES;
}

@end
