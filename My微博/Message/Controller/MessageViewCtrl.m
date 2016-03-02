//
//  MessageViewCtrl.m
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MessageViewCtrl.h"
#import "WeiboTableView.h"
#import "WXRefresh.h"
#import "AppDelegate.h"
#import "WeiboViewLayoutFrame.h"

#define kATme @"statuses/mentions.json"
#define kCommentSendByMe @"comments/by_me.json"
#define kCommentSendToMe @"comments/to_me.json"
#define kCommentATme @"comments/mentions.json"

@interface MessageViewCtrl () {
    NSString *urlString;
}

@end

@implementation MessageViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    urlString = kATme;
    
    [self _createNavButton];
    [self _createTabelView];
}

//****** 创建表视图
- (void)_createTabelView {
    _tabelView  = [[WeiboTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
    [self.view addSubview:_tabelView];
    
    __weak typeof(self) wself = self;
    [_tabelView addPullDownRefreshBlock:^{
        [wself requestData];
        [wself.tabelView.pullToRefreshView stopAnimating];
    }];
    
    [_tabelView addInfiniteScrollingWithActionHandler:^{
        [wself requestOldData];
        [wself.tabelView.infiniteScrollingView stopAnimating];
    }];
    
    [self requestData];
}

//****** 导航栏按键配置
- (void)_createNavButton {
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 200, 40)];
    
    NSArray *buttonImg = @[
                           [UIImage imageNamed:@"navigationbar_mentions"],
                           [UIImage imageNamed:@"navigationbar_comments"],
                           [UIImage imageNamed:@"navigationbar_messages"],
                           [UIImage imageNamed:@"navigationbar_notice"]
                           ];
    //创建导航栏按钮
    for (int i = 0; i < buttonImg.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 50 + 10, 5, 30, 30);
        [button setImage:buttonImg[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        [titleView addSubview:button];
    }
    
    self.navigationItem.titleView = titleView;
}
//****** 请求数据
- (void)requestData {
    long since_id = 0;
//    if (_tabelView.modelArr.count > 0) {
//        WeiboViewLayoutFrame *layout = _tabelView.modelArr[0];
//        since_id = [layout.weiboModel.weiboId longValue];
//    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *params = @{
                             @"since_id" : [NSString stringWithFormat:@"%ld", since_id]
                             };
    [delegate.sinaWeibo requestWithURL:urlString params:[params mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        NSLog(@"%@", result);
        [self loadData:result isSince:YES];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"消息数据请求失败");
    }];
}

- (void)requestOldData {
    long max_id = 0;
    if (_tabelView.modelArr > 0) {
        WeiboViewLayoutFrame *layout = _tabelView.modelArr.lastObject;
        max_id = [layout.weiboModel.weiboId longValue];
    }
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *params = @{
                             @"max_id" : [NSString stringWithFormat:@"%ld", max_id]
                             };
    [delegate.sinaWeibo requestWithURL:urlString params:[params mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        [self loadData:result isSince:NO];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"消息数据请求失败");
    }];
}


//****** 加载数据
- (void)loadData:(id)result isSince:(BOOL)isSince{
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray *data = [result objectForKey:@"statuses"];
    for (NSDictionary *dic in data) {
        WeiboModel *model = [[WeiboModel alloc] initContentWithDic:dic];
        
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        layout.weiboModel = model;
        
        [dataArray addObject:layout];
    }
    
    if (_tabelView.modelArr.count > 0) {
        if (isSince) {
            if (_tabelView.modelArr[0]) {
                [dataArray addObjectsFromArray:_tabelView.modelArr];
                _tabelView.modelArr = dataArray;
            }else {
                if ([((WeiboViewLayoutFrame *)_tabelView.modelArr.lastObject).weiboModel.weiboId isEqualToNumber:((WeiboViewLayoutFrame *)dataArray[0]).weiboModel.weiboId]) {
                    [dataArray removeObjectAtIndex:0];
                }
                [_tabelView.modelArr addObjectsFromArray:dataArray];
            }
        }
        
        [_tabelView reloadData];
    }
}

//消息界面切换。
- (void)itemClick:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
            urlString = kATme;
            break;
        case 101:
            urlString = kCommentATme;
            break;
        case 102:
            urlString = kCommentSendByMe;
            break;
        case 103:
            urlString = kCommentSendToMe;
            break;
        default:
            break;
    }
}




@end
