//
//  UIBarButtonItem+TRBarButtonItem.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "UIBarButtonItem+TRBarButtonItem.h"

@implementation UIBarButtonItem (TRBarButtonItem)
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName withHighlightedImage:(NSString *)hlImageName withTarget:(id)target withAction:(SEL)action {
    UIButton *button = [UIButton new];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:hlImageName] forState:UIControlStateHighlighted];
    button.frame = CGRectMake(0, 0, 80, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}





@end
