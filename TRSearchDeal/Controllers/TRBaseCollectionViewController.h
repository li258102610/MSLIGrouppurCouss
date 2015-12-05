//
//  TRBaseCollectionViewController.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <UIKit/UIKit.h>

@interface TRBaseCollectionViewController : UICollectionViewController

//替子类加载团购订单数据
- (void)loadNewDeals;

//给子类提供一个设置请求参数的接口
- (void)settingRequestParams:(NSMutableDictionary *)params;






@end
