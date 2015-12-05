//
//  TRAnnotation.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRAnnotation.h"

@implementation TRAnnotation
//重写isEqual方法(Object是自定义的大头针对象)
//重新制定相等的规则
- (BOOL)isEqual:(TRAnnotation *)object {
    return [self.title isEqual:object.title];
}






@end
