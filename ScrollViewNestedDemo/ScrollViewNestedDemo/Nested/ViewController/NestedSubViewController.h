//
//  NestedSubViewController.h
//  ScrollViewNestedDemo
//
//  Created by midland on 2019/3/7.
//  Copyright © 2019年 midland. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NestedSubViewController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, copy) NSString *type;

@end

NS_ASSUME_NONNULL_END
