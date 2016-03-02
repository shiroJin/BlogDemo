//
//  HomeViewCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "HomeViewCtrl.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "ThemeView.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "ContentView.h"
#import "WXRefresh.h"
#import <AudioToolbox/AudioToolbox.h>

@interface HomeViewCtrl () <SinaWeiboRequestDelegate> {
    NSMutableArray *_modelArr;
    ContentView *contentView;
    SystemSoundID soundID;
    BOOL isSince;
}

@end

@implementation HomeViewCtrl

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //注册系统声音
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"]];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.translucent = NO;
    //第一次登陆认证
    if (![[self sinaWeibo] isAuthValid]) {
        [[self sinaWeibo] logIn];
    }
    
    if ([[self sinaWeibo] isLoggedIn]) {
        [[self sinaWeibo] requestWithURL:@"statuses/home_timeline.json" params:nil httpMethod:@"GET" delegate:self];
    }
    
    [self _createTableView];
    
    //添加tableview 下拉功能
    __weak typeof(self) wself = self;
    [_tableView addPullDownRefreshBlock:^{
        
        if ([[wself sinaWeibo] isAuthValid]) {
            [wself loadData];
        }else
        {
            [[wself sinaWeibo] logIn];
        }
    }];
    //上拉
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        if ([[wself sinaWeibo] isAuthValid]) {
            [wself loadOldData];
        }else
        {
            [[wself sinaWeibo] logIn];
        }
    }];
    
}

//创建table view
- (void)_createTableView {
    
    _tableView = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
}

#pragma mark - 新浪微博 登陆认证 刷新加载数据
//新浪微博
- (SinaWeibo *)sinaWeibo{
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaWeibo;
}


//****** 登陆认证响应
- (void)request:(SinaWeiboRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"登入成功");
}

//****** 请求数据
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result {
   
    if ([request.url isEqualToString:kHomeTimelineUrl]) {
//            NSLog(@"result:\n%@", result);
        NSArray *resultArr = [result objectForKey:@"statuses"];
        _modelArr = [NSMutableArray array];
        
        for (NSDictionary *dic in resultArr) {
            WeiboModel *weiboModel = [[WeiboModel alloc] initContentWithDic:dic];
            
            WeiboViewLayoutFrame *layoutFrame = [[WeiboViewLayoutFrame alloc] init];
            layoutFrame.weiboModel = weiboModel;
            
            [_modelArr addObject:layoutFrame];
        }
        
        [self loadModels];//对tableview的model进行赋值。
        
        //    _tableView.modelArr = _modelArr;
    }

}

//****** 加载数据
- (void)loadModels {
    
    if (isSince) {
        //下拉时的models
        NSInteger newWeiboCount = _modelArr.count;
        
        [_modelArr addObjectsFromArray:_tableView.modelArr];
        [_tableView.pullToRefreshView stopAnimating];
        _tableView.modelArr = _modelArr;
        
        //刷新出来的新微薄提醒。
        if (newWeiboCount > 0) {
            static UILabel *refreshLabel;
            if (!refreshLabel) {
                refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
                refreshLabel.backgroundColor = [UIColor orangeColor];
                refreshLabel.textAlignment = NSTextAlignmentCenter;
                refreshLabel.alpha = 0;
                [self.view insertSubview:refreshLabel aboveSubview:_tableView];
            }
            refreshLabel.text = [NSString stringWithFormat:@"有%li条新微博", newWeiboCount];
    
            [UIView animateWithDuration:2 animations:^{
                refreshLabel.alpha = 1;
            } completion:^(BOOL finished) {
                refreshLabel.alpha = 0;
            }];
        }
        
        AudioServicesPlaySystemSound(soundID);
        
    }else {
        //上拉时的models
        if (_tableView.modelArr.count > 0) {
            if (((WeiboViewLayoutFrame *)_tableView.modelArr.lastObject).weiboModel.weiboId == ((WeiboViewLayoutFrame *)_modelArr[0]).weiboModel.weiboId) {
                [_tableView.modelArr removeLastObject];
            }
        }
        [_tableView.modelArr addObjectsFromArray:_modelArr];
        [_tableView.infiniteScrollingView stopAnimating];
        [_tableView reloadData];
    }
}

//****** 加载数据。
- (void)loadData {//下拉
    isSince = YES;
    long since_id = 0;
    
    if (_tableView.modelArr.count > 0) {
        since_id = [((WeiboViewLayoutFrame *)_tableView.modelArr[0]).weiboModel.weiboId longValue];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                        @"since_id" : [NSString stringWithFormat:@"%ld", since_id]
                                                                                    }];
    
    [[self sinaWeibo] requestWithURL:kHomeTimeline params:params httpMethod:@"GET" delegate:self];
}

- (void)loadOldData {//上拉
    isSince = NO;
    long max_id = 0;
    
    if (_tableView.modelArr.count > 0) {
        max_id = [((WeiboViewLayoutFrame *)[_tableView.modelArr lastObject]).weiboModel.weiboId longValue];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                           @"max_id" : [NSString stringWithFormat:@"%ld", max_id]
                                                                                   }];
    
    [[self sinaWeibo] requestWithURL:kHomeTimeline params:params httpMethod:@"GET" delegate:self];
}


@end
