//
//  TRDeal.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRDeal.h"

@implementation TRDeal

//重写setValue:forUndefinedKey:方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //key是字典中对应的key
    if ([key isEqualToString:@"description"]) {
        //手动指定绑定规则,把字典中description对应的value赋值给指定模型对象中的desc属性
        self.desc = value;
    }
}








@end
