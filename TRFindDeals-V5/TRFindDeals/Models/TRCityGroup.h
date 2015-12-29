//
//  TRCityGroup.h
//  TRTuanDeal
//
//  Created by tarena on 15-7-23.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRCityGroup : NSObject

//这组城市对应的首字母
@property (nonatomic, strong) NSString *title;
//对应首字母的所有城市数组
@property (nonatomic, strong) NSArray *cities;

@end
