//
//  QZEnvelopeController.m
//  QZ
//
//  Created by 宋扬 on 16/6/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZEnvelopeController.h"
#import "VPNSpinView.h"

@interface QZEnvelopeController ()

@property (nonatomic, weak) IBOutlet UITextView *notifyTextView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, weak) IBOutlet VPNSpinView *spinView;

@property (nonatomic, strong ) NSArray *rewards;

@end

@implementation QZEnvelopeController

- (IBAction)onPrint:(id)sender{
//    CGPoint scrollPoint = self.notifyTextView.contentOffset;
//    NSLog(@"scrollPoint = %@", NSStringFromCGPoint(scrollPoint));
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    _rewards = @[@0.5,
                 @0.1,
                 @0.2,
                 @0.05,
                 @0.4,
                 @0.02];
    
    [self addBackItem];
    [self loadData];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(75/1000.0)
                                             target:self
                                           selector:@selector(autoscrollTimerFired:)
                                           userInfo:nil
                                            repeats:YES];
   
}

- (void)loadData{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:8];
    for (int i = 0; i < 8; i++) {
        [arr addObject:[NSNumber numberWithInt:[KTMathUtil randomIntRange:100 and:1000]]];
    }
    [arr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 intValue] < [obj1 intValue];
    }];
    NSString *string = [NSString string];
    for (int i = 0; i < 8; i++) {
        NSNumber *num = [self.rewards objectAtIndex:(NSUInteger)[KTMathUtil randomIntRange:0 and:self.rewards.count]];
        NSString *append = [NSString stringWithFormat:@"18618327802抢到红包%3.2f元        %@秒之前\n", [num floatValue], arr[i]];
        string = [string stringByAppendingString:append];
    }
    self.notifyTextView.text = string;
}

- (void)autoscrollTimerFired:(NSTimer*)timer
{
    CGPoint scrollPoint = self.notifyTextView.contentOffset;
    scrollPoint = CGPointMake(scrollPoint.x, scrollPoint.y + 1);
//    NSLog(@"scrollPoint = %@", NSStringFromCGPoint(scrollPoint));
    
    if (scrollPoint.y >= 125) {
        scrollPoint.y = 0;
        [self loadData];
        [self.timer invalidate];
        self.timer = nil;
        
        
        [self performSelector:@selector(reset) withObject:nil afterDelay:0.1];
        
    }else
        [self.notifyTextView setContentOffset:scrollPoint animated:NO];
}

- (void)reset{
    [self.notifyTextView setContentOffset:CGPointZero animated:NO];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:(75.0/1000.0)
                                                  target:self
                                                selector:@selector(autoscrollTimerFired:)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavTitle:@"抢红包"];
    
}

@end
