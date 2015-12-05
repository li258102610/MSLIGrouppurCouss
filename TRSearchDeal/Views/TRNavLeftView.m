//
//  TRNavLeftView.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRNavLeftView.h"

@implementation TRNavLeftView

+ (id)customView {
    return [[[NSBundle mainBundle] loadNibNamed:@"TRNavLeftView" owner:nil options:nil] firstObject];
}

//防止横屏时，自定义视图的拉伸效果
//调用时机：读取TRNavLeftView.xib的时候(反归档/解码)
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}








@end
