//
//  TRBaseCollectionViewController.h
//  TRFindDeals
//
//  Created by tarena on 15/12/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRBaseCollectionViewController : UICollectionViewController

//由父类声明/调用,由子类来实现
- (void)settingRequestParams:(NSMutableDictionary *)params;

//有子类调用,由父类实现
- (void)loadNewDeals;



@end
