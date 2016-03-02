//
//  CommentViewController.m
//  My微博
//
//  Created by Macx on 16/1/20.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableView.h"
#import "AppDelegate.h"
#import "CommentLayout.h"
#import "MainTabBarCtrl.h"
#import "ThemeView.h"
#import "WeiboViewLayoutFrame.h"
#import "WeiboCell.h"
#import "WXRefresh.h"
#import "FaceView.h"

@interface CommentViewController () <UITextFieldDelegate>

@end

@implementation CommentViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.view.backgroundColor = [UIColor whiteColor];
//        self.title = @"微博正文";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNav];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyBoard:) name:UIKeyboardWillShowNotification object:nil];


    [self _createTabelView];
    [self configUI];
    [self loadCommentData];
    [self _createTextField];
    
    __weak typeof(self) wself = self;
    [_tableView addPullDownRefreshBlock:^{
        [wself loadCommentData];
        [wself.tableView.pullToRefreshView stopAnimating];
    }];
}

//****** 配置table view 头视图
- (void)configUI {
    //header
    WeiboCell *cmmtHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] firstObject];
    cmmtHeaderView.layoutFrame = self.weiboFrame;
    cmmtHeaderView.frame = CGRectMake(CGRectGetMinX(_tableView.frame), CGRectGetMinY(_tableView.frame), CGRectGetWidth(_tableView.frame), self.weiboFrame.weiboFrame.size.height + 100);
    
    for (int i = 1000; i < 1003; i++) {
        [[cmmtHeaderView viewWithTag:i] removeFromSuperview];
    }
    
    _tableView.tableHeaderView = cmmtHeaderView;
}

//****** 创建tableview
- (void)_createTabelView {
    _tableView = [[CommentTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 30) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
}

//****** 创建会话框
- (void)_createTextField {
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, kScreenHeight - 64 - 30,  200, 30)];
    _textField.backgroundColor = [UIColor orangeColor];
    _textField.delegate = self;
    [self.view addSubview:_textField];
    
}

- (void)popKeyBoard:(NSNotification *)notification {
    NSValue *value = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    
    //   （3）调整View的高度和tableView的高度
    [UIView animateWithDuration:0.25 animations:^{
        //键盘弹出，文本框随之上弹
        _textField.transform = CGAffineTransformMakeTranslation(0, -height);
    }];

}

#pragma mark - text field delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        _textField.transform = CGAffineTransformIdentity;
    }];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"%@", _textField.text);
    [delegate.sinaWeibo requestWithURL:@"comments/create.json" params:[NSMutableDictionary dictionaryWithDictionary:@{@"comment" : _textField.text,@"id" : [NSString stringWithFormat:@"%@",_weiboFrame.weiboModel.weiboId]
                                                                                                                              }] httpMethod:@"POST" finishBlock:^(SinaWeiboRequest *request, id result) {
        
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];

    [_textField resignFirstResponder];
    _textField.text = nil;
    return YES;
}

//****** 请求评论数据
- (void)loadCommentData {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *weiboID = [NSString stringWithFormat:@"%@", self.weiboFrame.weiboModel.weiboId];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithObject:weiboID forKey:@"id"];

    [delegate.sinaWeibo requestWithURL:@"comments/show.json" params:mDic httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        [self loadDataFinished:result];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"get comments error");
    }];
}

//加载评论数据
-(void)loadDataFinished:(NSDictionary *)result
{
    NSArray *arr = [result objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for (NSDictionary *dic in arr) {
        CommentModel *cmmtModel = [[CommentModel alloc] initContentWithDic:dic];
        CommentLayout *layout = [[CommentLayout alloc] init];
        layout.cmmtModel = cmmtModel;
        [comments addObject:layout];
    }
    
    _tableView.commentArr = comments;
    
    [_tableView reloadData];
    
}

//导航栏配置
- (void)configNav {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)backAction {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//标签栏配置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    ((MainTabBarCtrl *)self.tabBarController).tabbarView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    ((MainTabBarCtrl *)self.tabBarController).tabbarView.hidden = NO;

}


@end
