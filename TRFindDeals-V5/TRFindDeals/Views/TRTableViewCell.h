//
//  TRTableViewCell.h
//  TRFindDeals
//
//  Created by tarena on 15/12/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRCategory.h"

@interface TRTableViewCell : UITableViewCell


@property (nonatomic, strong) TRCategory *category;

+ (id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withHighlightedImageName:(NSString *)hlImageName;








@end
