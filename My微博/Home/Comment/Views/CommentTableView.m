//
//  CommentTableView.m
//  My微博
//
//  Created by Macx on 16/1/20.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentLayout.h"
#import "CommentModel.h"
#import "CommentCell.h"
#import "WeiboCell.h"

#define kCommentCell @"commentCell"
@interface CommentTableView () <UITableViewDataSource, UITableViewDelegate> {
    
}

@end

@implementation CommentTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:kCommentCell];
    }
    return self;
}

#pragma mark - table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((CommentLayout *)_commentArr[indexPath.row]).cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [self dequeueReusableCellWithIdentifier:kCommentCell];
    cell.commentLayout = _commentArr[indexPath.row];
    
    return cell;
}

@end
