//
//  DiscoverViewCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "DiscoverViewCtrl.h"
#import "AppDelegate.h"

@interface DiscoverViewCtrl ()

@end

@implementation DiscoverViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).sinaWeibo requestWithURL:@"emotions.json" params:nil httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        NSArray *arr = result;
        
        [arr writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"documents/emotions.plist"] atomically:YES];
        //        dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //            for (NSDictionary *dic in arr) {
        //                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"url"]]];
        //                [data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"documents/%@", dic[@"value"]]] atomically:YES];
        //            }
        //        });
        NSLog(@"沙盒路径%@", NSHomeDirectory());
        
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"表情包请求错误");
    }];

    // Do any additional setup after loading the view.
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
