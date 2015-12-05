//
//  TRNavLeftView.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <UIKit/UIKit.h>

@interface TRNavLeftView : UIView
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

//提供类方法，返回从xib加载的自定义视图
+ (id)customView;





@end
