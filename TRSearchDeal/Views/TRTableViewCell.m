//
//  TRTableViewCell.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRTableViewCell.h"

@implementation TRTableViewCell

+ (id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withHighlightedImageName:(NSString *)hlImageName {
    //cell重用机制
    static NSString *identifier = @"cell";
    TRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TRTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //cell的图片的设置
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:hlImageName]];
    
    return cell;
}

//重写setCategory方法(设置cell属性)
- (void)setCategory:(TRCategory *)category {
    //cell的文本
    self.textLabel.text = category.name;
    //cell图片
    if (category.small_icon != nil) {
        self.imageView.image = [UIImage imageNamed:category.small_icon];
    }
    //cell的高亮图片
    if (category.small_highlighted_icon != nil) {
        self.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
    }
    //cell右边的箭头
    if (category.subcategories.count > 0) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    } else {
        self.accessoryView = nil;
    }
}







@end
