//
//  MoreViewCtrl.h
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseViewController.h"

@class SinaWeibo;
@interface MoreViewCtrl : UITableViewController
@property (weak, nonatomic) IBOutlet UIImageView *themeImg;
@property (weak, nonatomic) IBOutlet UIImageView *accountImg;
@property (weak, nonatomic) IBOutlet UIImageView *feedbackImg;
@property (weak, nonatomic) IBOutlet UILabel *themeTitle;

@property (nonatomic, strong) SinaWeibo *sinaweibo;

@end
