//
//  TRAnnotation.h
//  TRFindDeals
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TRAnnotation : NSObject<MKAnnotation>
//坐标
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//title
@property (nonatomic, copy) NSString *title;
//subtitle
@property (nonatomic, copy) NSString *subtitle;
//image
@property (nonatomic, strong) UIImage *image;







@end
