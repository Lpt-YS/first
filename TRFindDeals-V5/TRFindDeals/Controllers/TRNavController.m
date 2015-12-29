//
//  TRNavController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRNavController.h"

@interface TRNavController ()

@end

@implementation TRNavController

- (void)viewDidLoad {
    [super viewDidLoad];

    //获取navBar
    UINavigationBar *bar = [UINavigationBar appearance];
    //设置背景图片
    [bar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
