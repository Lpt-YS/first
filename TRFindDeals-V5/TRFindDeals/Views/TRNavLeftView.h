//
//  TRNavLeftView.h
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNavLeftView : UIView
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

//返回从xib加载的视图对象
+ (id)navView;




@end
