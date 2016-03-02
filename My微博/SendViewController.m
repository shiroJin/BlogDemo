//
//  SendViewController.m
//  My微博
//
//  Created by Macx on 16/1/21.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "SendViewController.h"
#import "MMDrawerController.h"
#import "AppDelegate.h"
#import "ThemeButton.h"
#import "FaceView.h"
#import "EmotionView.h"

@interface SendViewController () <UITextViewDelegate>
{
    UITextView *_textView;
}
@end

@implementation SendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _createItems];
    [self createText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardEvent) name:UIKeyboardWillShowNotification object:nil];
}

//****** 配置导航栏标签
- (void)_createItems {
    //返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 0, 60, 44);
    UIImage *backgroudImg = [[ThemeManager sharedThemeManager] getThemeImg:@"titlebar_button_back_9"];
    [backButton setBackgroundImage:backgroudImg forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //发送按钮
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, 60, 44);
    UIImage *sendBackgroudImg = [[ThemeManager sharedThemeManager] getThemeImg:@"titlebar_button_9"];
    [sendButton setBackgroundImage:sendBackgroudImg forState:UIControlStateNormal];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    sendItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = sendItem;
}
//返回标签方法
- (void)backAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
    MMDrawerController *drawer = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [drawer closeDrawerAnimated:YES completion:NULL];
}

//****** 创建文本框
- (void)createText {
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    //    辅助的工具栏
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    NSArray *buttonNames = @[@"compose_toolbar_1@2x.png",
                             @"compose_toolbar_3@2x.png",
                             @"compose_toolbar_4@2x.png",
                             @"compose_toolbar_5@2x.png",
                             @"compose_toolbar_6@2x.png"];
    
    float itemWidth = kScreenWidth / 5;
    for (int i = 0; i < buttonNames.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 50)];
        button.buttonName = buttonNames[i];
        button.tag = 300 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [accessoryView addSubview:button];
    }
    
    _textView.inputAccessoryView = accessoryView;
    [self.view addSubview:_textView];

}

- (void)buttonAction:(UIButton *)sender {
    FaceView *face = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    __weak typeof(self) wself = self;
    face.emotionView.emotionBlock = ^(NSString *emotion) {
        _textView.text = [_textView.text stringByAppendingString:emotion];
        wself.navigationItem.rightBarButtonItem.enabled = YES;
    };
    [_textView resignFirstResponder];
    if (_textView.inputView) {
        _textView.inputView = nil;
    }else {
        _textView.inputView = face;
    }
    [_textView becomeFirstResponder];
}

#pragma mark - text view delegate

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

//配置键盘
- (void)keyBoardEvent {

}

//****** 发送微博
- (void)sendAction:(UIButton *)sender {
    NSString *text = _textView.text;
    
    NSString *str = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length > 140) {
        [self showFailHUD:@"字数不能超过140字" withDelayTime:2];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                   @"status" : text
                                                                                   }];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.sinaWeibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" finishBlock:^(SinaWeiboRequest *request, id result) {
        NSLog(@"发送成功");
        [self showSuccessHUD:@"发送成功" withDelayHideTime:2];
        [self dismissViewControllerAnimated:YES completion:NULL];
        MMDrawerController *drawer = (MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        [drawer closeDrawerAnimated:YES completion:NULL];
        
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"发送失败");
    }];
}

@end
