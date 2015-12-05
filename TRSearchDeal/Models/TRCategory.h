//
//  TRCategory.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <Foundation/Foundation.h>

@interface TRCategory : NSObject
@property (nonatomic, strong) NSString *highlighted_icon;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *small_highlighted_icon;
@property (nonatomic, strong) NSString *small_icon;
@property (nonatomic, strong) NSString *map_icon;
//子分类
@property (nonatomic, strong) NSArray *subcategories;










@end
