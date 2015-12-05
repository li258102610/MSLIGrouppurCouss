//
//  TRMetaDataTool.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <Foundation/Foundation.h>
#import "TRDeal.h"
#import "TRCategory.h"

@interface TRMetaDataTool : NSObject

//返回所有解析好的排序模型对象组成的数组
+ (NSArray *)sorts;
//返回所有解析好的城市模型对象组成的数组
+ (NSArray *)cities;
//返回所有解析好的分类模型对象组成的数组
+ (NSArray *)categories;
//给定一个城市的名字，返回已经解析好的区域模型对象组成的数组
+ (NSArray *)regionsByCityName:(NSString *)cityName;
//返回所有解析好的城市组模型对象组成的数组
+ (NSArray *)cityGroups;
//给定服务器返回的result，返回所有解析好的订单模型对象组成的数组
+ (NSArray *)dealsFromResult:(id)result;
//给定某个订单模型对象，返回所有解析好的商户模型对象组成的数组
+ (NSArray *)businessesFromDeal:(TRDeal *)deal;
//给定某个订单模型对象，返回这个订单属于哪个分类模型对象
+ (TRCategory *)categoryFromDeal:(TRDeal *)deal;













@end
