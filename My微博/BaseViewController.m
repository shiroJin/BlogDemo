//
//  BaseViewController.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self _loadImg];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_loadImg) name:kThemeChangeNotifiCation object:nil];
}

- (void)_loadImg {
    
    UIImage *img = [[ThemeManager sharedThemeManager] getThemeImg:@"bg_home.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
}

#pragma mark - HUD 提示界面的配置。
//提示功能成功，显示一个成功的提示。
- (void)showSuccessHUD:(NSString *)title withDelayHideTime:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText = title;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [hud hide:YES afterDelay:delay];
}
//提示失败
- (void)showFailHUD:(NSString *)title withDelayTime:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    hud.labelText = title;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:delay];
}

//
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
