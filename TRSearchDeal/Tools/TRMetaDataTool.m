//
//  TRMetaDataTool.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRMetaDataTool.h"
#import "TRSort.h"
#import "TRCity.h"
#import "TRCategory.h"
#import "TRRegion.h"
#import "TRCityGroup.h"
#import "TRDeal.h"
#import "TRBusiness.h"

@implementation TRMetaDataTool
static NSArray *_sortsArray = nil;
+ (NSArray *)sorts {
    if (!_sortsArray) {
        //初始化
        //从sorts.plist读取源数据(NSDictionary)
        //循环解析(NSDictionary和TRSort之间的关系)
        _sortsArray = [[self alloc]getSortsDataFromPlist:@"sorts.plist"];
    }
    return _sortsArray;
}

- (NSArray *)getSortsDataFromPlist:(NSString *)plistFileName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    //使用数组类型接收(Root的type是Array)
    NSArray *sortsArray = [NSArray arrayWithContentsOfFile:plistPath];
    //循环解析(寻找字典和排序模型之间的关系)
    NSMutableArray *sortsMutableArray = [NSMutableArray array];
    for (NSDictionary *sortDic in sortsArray) {
        //创建一个空的排序模型对象
        TRSort *sort = [TRSort new];
        //调用setValuesWithDictionary方法，寻找关系
        [sort setValuesForKeysWithDictionary:sortDic];
        [sortsMutableArray addObject:sort];
    }
    return [sortsMutableArray copy];
}

static NSArray *_citiesArray = nil;
+ (NSArray *)cities {
    if (!_citiesArray) {
        _citiesArray = [[self alloc] getCitiesFromPlistFile:@"cities.plist"];
    }
    return _citiesArray;
}
- (NSArray *)getCitiesFromPlistFile:(NSString *)plistFileName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    //Root的type
    NSArray *citiesArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *citiesMutableArray = [NSMutableArray array];
    for (NSDictionary *cityDic in citiesArray) {
        TRCity *city = [TRCity new];
        [city setValuesForKeysWithDictionary:cityDic];
        [citiesMutableArray addObject:city];
    }
    return [citiesMutableArray copy];
}

static NSArray *_categoriesArray = nil;
+ (NSArray *)categories {
    if (!_categoriesArray) {
        _categoriesArray = [[self alloc] getCategoriesFromPlistFile:@"categories.plist"];
    }
    return _categoriesArray;
}
- (NSArray *)getCategoriesFromPlistFile:(NSString *)plistFileName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFileName ofType:nil];
    //Root的type
    NSArray *categoriesArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *categoriesMutableArray = [NSMutableArray array];
    for (NSDictionary *categoryDic in categoriesArray) {
        TRCategory *cateogry = [TRCategory new];
        [cateogry setValuesForKeysWithDictionary:categoryDic];
        [categoriesMutableArray addObject:cateogry];
    }
    return [categoriesMutableArray copy];
}

+ (NSArray *)regionsByCityName:(NSString *)cityName {
    //判定城市名字为空
    if (cityName.length == 0) {
        return nil;
    }
    //循环从所有的城市数组中寻找城市名字叫cityName
    NSArray *citiesArray = [self cities];
    TRCity *findCity = [[TRCity alloc] init];
    for (TRCity *city in citiesArray) {
        if ([city.name isEqualToString:cityName]) {
            //找到了城市名字是cityName
            findCity = city;
            break;
        }
    }
    //循环解析成该城市所有的区域对象组成的数组
    //NSDictionary -> TRRegion
    NSMutableArray *regionMutableArray = [NSMutableArray array];
    for (NSDictionary *regionDic in findCity.regions) {
        TRRegion *region = [TRRegion new];
        [region setValuesForKeysWithDictionary:regionDic];
        [regionMutableArray addObject:region];
    }
    return [regionMutableArray copy];
}

static NSArray *_cityGroupsArray = nil;
+ (NSArray *)cityGroups {
    if (!_cityGroupsArray) {
        _cityGroupsArray = [[self alloc] getCityGroupFromPlistFile:@"cityGroups.plist"];
    }
    return _cityGroupsArray;
}
- (NSArray *)getCityGroupFromPlistFile:(NSString *)plistName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    NSArray *cityGroupArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *cityGroupMutableArray = [NSMutableArray array];
    for (NSDictionary *cityGroupDic in cityGroupArray) {
        TRCityGroup *cityGroup = [TRCityGroup new];
        [cityGroup setValuesForKeysWithDictionary:cityGroupDic];
        [cityGroupMutableArray addObject:cityGroup];
    }
    return [cityGroupMutableArray copy];
}

+ (NSArray *)dealsFromResult:(id)result {
    NSArray *dealsArrary = result[@"deals"];
    NSMutableArray *dealsMutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in dealsArrary) {
        TRDeal *deal = [TRDeal new];
        [deal setValuesForKeysWithDictionary:dealDic];
        [dealsMutableArray addObject:deal];
    }
    return [dealsMutableArray copy];
}

+ (NSArray *)businessesFromDeal:(TRDeal *)deal {
    NSArray *businessArray = deal.businesses;
    NSMutableArray *businessMutableArray = [NSMutableArray array];
    for (NSDictionary *businessDic in businessArray) {
        TRBusiness *business = [TRBusiness new];
        [business setValuesForKeysWithDictionary:businessDic];
        [businessMutableArray addObject:business];
    }
    return [businessMutableArray copy];
}

+ (TRCategory *)categoryFromDeal:(TRDeal *)deal {
    //deal <---> category
    NSString *categoryStr = [deal.categories firstObject];
    //从整个分类数组中寻找分类的名字叫做categoryStr
    NSArray *categoryArray = [self categories];
    for (TRCategory *category in categoryArray) {
        //从主分类
        if ([category.name isEqualToString:categoryStr]) {
            return category;
        }
        //子分类
        if ([category.subcategories containsObject:categoryStr]) {
            return category;
        }
    }
    return nil;
}








@end
