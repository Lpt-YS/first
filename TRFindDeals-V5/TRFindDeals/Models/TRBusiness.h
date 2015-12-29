//
//  TRBusiness.h
//  TRFindDeals
//
//  Created by tarena on 15/12/22.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRBusiness : NSObject

@property (nonatomic, strong) NSString *name;
//id特例
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float longitude;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *h5_url;










@end
