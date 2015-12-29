//
//  TRDeal.h
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDeal : NSObject

/**原则一: 模型类中声明变量名字要字典中的key一模一样
原则二:如果字典包含关键字(description),手动绑定description和模型类的某个属性关联(重写setValue:forUndefinedKey:方法)
 */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
//原价格
@property (nonatomic, strong) NSNumber *list_price;
//团购价格
@property (nonatomic, strong) NSNumber *current_price;
//分类
@property (nonatomic, strong) NSArray *categories;
//已购数量
@property (nonatomic, strong) NSNumber *purchase_count;
@property (nonatomic, strong) NSString *image_url;
@property (nonatomic, strong) NSString *s_image_url;
@property (nonatomic, strong) NSString *deal_h5_url;
//商家
@property (nonatomic, strong) NSArray *businesses;











@end
