//
//  MainTabBarCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MainTabBarCtrl.h"
#import "AppDelegate.h"
#import "ThemeView.h"
#import "ThemeButton.h"

#define kBadgeViewSize 24

@interface MainTabBarCtrl () {
    ThemeView *badgeView;
    ThemeView *_selectView;
}
@end

@implementation MainTabBarCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar removeFromSuperview];

    [self _createTabBar];
    [self loadUnreadWeiboCount];
}

- (void)viewWillAppear:(BOOL)animated {
}

#pragma mark - ****** 标签栏
- (void)_createTabBar {
    _tabbarView = [[ThemeView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49)];
    [self.view addSubview:_tabbarView];
    
    [self _createItems];
}

- (void)_createItems {
    
    CGFloat itemWidth = kScreenWidth / 5.0;

    if (!_selectView) {
        _selectView = [[ThemeView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 49)];
        _selectView.name = @"home_bottom_tab_arrow";
        [_tabbarView addSubview:_selectView];
    }
    
    NSArray *imgNames = @[
                          @"home_tab_icon_1.png",
                          @"home_tab_icon_2.png",
                          @"home_tab_icon_3.png",
                          @"home_tab_icon_4.png",
                          @"home_tab_icon_5.png",
                          ];

    [_tabbarView setName:@"mask_navbar"];
    
    for (int i = 0; i < 5; i++) {
        ThemeButton *button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth*i, 0, itemWidth, 49);
        button.buttonName = imgNames[i];
        button.tag = i;
        [button addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
    }
    
}

- (void)_clickAction:(UIControl *)sender {

    self.selectedIndex = sender.tag;
    _selectView.center = sender.center;
}

#pragma mark - 刷新未读微博数

- (void)loadUnreadWeiboCount {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                      @"unread_message" : @"1"
                                                      }];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).sinaWeibo requestWithURL:kUnreadCount params:params httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        [self loadUnReadWeiboFinish:result];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"未读微博数加载失败");
    }];
    
    [self performSelector:@selector(loadUnreadWeiboCount) withObject:nil afterDelay:30];
}

- (void)loadUnReadWeiboFinish:(id)result
{
    if (!badgeView) {
        badgeView = [[ThemeView alloc] initWithFrame:CGRectMake(kScreenWidth/5 - kBadgeViewSize, 5, kBadgeViewSize, kBadgeViewSize)];
        
//        badgeView.backgroundColor = [UIColor clearColor];
        badgeView.name = @"number_notify_9@2x.png";
        badgeView.layer.cornerRadius = kBadgeViewSize / 2;
        badgeView.layer.masksToBounds = YES;
        [self.tabbarView addSubview:badgeView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBadgeViewSize, kBadgeViewSize)];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor redColor];
        label.font = [UIFont systemFontOfSize:11];
        label.tag = 2015;
        [badgeView addSubview:label];
        
    }
    
    int num = [result[@"status"] intValue];
    if (num >= 0) {
        badgeView.hidden = NO;
        //        num = MIN(num, 99);
        
        UILabel *label = (UILabel *)[badgeView viewWithTag:2015];
        if(num < 100)
        {
            label.text = [NSString stringWithFormat:@"%d",num];
        }
        else
        {
            label.text = @"99+";
        }
    }else
    {
        badgeView.hidden = YES;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
