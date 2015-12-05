//
//  TRTableViewCell.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <UIKit/UIKit.h>
#import "TRCategory.h"

@interface TRTableViewCell : UITableViewCell

@property (nonatomic, strong) TRCategory *category;

//给定两个图片的名字和tableView，返回一个已经创建好的tableViewCell
+ (id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withHighlightedImageName:(NSString *)hlImageName;







@end
