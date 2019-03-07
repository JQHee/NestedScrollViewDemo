//
//  UIImage+Core.h
//  ScrollViewNestedDemo
//
//  Created by midland on 2019/3/7.
//  Copyright © 2019年 midland. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Core)


/**
 根据颜色生成图片

 @param color 颜色
 @return t图片生成的图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
