//
//  TRRegionViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRRegionViewController.h"
#import "TRMetaDataTool.h"
#import "TRRegion.h"
#import "TRTableViewCell.h"
#import "TRCityGroupViewController.h"

@interface TRRegionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

//存储用户选中那个城市的所有区域(子区域)
@property (nonatomic, strong) NSArray *regionsArray;
@end

@implementation TRRegionViewController
//- (NSArray *)regionsArray {
//    if (!_regionsArray) {
//#warning TODO: 城市选择
//        _regionsArray = [TRMetaDataTool regionsByCityName:@"北京"];
//    }
//    return _regionsArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //监听TRCityDidChange名字的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:@"TRCityDidChange" object:nil];
}
- (void)cityDidChange:(NSNotification *)notification {
    //获取通知对象包含的城市名字
    NSString *cityName = notification.userInfo[@"TRSelectedCityName"];
    //显示这个城市的所有区域的数据(赋值区域的数组)
    self.regionsArray = [TRMetaDataTool regionsByCityName:cityName];
    //刷新tableView
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
}

- (IBAction)clickChangeCity:(id)sender {
    //创建城市组视图控制器对象
    TRCityGroupViewController *cityGroupViewController = [TRCityGroupViewController new];
    //设置弹出控制器的显示模式(表单形式展示)
    cityGroupViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    //present出来
    [self presentViewController:cityGroupViewController animated:YES completion:nil];
}

#pragma mark --- UITableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        //左边(某个城市的区域个数)
        return self.regionsArray.count;
    } else {
        //右边(用户点中的那个区域对应的子区域的个数)
        //获取用户左边选中的那行行号
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionsArray[selectedRow];
        return region.subregions.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //左边cell的重用机制+cell两种背景图片(封装)
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withHighlightedImageName:@"bg_dropdown_left_selected"];
        //左边cell text
        TRRegion *region = self.regionsArray[indexPath.row];
        cell.textLabel.text = region.name;
        //cell右箭头(取决于当前的区域是否有子区域)
        if (region.subregions.count > 0) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
        } else {
            cell.accessoryView = nil;
        }
        
        return cell;
        
    } else {
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withHighlightedImageName:@"bg_dropdown_right_selected"];
        //右边cell text(取决于左边选择哪行)
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionsArray[selectedRow];
        cell.textLabel.text = region.subregions[indexPath.row];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //点中左边的表刷新右边的视图
    if (tableView == self.mainTableView) {
        [self.subTableView reloadData];
        //情况一：没有子区域；发送通知给主视图控制器(参数:主区域)
        TRRegion *region = self.regionsArray[indexPath.row];
        if (region.subregions.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRSelectedRegion":region}];
        }
    } else {
        //情况二：有子区域，发送通知给主视图控制器(参数:主区域+子区域)
        NSInteger selectedLeftRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger selectedRightRow = [self.subTableView indexPathForSelectedRow].row;
        //主区域
        TRRegion *region = self.regionsArray[selectedLeftRow];
        //子区域
        NSString *subRegionName = region.subregions[selectedRightRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionDidChange" object:self userInfo:@{@"TRSelectedRegion":region, @"TRSelectedSubRegion":subRegionName}];
    }
}







@end
