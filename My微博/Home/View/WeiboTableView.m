//
//  WeiboTableView.m
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "ContentView.h"
#import "WeiboViewLayoutFrame.h"
#import "CommentViewController.h"
#import "MainNavCtrl.h"
#import "UIView+viewController.h"

@implementation WeiboTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        
        [self registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:@"weiboCell"];
        
        _modelArr = [NSMutableArray array];
    }
    return self;
}

- (void)setModelArr:(NSMutableArray *)modelArr {
    if (_modelArr != modelArr) {
        _modelArr = modelArr;
        
        [self reloadData];
    }
}

#pragma mark - Table View Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboViewLayoutFrame *layoutFrame = _modelArr[indexPath.item];
    return layoutFrame.weiboFrame.size.height + 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeiboCell *cell = [self dequeueReusableCellWithIdentifier:@"weiboCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.layoutFrame = _modelArr[indexPath.item];
    [self deselectRowAtIndexPath:indexPath animated:YES];//取消选中状态。
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentViewController *comment = [[CommentViewController alloc] init];
    comment.hidesBottomBarWhenPushed = YES;
    WeiboViewLayoutFrame *layoutFrame = _modelArr[indexPath.item];
    comment.weiboFrame = layoutFrame;
    [self.viewController presentViewController:[[MainNavCtrl alloc] initWithRootViewController:comment] animated:YES completion:NULL];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}




@end
