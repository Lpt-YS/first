//
//  TRDeal.m
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRDeal.h"

@implementation TRDeal

//重写方法,实现关键字description和desc的绑定
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key {
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    
}







@end
