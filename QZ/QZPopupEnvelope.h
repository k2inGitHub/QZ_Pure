//
//  QZPopupEnvelope.h
//  QZ
//
//  Created by 宋扬 on 16/6/16.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface QZPopupEnvelope : UIView

typedef void (^QZPopupEnvelopeBlock) (QZPopupEnvelope * __nonnull alertView);

@property (nonatomic, copy, nullable) QZPopupEnvelopeBlock onDismiss;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

+ (instancetype)showWithNum:(NSNumber *)num;

+(BOOL)loginFinished;

+(void)setLoginFinished:(BOOL)value;

@end
