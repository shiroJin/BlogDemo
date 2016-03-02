//
//  WeiboTableView.h
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiboTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy)NSMutableArray *modelArr;

@end
