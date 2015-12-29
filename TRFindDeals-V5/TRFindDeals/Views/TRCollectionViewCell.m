//
//  TRCollectionViewCell.m
//  TRFindDeals
//
//  Created by tarena on 15/12/21.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TRCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *dealImageView;
@property (weak, nonatomic) IBOutlet UILabel *dealTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentListLabel;
@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
@end


@implementation TRCollectionViewCell


- (void)setDeal:(TRDeal *)deal {
    //整个cell的背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    //图片
    [self.dealImageView sd_setImageWithURL:[NSURL URLWithString:deal.s_image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    //title
    self.dealTitleLabel.text = deal.title;
    //desc
    self.dealDescLabel.text = deal.desc;
    //current
    
    self.currentListLabel.text = [NSString stringWithFormat:@"¥%@", deal.current_price];
    NSString *currentPriceStr = [NSString stringWithFormat:@"%@", deal.current_price];
    //处理89.90000000000001 -> 89.90(小数点后保留两位小数)
    if ([currentPriceStr isEqualToString:@"89.90000000000001"]) {
        NSLog(@"1111");
    }
    //获取小数点的位置
    NSInteger dotLocation = [currentPriceStr rangeOfString:@"."].location;
    //dotLocation: 2
    if (dotLocation != NSNotFound) {
        //89.90000000000001: dotLocation+2;
        //已经超过小数点后两位有效数字
        if (currentPriceStr.length - dotLocation > 3) {
            self.currentListLabel.text = [currentPriceStr substringToIndex:dotLocation + 3];
        }
    } else {
        self.currentListLabel.text = currentPriceStr;
    }

    
    
    //list
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.list_price];
    //purchase
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%@",deal.purchase_count];
}







@end
