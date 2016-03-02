//
//  MoreViewCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MoreViewCtrl.h"
#import "AppDelegate.h"
#import "MoreCell.h"
#import "themesTableViewController.h"
#import "AFNetworkReachabilityManager.h"

#define kCellIdentity @"cellIdentity"
@interface MoreViewCtrl () <SinaWeiboDelegate>

@end

@implementation MoreViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    
    [self _setNavRightItem];
    [self _setCellIcon];
    [self _setBackImg];
    [self _setTitle];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotifiCation object:nil];
}

- (void)themeChanged {
    
    [self _setCellIcon];
    [self _setBackImg];
    [self _setTitle];
}

- (void)_setTitle {
    ThemeManager *manager = [ThemeManager sharedThemeManager];
    _themeTitle.text = manager.themeName;
    _themeTitle.textColor = [manager getThemeColor];
}

- (void)_setBackImg {
    
    UIImage *img = [[ThemeManager sharedThemeManager] getThemeImg:@"bg_home.jpg"];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:img]];
}

- (void)_setCellIcon {
    ThemeManager *manager = [ThemeManager sharedThemeManager];
    
    _themeImg.image = [manager getThemeImg:kmore_icon_theme];
    _accountImg.image = [manager getThemeImg:kmore_icon_account];
    _feedbackImg.image = [manager getThemeImg:kmore_icon_feedback];
}

- (void)_setNavRightItem {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:@selector(loginOut:)];
    self.navigationItem.rightBarButtonItem = item;
}

//登出功能
- (void)loginOut:(UIBarButtonItem *)item {
    
    [self.sinaweibo logOut];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要切换用户" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.sinaweibo logIn];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (SinaWeibo *)sinaweibo {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeibo;
}

#pragma mark - tableview controller delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 60;
    }else {
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *index = [NSIndexPath indexPathForItem:0 inSection:0];
    //主题选择视图
    if (indexPath == index) {
        themesTableViewController *themesCtrl = [[themesTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        themesCtrl.themeArr = [[ThemeManager sharedThemeManager].themeConfig allKeys];
        
        [self.navigationController pushViewController:themesCtrl animated:YES];
    }
    //表情包下载
    if (indexPath == [NSIndexPath indexPathForItem:1 inSection:0]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.sinaWeibo requestWithURL:@"emotions.json" params:nil httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
            //afnetworking检查网络
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            if (manager.networkReachabilityStatus != AFNetworkReachabilityStatusReachableViaWiFi) {
                //创建alertView
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:NULL message:@"是否要下载表情包" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yes = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self loadEmotions:result];
                }];
                UIAlertAction *no = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
                [alert addAction:yes];
                [alert addAction:no];
                
                [self presentViewController:alert animated:yes completion:NULL];
            }
            
        } failBlock:^(SinaWeiboRequest *request, NSError *error) {
            NSLog(@"获取表情包失败");
        }];
    }
}

//下载表情
- (void)loadEmotions:(id)result {
    NSArray *emotionsArr = result;
    for (NSDictionary *dic in emotionsArr) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"url"]]];
        [data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"documents/"] atomically:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
