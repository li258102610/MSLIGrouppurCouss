//
//  TRMainCollectionViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

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

@interface TRMainCollectionViewController ()<DPRequestDelegate>
//排序弹出控制器
@property (nonatomic, strong) UIPopoverController *sortPopoverController;
//区域弹出控制器
@property (nonatomic, strong) UIPopoverController *regionPopoverController;
//分类弹出控制器
@property (nonatomic, strong) UIPopoverController *categoryPopoverController;
//排序视图
@property (nonatomic, strong) TRNavLeftView *sortView;
//区域视图
@property (nonatomic, strong) TRNavLeftView *regionView;
//分类视图
@property (nonatomic, strong) TRNavLeftView *categoryView;
//城市
@property (nonatomic, strong) NSString *selectedCity;
//主分类
@property (nonatomic, strong) NSString *selectedCategory;
//子分类
@property (nonatomic, strong) NSString * selectedSubCategory;
//主区域
@property (nonatomic, strong) NSString *selectedRegion;
//子区域
@property (nonatomic, strong) NSString *selectedSubRegion;
//排序
@property (nonatomic, assign) int selectedSort;

@end

@implementation TRMainCollectionViewController

static NSString * const reuseIdentifier = @"deal";

- (UIPopoverController *)sortPopoverController {
    if (!_sortPopoverController) {
        TRSortViewController *sortViewController = [TRSortViewController new];
        _sortPopoverController = [[UIPopoverController alloc] initWithContentViewController:sortViewController];
    }
    return _sortPopoverController;
}
- (UIPopoverController *)regionPopoverController {
    if (!_regionPopoverController) {
        TRRegionViewController *regionViewController = [TRRegionViewController new];
        _regionPopoverController = [[UIPopoverController alloc] initWithContentViewController:regionViewController];
    }
    return  _regionPopoverController;
}
- (UIPopoverController *)categoryPopoverController {
    if (!_categoryPopoverController) {
        TRCategroyViewController *categoryViewController = [TRCategroyViewController new];
        _categoryPopoverController = [[UIPopoverController alloc] initWithContentViewController:categoryViewController];
    }
    return _categoryPopoverController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
//    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //注册TRCollectionViewCell类型的cell;并且从xib来加载
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    //????
//    self.collectionViewLayout.fl
    
    //创建navigationBar左边的items(4个)
    [self setUpLeftItems];
    //创建navigationBar右边的items(2个)
    [self setUpRightItems];
    //监听其他控制器发送过来的通知事件(4个:城市/分类/区域/排序)
    [self setUpListenEvents];
}


- (void)setUpListenEvents {
    //城市
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:@"TRCityDidChange" object:nil];
    //分类
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryDidChange:) name:@"TRCategoryDidChange" object:nil];
    //区域
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regionDidChange:) name:@"TRRegionDidChange" object:nil];
    //排序
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortDidChange:) name:@"TRSortDidChange" object:nil];
}
#pragma mark --- 监听通知的触发方法
- (void)cityDidChange:(NSNotification *)notification {
    //获取通知中的参数(cityName)
    self.selectedCity = notification.userInfo[@"TRSelectedCityName"];
    //赋值给自定义的视图
    //发送请求
    [self loadNewDeals];
    
}
//用户点中那个分类，主视图控制器收到通知,在这个时候收回弹出控制器
- (void)categoryDidChange:(NSNotification *)notification {
    //主分类
    TRCategory *category = notification.userInfo[@"TRSelectedCategory"];
    self.selectedCategory = category.name;
    //子分类
    self.selectedSubCategory = notification.userInfo[@"TRSelectedSubCategory"];
    //赋值给自定义视图(categoryView)
    self.categoryView.subTitleLabel.text = self.selectedCategory;
    if (self.selectedSubCategory.length == 0) {
        self.categoryView.titleLabel.text = @"---";
    } else {
        //有子分类
        self.categoryView.titleLabel.text = self.selectedSubCategory;
    }
    //设置自定义视图的按钮图片
    [self.categoryView.imageButton setImage:[UIImage imageNamed:category.icon] forState:UIControlStateNormal];
    [self.categoryView.imageButton setImage:[UIImage imageNamed:category.highlighted_icon] forState:UIControlStateHighlighted];
    
    //收回分类弹出控制器
    [self.categoryPopoverController dismissPopoverAnimated:YES];
    //发送请求
    [self loadNewDeals];
    
}
- (void)regionDidChange:(NSNotification *)notification {
    //主区域
    TRRegion *region = notification.userInfo[@"TRSelectedRegion"];
    self.selectedRegion = region.name;
    //子区域
    self.selectedSubRegion = notification.userInfo[@"TRSelectedSubRegion"];
    if (self.selectedSubRegion.length == 0) {
        self.regionView.titleLabel.text = @"---";
    } else {
        self.regionView.titleLabel.text = self.selectedSubRegion;
    }
    self.regionView.subTitleLabel.text = [NSString stringWithFormat:@"%@-%@",self.selectedCity,self.selectedRegion];
    //imageButton的图片????
    //收回区域弹出控制器
    [self.regionPopoverController dismissPopoverAnimated:YES];
    //发送请求
    [self loadNewDeals];
    
}
- (void)sortDidChange:(NSNotification *)notification {
    TRSort *sort = notification.userInfo[@"TRSelectedSort"];
    self.selectedSort = [sort.value intValue];
    self.sortView.subTitleLabel.text = @"排序";
    self.sortView.titleLabel.text = sort.label;
    //收回排序弹出控制器
    [self.sortPopoverController dismissPopoverAnimated:YES];
    //发送请求
    [self loadNewDeals];
}

