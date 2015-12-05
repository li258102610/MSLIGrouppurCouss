//
//  TRMapViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRMapViewController.h"
#import <MapKit/MapKit.h>
#import "DPAPI.h"
#import "TRMetaDataTool.h"
#import "TRDeal.h"
#import "TRBusiness.h"
#import "TRAnnotation.h"
#import "UIBarButtonItem+TRBarButtonItem.h"
#import "TRCategory.h"

@interface TRMapViewController () <MKMapViewDelegate, DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic, strong) CLGeocoder *geoCoder;
//城市的名字
@property (nonatomic, strong) NSString *cityName;
@end

@implementation TRMapViewController
- (CLLocationManager *)mgr {
    if (!_mgr) {
        _mgr = [CLLocationManager new];
    }
    return _mgr;
}
- (CLGeocoder *)geoCoder {
    if (!_geoCoder) {
        _geoCoder = [CLGeocoder new];
    }
    return _geoCoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
    self.navigationItem.title = @"定位";
    //添加返回item
    UIBarButtonItem *backItem = [UIBarButtonItem itemWithImage:@"icon_back" withHighlightedImage:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;

    //征求用户同意(默认用户同意/Info.plist)
    [self.mgr requestWhenInUseAuthorization];
    //设置地图的属性(开始定位/delegate)
    self.mapView.delegate = self;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}
- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- MapViewDelegate
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    //定位到用户的位置(经纬度+半径)
    //反地理编码获取用户所在位置的城市的名字(city参数)
    [self.geoCoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks lastObject];
        NSLog(@"placemark:%@", placemark.addressDictionary);
        //从地址字典中获取城市的名字(北京/深圳/上海...)
        NSString *cityName = placemark.addressDictionary[@"City"];
        cityName = [cityName substringToIndex:cityName.length - 1];
        //cityName赋值
        self.cityName = cityName;
        NSLog(@"城市的名字:%@", cityName);
        
        //发送请求(城市+用户的位置+半径)
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}

//地图区域发生变化
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //防止没有定位用户的位置,获取不到城市的名字
    if (!self.cityName) {
        return;
    }
    //重新设置经纬度的参数(地图的中心位置+半径)
    //发送请求(地图的中心位置+半径+城市)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.cityName;
    params[@"radius"] = @1000;
    //经纬度(地图的中心位置)
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    //创建api对象
    DPAPI *api = [DPAPI new];
    //发送请求
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}
#pragma mark --- DPDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    //解析result，并且赋值给数组 (TRXXXXXManager)
    NSArray *dealsArray = [TRMetaDataTool dealsFromResult:result];
    //添加大头针到地图视图
    for (TRDeal *deal in dealsArray) {
        NSArray *businessArray = [TRMetaDataTool businessesFromDeal:deal];
        //当前deal对象属于哪个分类(map_icon)
        TRCategory *category = [TRMetaDataTool categoryFromDeal:deal];
        for (TRBusiness *business in businessArray) {
//            NSLog(@"商家的经纬度:%f;%f",business.latitude, business.longitude);
            //添加大头针(模型对象+重用机制)
            TRAnnotation *annotation = [TRAnnotation new];
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            annotation.title = business.name;
            annotation.subtitle = deal.desc;
            //大头针图片
            annotation.image = [UIImage imageNamed:category.map_icon];
            //排除已经添加的大头针(重写isEqual:重新指定两个大头针对象是否相等-->title一样)
            if([self.mapView.annotations containsObject:annotation]) {
                break;
            }
            //添加大头针
            [self.mapView addAnnotation:annotation];
        }
    }
    
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //把用户蓝色的圈排除
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //写MKAnnotationView的重用机制
    static NSString *identifier = @"anno";
    MKAnnotationView *annoView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annoView) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annoView.canShowCallout = YES;
    }
    //赋值；返回
    TRAnnotation *anno = (TRAnnotation *)annotation;
    annoView.annotation = anno;
    annoView.image = anno.image;
    
    return annoView;
}







@end
