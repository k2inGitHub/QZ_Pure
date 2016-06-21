//
//  QZHomeController.m
//  QZ
//
//  Created by 宋扬 on 16/6/14.
//  Copyright © 2016年 handloft. All rights reserved.
//

#import "QZHomeController.h"
#import "QZTopBar.h"
#import "QZHomeCell.h"
#import "QZHomeModel.h"
#import "QZMissionController.h"
#import "QZHomeHeadCell.h"
#import "QZLoginController.h"
#import "QZPopupEnvelope.h"

@interface QZHomeController ()<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic) CGRect barRect;

@property (nonatomic, strong) QZTopBar *topBar;

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation QZHomeController

- (void)requestData{

    NSURLSessionDataTask *task = [[QZHttpManager sharedManager] POST:@"make_fast/api/task_list.php" parameters:@{@"content":[NSString JSONStringFromObject:@{@"page":@"1", @"pagesize":@"20"}]} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSLog(@"str = %@", str);
        NSDictionary *dic = responseObject;
        if ([dic[@"status"]intValue] == 1) {
            self.dataArray = [QZHomeModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            [_tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
        [self.refreshControl endRefreshing];
    }];
    
//    NSLog(@"url = %@", task.originalRequest.URL);
//    NSLog(@"body = %@", [[NSString alloc] initWithData:task.originalRequest.HTTPBody encoding:NSUTF8StringEncoding]);
}

- (void)refreshHeader{
    [self requestData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self requestData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉即可刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshHeader) forControlEvents:UIControlEventValueChanged];
    [self.tableView setBackgroundView:self.refreshControl];
    
    if (![QZLoginController finished]) {
        QZLoginController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"注册"];
        [self.tabBarController presentViewController:controller animated:NO completion:^{
            
        }];
    }
    
    if (![QZPopupEnvelope loginFinished]) {
        
        NSNumber *num = [NSNumber numberWithInt:2];
        QZPopupEnvelope *popup = [QZPopupEnvelope showWithNum:num];
        popup.descriptionLabel.text = @"点击领取新用户红包";
        popup.onDismiss = ^(QZPopupEnvelope *popup){
            [QZPopupEnvelope setLoginFinished:YES];
            [UIAlertView showWithTitle:@"温馨提示" message:@"恭喜您成功领取2元红包" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView * _Nonnull alertView, NSInteger buttonIndex) {
                
            }];
        };
    }
    if ([HLAnalyst boolValue:@"qz_show_splash"]) {
        [[HLAdManager sharedInstance] showUnsafeInterstitial];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self addTopBar];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setFrame:self.barRect];
    [self.topBar removeFromSuperview];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addTopBar];
    [self setNavTitle:nil];
    
    [_tableView reloadData];
    
}

- (void)addTopBar{
    if (self.topBar == nil) {
        self.barRect = self.navigationController.navigationBar.frame;
        [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,80.0)];
        
        self.topBar = [[[NSBundle mainBundle] loadNibNamed:@"QZTopBar" owner:nil options:nil] lastObject];
        
    }
    self.topBar.frame = CGRectMake(0, 0, self.view.frame.size.width,80.0);
    if (self.topBar.superview == nil) {
        [self.navigationController.navigationBar addSubview:self.topBar];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    QZHomeModel *data = _dataArray[[_tableView indexPathForSelectedRow].row];
    if (data.isFinish) {
        return NO;
        
    }
    if ([QZManager sharedManager].currentMission != nil && data.id != [QZManager sharedManager].currentMission.id) {
        [UIAlertView showWithTitle:@"温馨提示" message:@"有其他任务还没有完成" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    QZMissionController *loadController = (QZMissionController *)[segue destinationViewController];
    if (loadController) {
        QZHomeModel *data = _dataArray[[_tableView indexPathForSelectedRow].row];
        loadController.id = data.id;
    }
    [[QZManager sharedManager] showAd];
}

#pragma mark -TableView-

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return [tableView dequeueReusableCellWithIdentifier:homeHeadCellIdentifier];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 120;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 1)
        return @"限时任务";
    else
        return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1)
        return 80;
    else
        return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return [_dataArray count];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        id cell = [tableView dequeueReusableCellWithIdentifier:homeCellIdentifier];
        return cell;
    }
    return [tableView dequeueReusableCellWithIdentifier:homeHeadCellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSParameterAssert([cell isKindOfClass:[QZHomeCell class]]);
        QZHomeCell *homeCell = (QZHomeCell *)cell;
        QZHomeModel *homeModel = _dataArray[indexPath.row];
        homeCell.titleLabel.text = homeModel.title;
        homeCell.detailLabel.text = [NSString stringWithFormat:@"剩余份数:%d", homeModel.remainNum];
        homeCell.descriptionLabel.text = homeModel.descriptionText;
        [homeCell.iconView setImageWithURL:[NSURL URLWithString:homeModel.iconUrl] placeholderImage:nil];
        
        if (homeModel.isFinish) {
            [homeCell.infoBtn setBackgroundImage:[UIImage imageNamed:@"btn-7"] forState:UIControlStateNormal];
            [homeCell.infoBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [homeCell.infoBtn setTitle:@"已完成" forState:UIControlStateNormal];
        } else if ([QZManager sharedManager].currentMission && [QZManager sharedManager].currentMission.id == homeModel.id) {
            [homeCell.infoBtn setBackgroundImage:[UIImage imageNamed:@"btn-5"] forState:UIControlStateNormal];
            [homeCell.infoBtn setTitleColor:[UIColor qzBlue] forState:UIControlStateNormal];
            [homeCell.infoBtn setTitle:@"进行中..." forState:UIControlStateNormal];
        } else {
            [homeCell.infoBtn setBackgroundImage:[UIImage imageNamed:@"btn-4"] forState:UIControlStateNormal];
            [homeCell.infoBtn setTitleColor:[UIColor qzRed] forState:UIControlStateNormal];
            [homeCell.infoBtn setTitle:[NSString stringWithFormat:@"%@元", [NSNumber numberWithFloat:homeModel.money]] forState:UIControlStateNormal];
        }
        
    }
}

@end
