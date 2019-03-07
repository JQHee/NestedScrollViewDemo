//
//  NestedBaseTableView.m
//  ScrollViewNestedDemo
//
//  Created by midland on 2019/3/7.
//  Copyright © 2019年 midland. All rights reserved.
//

#import "NestedBaseTableView.h"

@interface NestedBaseTableView() <UIGestureRecognizerDelegate>

@end

@implementation NestedBaseTableView

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
