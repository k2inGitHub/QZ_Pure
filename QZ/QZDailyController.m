 //
//  QZDailyController.m
//  QZ
//
//  Created by 宋扬 on 16/6/14.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZDailyController.h"
#import <JTCalendar/JTCalendar.h>
#import "KTUIFactory.h"
#import "QZPopupEnvelope.h"

@interface QZDailyController ()<JTCalendarDelegate>
{
    NSMutableDictionary *_eventsByDate;
    
    NSMutableArray *_datesSelected;
}

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) NSDate *date;

@end

@implementation QZDailyController
//
//- (IBAction)onGetEnvelope:(id)sender{
//    
//}

- (IBAction)onLeft:(id)sender{
    [_calendarContentView loadPreviousPageWithAnimation];
}

- (IBAction)onRight:(id)sender{
    [_calendarContentView loadNextPageWithAnimation];
}

- (IBAction)onClick:(id)sender{
    
    NSDate *date = _date;
    
    if([self isInDatesSelected:date]){
        [_datesSelected removeObject:date];
        [_calendarManager reload];
    }
    else{
        [_datesSelected addObject:date];
        
        [_calendarManager reload];
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:date]){
        if([_calendarContentView.date compare:date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
    
    [NSKeyedArchiver archiveRootObject:_datesSelected toFile:[self dailyFilePath]];
    [self refreshSubmitBtn];
    
    NSDate *finalDate = [_calendarManager.dateHelper addToDate:[QZManager sharedManager].firstDate days:7];
    int num = 1;
    if ([self.date compare:finalDate] == NSOrderedAscending) {
        //7day
        num = 2;
    }
    [UIAlertView showWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"签到成功,获得%d次抽红包机会!",num] cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        [[QZManager sharedManager] addEnvelopeNum:num];
    }];
}

- (NSString *)dailyFilePath{
    return [LibCachePath stringByAppendingPathComponent:@"daily_events"];
}

- (void)refreshSubmitBtn{

    if([self isInDatesSelected:self.date]){
        [self.submitBtn setTitle:@"已签到" forState:UIControlStateNormal];
        self.submitBtn.enabled = NO;
    } else {
        [self.submitBtn setTitle:@"签到" forState:UIControlStateNormal];
        self.submitBtn.enabled = YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    _calendarMenuView.contentRatio = .75;
    _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatSingle;
    _calendarManager.dateHelper.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    
    
//    NSDateFormatter *dateFormatter = [_calendarManager.dateHelper createDateFormatter];
//    dateFormatter.dateFormat = @"yyyy'-'MM'-'dd' 'HH':'mm':'ss";
    _datesSelected = [[NSMutableArray alloc] initWithArray:[NSKeyedUnarchiver unarchiveObjectWithFile:[self dailyFilePath]]];
    
    self.date = [NSDate date];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_calendarManager reload];
    [self setNavTitle:@"签到"];
    [self refreshSubmitBtn];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self refreshSubmitBtn];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [[QZManager sharedManager] showAd];
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
//    // Today
//    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
//        dayView.circleView.hidden = NO;
//        dayView.circleView.backgroundColor = [UIColor blueColor];
//        dayView.dotView.backgroundColor = [UIColor whiteColor];
//        dayView.textLabel.textColor = [UIColor whiteColor];
//    }
//    // Selected date
//    else
    if([self isInDatesSelected:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor qzRed];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    dayView.dotView.hidden = YES;
//    if([self haveEventForDay:dayView.date]){
//        dayView.dotView.hidden = NO;
//    }
//    else{
//        dayView.dotView.hidden = YES;
//    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    if([self isInDatesSelected:dayView.date]){
        [_datesSelected removeObject:dayView.date];
        
        [UIView transitionWithView:dayView
                          duration:.3
                           options:0
                        animations:^{
                            [_calendarManager reload];
                            dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                        } completion:nil];
    }
    else{
        [_datesSelected addObject:dayView.date];
        
        dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
        [UIView transitionWithView:dayView
                          duration:.3
                           options:0
                        animations:^{
                            [_calendarManager reload];
                            dayView.circleView.transform = CGAffineTransformIdentity;
                        } completion:nil];
    }
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Date selection

- (BOOL)isInDatesSelected:(NSDate *)date
{
    for(NSDate *dateSelected in _datesSelected){
        if([_calendarManager.dateHelper date:dateSelected isTheSameDayThan:date]){
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy MMMM";
        
        dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
}

- (UIView<JTCalendarDay> *)calendarBuildDayView:(JTCalendarManager *)calendar
{
    JTCalendarDayView *view = [JTCalendarDayView new];
    
    view.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:13];
    
    view.circleRatio = .8;
    view.dotRatio = 1. / .9;
    
    return view;
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

@end
