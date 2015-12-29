//
//  TRTableViewCell.m
//  TRFindDeals
//
//  Created by tarena on 15/12/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRTableViewCell.h"

@implementation TRTableViewCell

+ (id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withHighlightedImageName:(NSString *)hlImageName {
    //重用机制
    static NSString *identifier = @"cell";
    TRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TRTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //cell两个背景图片
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:hlImageName]];
    
    return cell;
}

//重写setCategory的方法(四个cell的属性赋值)
- (void)setCategory:(TRCategory *)category {
    /**分类视图控制器调用部分:
    cell.category = self.categoryArray[indexPath.row];
     */
    //两个image
    self.imageView.image = [UIImage imageNamed:category.small_icon];
    self.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
    //text
    self.textLabel.text = category.name;
    //右箭头
    if (category.subcategories.count > 0) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    } else {
        //没有子分类
        self.accessoryView = nil;
    }
}







@end
