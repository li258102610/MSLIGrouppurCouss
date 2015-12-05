//
//  TRCityGroupViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase
#import "TRCityGroupViewController.h"
#import "TRMetaDataTool.h"
#import "TRCityGroup.h"

@interface TRCityGroupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *cityGroupTableView;
@property (nonatomic, strong) NSArray *cityGroupsArray;
@end

@implementation TRCityGroupViewController
- (NSArray *)cityGroupsArray {
    if (!_cityGroupsArray) {
        _cityGroupsArray = [TRMetaDataTool cityGroups];
    }
    return _cityGroupsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityGroupTableView.delegate = self;
    self.cityGroupTableView.dataSource = self;
}

- (IBAction)closeCityList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- UITableViewDataSource/Delegate
//self.cityGroupsArray <---> Section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroupsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //获取这个section对应的城市组模型对象
    TRCityGroup *cityGroup = self.cityGroupsArray[section];
    return cityGroup.cities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell(城市的名字)
    TRCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}
//设置section的头部title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupsArray[section];
    return cityGroup.title;
}

//设置tableView右边的index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //方式一：循环把self.cityGroupsArray中每个对象的title属性组成一个数组返回
    //方式二：使用valueForKeypath方法
    return [self.cityGroupsArray valueForKeyPath:@"title"];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //收回弹出的控制器
    [self dismissViewControllerAnimated:YES completion:nil];
    //获取用户选中的城市组对应的模型对象
    TRCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    //发送通知给区域视图控制器(城市的名字)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCityDidChange" object:self userInfo:@{@"TRSelectedCityName" : cityName}];
}











@end
