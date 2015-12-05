//
//  TRSortViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRSortViewController.h"
#import "TRMetaDataTool.h"
#import "TRSort.h"

@implementation TRSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取所有排序的数据
    NSArray *sortsArray = [TRMetaDataTool sorts];
    //设定创建按钮的常量
    CGFloat buttonHeight = 30;
    CGFloat buttonWidth = 100;
    CGFloat buttonMargin = 15;//左右上下边距
    //循环创建按钮
    for (int i = 0; i < sortsArray.count; i++) {
        //创建按钮
        UIButton *button = [UIButton new];
        //设置button的tag(获取按钮对应的那个排序对象)
        button.tag = i;
        //设置按钮属性
        button.frame = CGRectMake(buttonMargin, i * (buttonMargin + buttonHeight) + buttonMargin, buttonWidth, buttonHeight);
        //设置按钮的两个背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        //修改按钮的文本的颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //设置按钮的文本
        TRSort *sort = sortsArray[i];
        [button setTitle:sort.label forState:UIControlStateNormal];
        //设置button的action
        [button addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
        //添加到view
        [self.view addSubview:button];
    }
    //设置内容试图控制的内容大小
    self.preferredContentSize = CGSizeMake(buttonWidth + 2*buttonMargin, sortsArray.count*(buttonMargin + buttonHeight) + buttonMargin);
}

- (void)clickSortButton:(UIButton *)button {
    //获取点中那个按钮对应的排序模型对象
    NSArray *sortArray = [TRMetaDataTool sorts];
    TRSort *sort = sortArray[button.tag];
    //发送通知给主视图控制器(参数:sort)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRSortDidChange" object:self userInfo:@{@"TRSelectedSort":sort}];
}








@end
