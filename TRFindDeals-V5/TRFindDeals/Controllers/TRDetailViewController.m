//
//  TRDetailViewController.m
//  TRFindDeals
//
//  Created by tarena on 15/12/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRDetailViewController.h"

@interface TRDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //将h5页面加载到webView上
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.dealUrlStr]]];

}
- (IBAction)clickBackButton:(id)sender {
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
