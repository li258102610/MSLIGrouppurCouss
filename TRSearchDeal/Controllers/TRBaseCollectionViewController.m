//
//  TRBaseCollectionViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRBaseCollectionViewController.h"
#import "TRMainCollectionViewController.h"
#import "TRNavLeftView.h"
#import "UIBarButtonItem+TRBarButtonItem.h"
#import "TRSortViewController.h"
#import "TRCategroyViewController.h"
#import "TRRegionViewController.h"
#import "TRCategory.h"
#import "TRRegion.h"
#import "TRSort.h"
#import "TRDeal.h"
#import "DPAPI.h"
#import "TRCollectionViewCell.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "TRDetailViewController.h"
#import "TRMapViewController.h"
#import "TRNavigationController.h"
#import "TRMetaDataTool.h"
#import "TRSearchViewController.h"

@interface TRBaseCollectionViewController ()<DPRequestDelegate>
//存储服务器返回的订单数据(改成可变数组类型：存储更多订单数据)
@property (nonatomic, strong) NSMutableArray *dealsArray;
//存储page页数
@property (nonatomic, assign) int page;

@end

@implementation TRBaseCollectionViewController

static NSString * const reuseIdentifier = @"deal";

- (NSMutableArray *)dealsArray {
    if (!_dealsArray) {
        _dealsArray = [NSMutableArray array];
    }
    return  _dealsArray;
}

- (id)init {
    //设置一个collectionView的flow layout
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(305, 305);
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置collectionView的背景颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    //创建上拉加载控件
    [self setUpBottomControl];
}
- (void)setUpBottomControl {
    //创建UIRefreshControl对象
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    //设置对象的属性(偏移量/文本/添加action)
    refreshControl.triggerVerticalOffset = 100;
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在等待加载更多团购"];
    [refreshControl addTarget:self action:@selector(loadMoreDeals) forControlEvents:UIControlEventValueChanged];
    //设置collectionView的属性(上拉加载的控件)
    self.collectionView.bottomRefreshControl = refreshControl;
}

#pragma mark --- 加载团购订单
//加载更多团购(设置page参数)
- (void)loadMoreDeals {
    self.page++;
    [self sendRequestToServer];
}
- (void)loadNewDeals {
    self.page = 1;//第一次加载
    //    [self.dealsArray removeAllObjects];
    [self sendRequestToServer];
}
- (void)sendRequestToServer{
    //创建参数可变字典
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //调用子类的设置参数的方法
    [self settingRequestParams:params];

    //页数
    params[@"page"] = @(self.page);
    //limit限定参数(默认20条)
    
    NSLog(@"发送请求的参数:%@", params);
    //创建api对象
    DPAPI *api = [[DPAPI alloc] init];
    //发送请求
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"返回成功:%@", result);
    //    NSArray *resultArray = [self parseDealsResult:result];
    NSArray *resultArray = [TRMetaDataTool dealsFromResult:result];
    
    //情况：新的请求需要把dealsArray中的数据全部清空，在把新的数据放到dealsArray数组中
    if (self.page == 1) {
        [self.dealsArray removeAllObjects];
    }
    [self.dealsArray addObjectsFromArray:resultArray];
    
    //刷新collectionView
    [self.collectionView reloadData];
    //停止转动的动画
    [self.collectionView.bottomRefreshControl endRefreshing];
}

- (NSArray *)parseDealsResult:(id)result {
    NSArray *dealsArrary = result[@"deals"];
    NSMutableArray *dealsMutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in dealsArrary) {
        TRDeal *deal = [TRDeal new];
        [deal setValuesForKeysWithDictionary:dealDic];
        [dealsMutableArray addObject:deal];
    }
    return [dealsMutableArray copy];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"返回失败");
    //停止动画
    [self.collectionView.bottomRefreshControl endRefreshing];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dealsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.deal = self.dealsArray[indexPath.row];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//点中collectionCell的触发方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //数据来源
    TRDeal *deal = self.dealsArray[indexPath.row];
    //创建详情视图控制器对象(WebView:deal的url)
    TRDetailViewController *detailViewController = [TRDetailViewController new];
    detailViewController.deal = deal;
    //弹出详情控制器对象
    [self presentViewController:detailViewController animated:YES completion:nil];
}

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
