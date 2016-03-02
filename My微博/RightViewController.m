//
//  RightViewController.m
//  My微博
//
//  Created by Macx on 16/1/21.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "RightViewController.h"
#import "ThemeButton.h"
#import "SendViewController.h"
#import "MainNavCtrl.h"
#import "HomeViewCtrl.h"

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configBtn];
    
}

- (void)configBtn {
    _writeBtn.buttonName = @"newbar_icon_1@2x.png";
    _photoBtn.buttonName = @"newbar_icon_3";
    _cameraBtn.buttonName = @"newbar_icon_2";
    _VideoBtn.buttonName = @"newbar_icon_2";
}



- (IBAction)clickAction:(id)sender {
    UIButton *button = sender;
    switch (button.tag) {
        case 200:
        {
            SendViewController *sender = [[SendViewController alloc] init];
        
            [self presentViewController:[[MainNavCtrl alloc] initWithRootViewController:sender] animated:YES completion:NULL];
        }
            break;
            
        default:
            break;
    }
}
@end
