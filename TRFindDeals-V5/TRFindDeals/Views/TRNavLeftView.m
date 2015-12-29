//
//  TRNavLeftView.m
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRNavLeftView.h"

@implementation TRNavLeftView


+ (id)navView {
    return [[[NSBundle mainBundle] loadNibNamed:@"TRNavLeftView" owner:self options:nil] firstObject];
}

//重写方法来防止随着父控件的拉伸效果
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        //设置自动拉伸为none
        self.autoresizingMask= UIViewAutoresizingNone;
    }
    return self;
}







@end
