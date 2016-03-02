//
//  HomeViewCtrl.h
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseViewController.h"

@class SinaWeibo;
@class WeiboTableView;
@interface HomeViewCtrl : BaseViewController

@property (nonatomic, strong) SinaWeibo *sinaWeibo;
@property (nonatomic, strong) WeiboTableView *tableView;

@end
