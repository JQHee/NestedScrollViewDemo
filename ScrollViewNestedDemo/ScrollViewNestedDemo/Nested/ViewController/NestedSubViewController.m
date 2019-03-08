//
//  NestedSubViewController.m
//  ScrollViewNestedDemo
//
//  Created by midland on 2019/3/7.
//  Copyright © 2019年 midland. All rights reserved.
//

#import "NestedSubViewController.h"
#import <MJRefresh.h>

@interface NestedSubViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation NestedSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        // [strongSelf.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.tableView.mj_footer endRefreshing];
    }];
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        CGFloat naviH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
        CGSize screen = [UIScreen mainScreen].bounds.size;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height - 40 - naviH) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 22;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cid"];
    }
    cell.textLabel.text = self.type;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *VC = [[UIViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!self.canScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    // 不需要刷新，设置为0即可
    if (scrollView.contentOffset.y <= -100) {
        self.canScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabNoti" object:nil];
    } else {
        [self.tableView.mj_header setHidden:NO];
    }
}

@end
