//
//  TRCategroyViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRCategroyViewController.h"
#import "TRMetaDataTool.h"
#import "TRCategory.h"
#import "TRTableViewCell.h"

@interface TRCategroyViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (nonatomic, strong) NSArray *categoryArray;
@end

@implementation TRCategroyViewController
- (NSArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = [TRMetaDataTool categories];
    }
    return _categoryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        //左边
        return self.categoryArray.count;
    } else {
        //右边
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoryArray[selectedRow];
        return category.subcategories.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //左边的cell
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withHighlightedImageName:@"bg_dropdown_left_selected"];
        //V2:设置cell(重写category的set方法)
        cell.category = self.categoryArray[indexPath.row];
        return cell;
        
    } else {
        //右边的cell
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withHighlightedImageName:@"bg_dropdown_right_selected"];
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoryArray[selectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //刷新右边的表
        [self.subTableView reloadData];
        //情况一：没有子分类；立即发送通知给主试图控制器(参数:主分类)
        TRCategory *category = self.categoryArray[indexPath.row];
        if (category.subcategories.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryDidChange" object:self userInfo:@{@"TRSelectedCategory" : category}];
        }
        
    } else {
        //情况二：发送通知给主试图控制器(参数:主分类+子分类)
        //获取用户选择的主分类/子分类(行号)
        NSInteger selectedLeftRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger selectesRightRow = [self.subTableView indexPathForSelectedRow].row;
        //主分类
        TRCategory *category = self.categoryArray[selectedLeftRow];
        //子分类
        NSString *subCategoryName = category.subcategories[selectesRightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryDidChange" object:self userInfo:@{@"TRSelectedCategory":category, @"TRSelectedSubCategory":subCategoryName}];
    }
}







@end
