//
//  QZMissionController.m
//  QZ
//
//  Created by 宋扬 on 16/6/15.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZMissionController.h"
#import "QZMissionModel.h"
#import "QZHomeCell.h"
#import "QZMissionCell.h"


@interface QZMissionController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QZMissionModel *data;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, assign) float height;

@property (nonatomic, weak) IBOutlet UIButton *startBtn;

@end

@implementation QZMissionController

- (IBAction)onStartMission:(id)sender{

    [UIAlertView showWithTitle:@"温馨提示" message:@"任务开始后，请在60分钟内完成任务" cancelButtonTitle:nil otherButtonTitles:@[@"取消",@"继续任务"] tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/genre/mobile-software-applications/id36?mt=8"]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit"]];
            [[QZManager sharedManager] startMission:self.data];
            [self updateBtn];
        }
    }];
}

- (void)updateBtn{
    
    if (self.data.isFinish) {
        [self.startBtn setTitle:@"任务已完成" forState:UIControlStateNormal];
        self.startBtn.enabled = NO;
    } else {
        BOOL flag = !([[QZManager sharedManager] currentMission].id == self.data.id);
        self.startBtn.enabled = flag;
        if (flag) {
            [self.startBtn setTitle:@"开始任务" forState:UIControlStateNormal];
        } else {
            [self.startBtn setTitle:@"任务进行中" forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addBackItem];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBtn) name:QZMissionFinish object:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setNavTitle:self.data.title];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:QZMissionFinish object:nil];
}

- (void)requestData{

    NSURLSessionDataTask *task = [[QZHttpManager sharedManager] POST:@"make_fast/api/task_one.php" parameters:@{@"content":[NSString JSONStringFromObject:@{@"id":self.id}]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        id str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSLog(@"str = %@", str);
        NSDictionary *dic = responseObject;
        if ([dic[@"status"]intValue] == 1) {
//            self.dataArray = [QZHomeModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            self.data = [QZMissionModel mj_objectWithKeyValues:dic];
//            NSLog(@"self.data = %@", self.data);
            [self.tableView reloadData];
            [self updateBtn];
            [self setNavTitle:self.data.title];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@", error);
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 80;
    }
    CGFloat size = self.height - 40;
    return 300 + MIN(0, size);
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        id cell = [tableView dequeueReusableCellWithIdentifier:homeCellIdentifier];
        return cell;
    } else {
        return [tableView dequeueReusableCellWithIdentifier:missionCellIdentifier];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        NSParameterAssert([cell isKindOfClass:[QZHomeCell class]]);
        QZHomeCell *homeCell = (QZHomeCell *)cell;
        homeCell.titleLabel.text = self.data.title;
        homeCell.detailLabel.text = [NSString stringWithFormat:@"剩余份数:%d", self.data.remainNum];
        homeCell.descriptionLabel.text = self.data.descriptionText;
        [homeCell.iconView setImageWithURL:[NSURL URLWithString:self.data.iconUrl] placeholderImage:nil];
        
        homeCell.moneyLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithFloat:self.data.money]];
    } else {
    
        QZMissionCell *missionCell = (QZMissionCell *)cell;
        missionCell.keyTextView.text = self.data.keyword;
//        missionCell.constrainWidth.constant = 150;
        
        missionCell.detailTextView.text = self.data.detail;
        
        
        CGFloat size = ceilf([missionCell.detailTextView sizeThatFits:CGSizeMake(missionCell.detailTextView.frame.size.width, FLT_MAX)].height);
        missionCell.constrainHeight.constant = size;
        self.height = size;
        
        [missionCell layoutIfNeeded];
        [missionCell setNeedsDisplay];
    }
}

@end
