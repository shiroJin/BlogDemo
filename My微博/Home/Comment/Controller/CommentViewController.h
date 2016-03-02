//
//  CommentViewController.h
//  My微博
//
//  Created by Macx on 16/1/20.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WeiboViewLayoutFrame;
@class WeiboCell;
@class CommentTableView;

@interface CommentViewController : UIViewController

@property (strong, nonatomic)WeiboViewLayoutFrame *weiboFrame;
@property (strong, nonatomic)CommentTableView *tableView;
@property (strong, nonatomic)UITextField *textField;

@end
