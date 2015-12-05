//
//  UIBarButtonItem+TRBarButtonItem.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TRBarButtonItem)

//给定四个参数(image/hlimage/target/action),返回一个已经创建好的UIBarButtonItem
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName withHighlightedImage:(NSString *)hlImageName withTarget:(id)target withAction:(SEL)action;







@end
