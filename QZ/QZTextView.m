//
//  QZTextView.m
//  QZ
//
//  Created by 宋扬 on 16/6/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZTextView.h"

static CGFloat const KMargin = 1;
static CGFloat const KLineW = 2.0;
static CGFloat const KRadius = 6.0;

@interface QZTextView ()

@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation QZTextView



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, KLineW);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGFloat lengths[] = {6,2};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, KMargin + KRadius, KLineW * 0.5);
    CGContextAddLineToPoint(context, self.frame.size.width - KLineW * 0.5 - KRadius, KLineW * 0.5);
    CGContextAddArc(context, self.frame.size.width - KLineW * 0.5 - KRadius, KLineW * 0.5 + KRadius, KRadius, -0.5 * M_PI, 0.0, 0);
    
    CGContextAddLineToPoint(context, self.frame.size.width - KLineW * 0.5, self.frame.size.height - KLineW * 0.5 - KRadius);
    CGContextAddArc(context, self.frame.size.width - KLineW * 0.5 - KRadius, self.frame.size.height - KLineW * 0.5 - KRadius, KRadius, 0.0, 0.5 * M_PI, 0);
    
    CGContextAddLineToPoint(context, KMargin + KRadius, self.frame.size.height - KLineW * 0.5);
    CGContextAddArc(context, KMargin + KRadius, self.frame.size.height - KLineW * 0.5 - KRadius, KRadius, 0.5 * M_PI, M_PI, 0);
    
    CGContextAddLineToPoint(context, KMargin, self.frame.size.height * 0.5 + KMargin * 0.5);
    CGContextAddLineToPoint(context, 0, self.frame.size.height * 0.5);
    CGContextAddLineToPoint(context, KMargin, self.frame.size.height * 0.5 - KMargin * 0.5);
    CGContextAddLineToPoint(context, KMargin, KLineW * 0.5 + KRadius);
    CGContextAddArc(context, KMargin + KRadius, KLineW * 0.5 + KRadius, KRadius, M_PI, -0.5 * M_PI, 0);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    
}


@end
