//
//  TRDetailViewController.m
//  我是团购
//
//  Created by 李聪 on 15/12/3.
//  Copyright © 2015年 李聪. All rights reserved.
//https://github.com/li258102610/MSLIGrouppurchase

#import "TRDetailViewController.h"

@interface TRDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation TRDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载团购详情的h5页面
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
}


- (IBAction)closeDetailView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