#pragma mark --- 创建navigation的items
- (void)setUpRightItems {
    //locationItem
    UIBarButtonItem *locationItem = [UIBarButtonItem itemWithImage:@"icon_map" withHighlightedImage:@"icon_map_highlighted" withTarget:self withAction:@selector(clickLocationItem)];
    //searchItem
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithImage:@"icon_search" withHighlightedImage:@"icon_search_highlighted" withTarget:self withAction:@selector(clickSearchItem)];
    self.navigationItem.rightBarButtonItems = @[locationItem, searchItem];
}
- (void)clickLocationItem {
    //创建地图视图控制器对象
    TRMapViewController *mapViewController = [TRMapViewController new];
    //设置为导航控制器的根视图控制器
    TRNavigationController *navController = [[TRNavigationController alloc] initWithRootViewController:mapViewController];
    //显示出来
    [self presentViewController:navController animated:YES completion:nil];
    
    
}
- (void)clickSearchItem {
    //创建搜索视图控制器对象
    TRSearchViewController *searchViewController = [TRSearchViewController new];
    if (self.selectedCity) {
        searchViewController.cityName = self.selectedCity;
    } else {
        //用户没有选择城市，给定一个默认的值
        searchViewController.cityName = @"北京";
    }

    //将上面的对象设置成navController的根视图控制器
    TRNavigationController *nav = [[TRNavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)setUpLeftItems {
    //logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    //去掉logItem的点中功能
    logoItem.enabled = NO;
    //分类
    self.categoryView = [TRNavLeftView customView];
    [self.categoryView.imageButton addTarget:self action:@selector(clickCategoryView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:self.categoryView];
    //区域
    self.regionView = [TRNavLeftView customView];
    [self.regionView.imageButton addTarget:self action:@selector(clickRegionView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc] initWithCustomView:self.regionView];
    //排序
    self.sortView = [TRNavLeftView customView];
    //添加sortView的点击的逻辑(弹出popoverController)
    [self.sortView.imageButton addTarget:self action:@selector(clickSortView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc] initWithCustomView:self.sortView];
    //添加4个items
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, regionItem, sortItem];
}

#pragma mark --- 点中navigationBar的自定义视图的触发方法
- (void)clickCategoryView {
    [self.categoryPopoverController presentPopoverFromRect:self.categoryView.bounds inView:self.categoryView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)clickRegionView {
    [self.regionPopoverController presentPopoverFromRect:self.regionView.bounds inView:self.regionView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

- (void)clickSortView {
    //创建一个弹出控制器对象
    //给对象指定一个内容视图控制器
    /**如何显示到界面
     第一个参数：相对于第二个参数的位置(偏移量)
     第二个参数：弹出位置是在哪个视图里面/上面
     第三个参数：弹出箭头的指向方向
     self.sortView.bounds:(0,0,130,40)
     */
    [self.sortPopoverController presentPopoverFromRect:self.sortView.bounds inView:self.sortView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 实现父类提供的设置请求参数的方法
- (void)settingRequestParams:(NSMutableDictionary *)params {
    
    //城市(必选参数)
    if (self.selectedCity.length == 0) {
        //如果用户没有选择城市，给定默认城市名字(最好定位用户的位置)
        params[@"city"] = @"北京";
    } else {
        params[@"city"] = self.selectedCity;
    }
    //分类
    //用户选择分类;并且不能等于"全部分类"
    if (self.selectedCategory && ![self.selectedCategory isEqualToString:@"全部分类"]) {
        //有子分类;并且不能等于"全部"
        if (self.selectedSubCategory && ![self.selectedSubCategory isEqualToString:@"全部"]) {
            //将用户选择的子分类赋值给category参数
            params[@"category"] = self.selectedSubCategory;
        } else {
            //只有主分类
            params[@"category"] = self.selectedCategory;
        }
    }
    //区域
    //是否用户选择了主区域；并且不等于"全部"
    if (self.selectedRegion && ![self.selectedRegion isEqualToString:@"全部"]) {
        //用户有选择子区域；并且不等于"全部"
        if (self.selectedSubRegion && ![self.selectedSubRegion isEqualToString:@"全部"]) {
            params[@"region"] = self.selectedSubRegion;
        } else {
            params[@"region"] = self.selectedRegion;
        }
    }
    //排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
