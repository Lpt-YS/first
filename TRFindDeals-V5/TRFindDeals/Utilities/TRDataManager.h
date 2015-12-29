//
//  TRDataManager.h
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRDeal.h"
#import "TRCategory.h"

@interface TRDataManager : NSObject

//给定服务器返回的result参数,返回数组(TRDeal)
+ (NSArray *)parseDealsResult:(id)result;

//返回排序数组(TRSort)
+ (NSArray *)getAndParseSort;

//返回分类数组(TRCategory)
+ (NSArray *)getAndParseCategory;

//返回所有城市数组(TRCity)
+ (NSArray *)getAndParseCity;

//返回所有城市组(TRCityGroup)
+ (NSArray *)getAndParseCityGroup;

//给定城市名字, 返回该城市对应的区域数组(TRRegion)
+ (NSArray *)getRegionsByCityName:(NSString *)cityName;

//给定订单对象,返回该订单支持的所有商家数组(TRBusiness)
+ (NSArray *)getAndParseBusiness:(TRDeal *)deal;

//给定订单对象,返回该订单所属分类
+ (TRCategory *)getCategoryWithDeal:(TRDeal *)deal;








@end
