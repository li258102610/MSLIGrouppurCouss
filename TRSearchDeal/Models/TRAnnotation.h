//
//  TRAnnotation.h
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TRAnnotation : NSObject<MKAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
//自定义的图片
@property (nonatomic, copy) UIImage *image;









@end
