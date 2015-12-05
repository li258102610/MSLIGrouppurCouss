//
//  TRCollectionViewCell.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TRCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;


@end

@implementation TRCollectionViewCell

//重写setDeal方法，给6个控件赋值
- (void)setDeal:(TRDeal *)deal {
    //设置cell背景图片
    self.backgroundView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    
    //订单图片(SDWebImage)
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    //订单名字
    self.titleLabel.text = deal.title;
    //订单描述
    self.descriptionLabel.text = deal.desc;
    //优惠后的价格
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.current_price];
    //原价格
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.list_price];
    //已经售出多少
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%@", deal.purchase_count];
}





@end
