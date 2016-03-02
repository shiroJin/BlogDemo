//
//  WeiboCell.h
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiboModel;
@class ContentView;

@interface WeiboCell : UITableViewCell

@property (strong, nonatomic)WeiboViewLayoutFrame *layoutFrame;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *resource;
@property (weak, nonatomic) IBOutlet UIButton *repost;
@property (weak, nonatomic) IBOutlet UIButton *comment;
@property (weak, nonatomic) IBOutlet ContentView *weiboContent;

@property (weak, nonatomic) IBOutlet UIButton *favour;


@end
