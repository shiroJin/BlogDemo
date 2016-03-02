//
//  CommentCell.h
//  84班微博
//
//  Created by Macx on 16/1/19.
//  Copyright © 2016年 george. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WXLabel;
@class CommentLayout;
@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) WXLabel *commentLabel;

@property (strong, nonatomic)CommentLayout *commentLayout;

@end
