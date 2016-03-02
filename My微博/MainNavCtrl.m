//
//  MainNavCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MainNavCtrl.h"

@interface MainNavCtrl ()

@end

@implementation MainNavCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setColorAndBackgroundImg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setColorAndBackgroundImg) name:kThemeChangeNotifiCation object:nil];
}

- (void)setColorAndBackgroundImg {
    [self setTitleColor];
    [self setBackGroundImg];
}

//设置导航栏标题颜色
- (void)setTitleColor {
    UIColor *color = [[ThemeManager sharedThemeManager] getThemeColor];
    
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName : color
                                     };
    
    self.navigationBar.titleTextAttributes = textAttributes;
}
//设置导航栏背景颜色
- (void)setBackGroundImg {
    
    UIImage *img = [[ThemeManager sharedThemeManager] getThemeImg:@"mask_titlebar64"];
    [self.navigationBar setBackgroundImage:img forBarMetrics:UIBarMetricsDefault];
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
