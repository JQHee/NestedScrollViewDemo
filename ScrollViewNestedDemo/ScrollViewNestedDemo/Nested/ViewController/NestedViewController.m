//
//  NestedViewController.m
//  ScrollViewNestedDemo
//
//  Created by midland on 2019/3/7.
//  Copyright © 2019年 midland. All rights reserved.
//

#import "NestedViewController.h"
#import "UIImage+Core.h"
#import "NestedBaseTableView.h"
#import "NestedSubViewController.h"
#import <SDCycleScrollView.h>
#import <TYPagerController.h>
#import <TYTabPagerBar.h>
#import "NestedNormalSubViewController.h"

#define BANNER_HEIGHT  300.0f
#define VIEW_COLOR [UIColor colorWithRed:255.0/255 green:78.0/255 blue:144.0/255 alpha:1]

@interface NestedViewController () <TYTabPagerBarDataSource,
TYTabPagerBarDelegate,
TYPagerControllerDataSource,
TYPagerControllerDelegate,
UITableViewDataSource,
UITableViewDelegate>
{
    BOOL _IsCanScroll;
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NestedBaseTableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;
@property (nonatomic, strong) NSMutableArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *VCsArray;

@end

@implementation NestedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
    [self viewBindEvent];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private methods
- (void) initData {
    _IsCanScroll = YES;
    self.titlesArray = @[].mutableCopy;
    self.VCsArray = @[].mutableCopy;
    
    NSArray *titles = @[@"全部",@"服饰穿搭",@"生活百货",@"美食吃货",@"美容护理",@"母婴儿童",@"数码家电",@"NormalVC"];
    self.titlesArray = [titles mutableCopy];
    
    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:@"NormalVC"]) {
            NestedNormalSubViewController *normalNestedVC = [NestedNormalSubViewController new];
            [self addChildViewController:normalNestedVC];
            [self.VCsArray addObject:normalNestedVC];
        } else {
            NestedSubViewController *VC = [NestedSubViewController new];
            VC.type = obj;
            [self addChildViewController:VC];
            [self.VCsArray addObject:VC];
        }
        
    }];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor cyanColor];
    [self setupNavBar];
    
    self.navigationItem.titleView = self.titleLabel;
    
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.tableView];
    
    // 添加轮播图
    CGRect rect = CGRectMake(0, -BANNER_HEIGHT, UIScreen.mainScreen.bounds.size.width, BANNER_HEIGHT);
    NSArray *imagesURL = @[@"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=963385302,2175031822&fm=26&gp=0.jpg"];
    self.bannerView = [SDCycleScrollView cycleScrollViewWithFrame:rect imageURLStringsGroup:imagesURL];
    [self.tableView addSubview:self.bannerView];
    
}

- (void)setupNavBar {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:VIEW_COLOR] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewBindEvent {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabNotiAction) name:@"tabNoti" object:nil];
}

- (void)subTabViewCanScroll:(BOOL)canScroll{
    for (UIViewController *subVC in self.VCsArray) {
        if ([subVC isKindOfClass:[NestedSubViewController class]]) {
            NestedSubViewController *tempSubVC = (NestedSubViewController *)subVC;
            tempSubVC.canScroll = canScroll;
            if (!canScroll) {
                tempSubVC.tableView.contentOffset = CGPointZero;
            }
        }

    }
}

- (void) reload {
    // 必须reload
    [self.tabBar reloadData];
    [self.pagerController reloadData];
}

#pragma mark - Event response
- (void) tabNotiAction {
    _IsCanScroll = YES;
    [self subTabViewCanScroll:NO];
}

#pragma mark - TYTabPagerBarDataSource

- (NSInteger)numberOfItemsInPagerTabBar {
    return self.titlesArray.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.titlesArray[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate

- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = self.titlesArray[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    if (index == self.titlesArray.count - 1) {
        _IsCanScroll = YES;
    }
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController {
    return self.VCsArray.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    return self.VCsArray[index];
}

#pragma mark - TYPagerControllerDelegate

- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    if (toIndex == self.titlesArray.count - 1) {
        _IsCanScroll = YES;
    }
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.001f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UIScreen.mainScreen.bounds.size.height;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cid"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cid"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:self.contentView];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat naviH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    if (scrollView.contentOffset.y >- naviH) {
        scrollView.contentOffset = CGPointMake(0, -naviH);
        if (_IsCanScroll) {
            // 让普通的VC也可以正常滚动
            if (self.pagerController.curIndex == self.titlesArray.count - 1) {
                _IsCanScroll = YES;
            } else {
                _IsCanScroll = NO;
                [self subTabViewCanScroll:YES];
            }
        }
    }else{
        if (!_IsCanScroll) {
            scrollView.contentOffset = CGPointMake(0, -naviH);
        }
    }
    //    导航栏设置
    CGFloat alpha = (scrollView.contentOffset.y+BANNER_HEIGHT)/(BANNER_HEIGHT-naviH);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[VIEW_COLOR colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
    self.titleLabel.alpha = alpha;
}

#pragma mark - Setter & Getter
- (NestedBaseTableView *)tableView{
    
    if (!_tableView) {
        CGSize screen = [UIScreen mainScreen].bounds.size;
        NestedBaseTableView *tableView = [[NestedBaseTableView alloc]initWithFrame:CGRectMake(0, 0, screen.width, screen.height) style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.estimatedRowHeight = 0;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.contentInset = UIEdgeInsetsMake(BANNER_HEIGHT, 0, 0, 0);
        tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cid"];
        _tableView = tableView;
    }
    return _tableView;
}

- (UIView *)contentView {
    if (!_contentView) {
        CGRect frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
        UIView *contentView = [[UIView alloc]initWithFrame: frame];
        [contentView addSubview:self.tabBar];
        [contentView addSubview:self.pagerController.view];
        self.tabBar.frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 45);
        self.pagerController.view.frame = CGRectMake(0, 45, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 45);
        [self reload];
        _contentView = contentView;
        // 将内容传入_contentView中
    }
    return _contentView;
}

- (TYTabPagerBar *) tabBar {
    if (! _tabBar) {
        TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
        tabBar.layout.barStyle = TYPagerBarStyleNoneView;
        tabBar.dataSource = self;
        tabBar.delegate = self;
        [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
        _tabBar = tabBar;
    }
    return _tabBar;
}

- (TYPagerController *) pagerController {
    if (!_pagerController) {
        TYPagerController *pagerController = [[TYPagerController alloc]init];
        pagerController.layout.prefetchItemCount = 1;
        //pagerController.layout.autoMemoryCache = NO;
        // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
        pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
        pagerController.dataSource = self;
        pagerController.delegate = self;
        [self addChildViewController:pagerController];
        _pagerController = pagerController;
    }
    return _pagerController;
}

- (UILabel *) titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text = @"首页";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.alpha = 0;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


@end
