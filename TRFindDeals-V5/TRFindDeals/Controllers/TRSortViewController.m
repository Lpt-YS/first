//
//  TRSortViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/19.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRSortViewController.h"
#import "TRDataManager.h"
#import "TRSort.h"

@interface TRSortViewController ()

@property (nonatomic, strong) NSArray *sortArray;

@end

@implementation TRSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //常量值
    CGFloat inset = 15;
    CGFloat buttonHeight = 30;
    CGFloat buttonWidth = 100;
    
    //数据源
    self.sortArray = [TRDataManager getAndParseSort];
    for (int i = 0; i < self.sortArray.count; i++) {
        //创建button
        UIButton *button = [UIButton new];
        //设置button属性
        button.frame = CGRectMake(inset, i*(inset+buttonHeight)+inset, buttonWidth, buttonHeight);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        //第i个按钮的模型对象
        TRSort *sort = self.sortArray[i];
        [button setTitle:sort.label forState:UIControlStateNormal];
        //设置button的tag为循环变量
        button.tag = i;
        //添加button的action
        [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        
        //设置button文本颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //添加到view
        [self.view addSubview:button];
    }
    
    //设置弹出控制器显示的宽和高
    self.preferredContentSize = CGSizeMake(2*inset+buttonWidth, self.sortArray.count*(inset+buttonHeight)+inset);
}

- (void)clickButton:(UIButton *)button {
    //选中哪个button(发送通知的参数:sort值)
    //button.tag -> TRSort(self.sortArray)
    TRSort *sort = self.sortArray[button.tag];
    //发送通知(参数:sort)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRSortDidChange" object:self userInfo:@{@"TRSort":sort}];
    //收回控制器
    [self dismissViewControllerAnimated:YES completion:nil];
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
