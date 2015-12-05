//
//  TRSearchViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRSearchViewController.h"
#import "UIBarButtonItem+TRBarButtonItem.h"

@interface TRSearchViewController ()<UISearchBarDelegate>

@end

@implementation TRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回item
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_back" withHighlightedImage:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
    //search bar
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.placeholder = @"请输入搜索关键词";
    searchBar.delegate = self;
    //添加searchBar到navigationBar上
    self.navigationItem.titleView = searchBar;
}
- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark --- UISearchBarDelegate
//给定输入文本，点中键盘上的search按钮的时候触发该方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"开始搜索");
    //发送请求(keyword + cityName)
    //调用父类的获取团购订单的方法
    [self loadNewDeals];
    //收回键盘
    [searchBar resignFirstResponder];
}

#pragma mark --- 实现父类的设置请求参数的方法
- (void)settingRequestParams:(NSMutableDictionary *)params {
    //city名字(必选参数)
    params[@"city"] = self.cityName;
    //keyword
    UISearchBar *searchBar = (UISearchBar *)self.navigationItem.titleView;
    params[@"keyword"] = searchBar.text;
}





@end
