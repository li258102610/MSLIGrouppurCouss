//
//  TRDeal.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <Foundation/Foundation.h>

@interface TRDeal : NSObject
/**第二种方式的JSON对象解析
 规则一：在模型类中声明的对象名字需要和字典类型中的key一模一样
 规则二：在模型类中声明的对象名字不能使用关键字(description)
 规则三：如果有关键字(description), 必须重写方法setValue:forUndefinedKey:,.m中手动指定绑定规则
 注意点：
 1. 传入参数必须是字典setValuesWithDictionary:
 2. 无法解析嵌套的key
 3. 模型类.h中可以包含字典中不存在的key
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *list_price;
//优惠后的价格
@property (nonatomic, strong) NSNumber *current_price;
//分类
@property (nonatomic, strong) NSArray *categories;
//购买个数
@property (nonatomic, strong) NSNumber *purchase_count;
//图片url
@property (nonatomic, strong) NSString *image_url;
//小图片url
@property (nonatomic, strong) NSString *s_image_url;
@property (nonatomic, strong) NSString *deal_h5_url;
//商户
@property (nonatomic, strong) NSArray *businesses;

//方式二：不用对外提供一个解析数据的方法







@end
