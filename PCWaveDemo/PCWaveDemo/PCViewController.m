//
//  PCViewController.m
//  PCWaveDemo
//
//  Created by ypc on 17/3/20.
//  Copyright © 2017年 com.ypc. All rights reserved.
//

#import "PCViewController.h"
#import "PCWave.h"
@interface PCViewController ()<UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) PCWave *headerView;
@property (nonatomic ,strong) UIImageView *iconImageView;
@end

@implementation PCViewController
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}
- (PCWave *)headerView
{
    if (!_headerView){
    
        _headerView = [[PCWave alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
        _headerView.backgroundColor = XNColor(248, 64, 87, 1);
        [_headerView addSubview:self.iconImageView];
        __weak typeof(self) weakSelf = self;
        _headerView.waveBlock = ^(CGFloat currentY){
            __weak typeof(weakSelf) strongSelf = weakSelf;
            CGRect iconFrame = strongSelf.iconImageView.frame;
            
            iconFrame.origin.y = CGRectGetHeight(weakSelf.headerView.frame)-CGRectGetHeight(weakSelf.iconImageView.frame)+currentY-weakSelf.headerView.waveHeight;
            
//            iconFrame.origin.y = strongSelf.headerView.frame.size.height - strongSelf.iconImageView.frame.size.height + currentY - strongSelf.headerView.waveHeight;
            strongSelf.iconImageView.frame = iconFrame;
        };
        [_headerView startWaveAnimation];
        
    }
    return _headerView;
}
- (UIImageView *)iconImageView
{
    if (!_iconImageView){
    
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width/2-30, 0, 60, 60)];
        _iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _iconImageView.layer.borderWidth = 2;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}
#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];

}

#pragma mark - UITableViewDataSources
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"我是一个cell %zd",indexPath.row];
    return cell;
}
@end
