//
//  WeiboViewLayoutFrame.h
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"

@interface WeiboViewLayoutFrame : NSObject

/**
 1、计算微博view各个视图的frame，准确来说是主要是高度
 2、weiboModel来计算
 */

@property (nonatomic, strong) WeiboModel *weiboModel;

//微博内容
@property (nonatomic, assign) CGRect textFrame;
//微博图片
//@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, copy)NSMutableArray *imgFrameArr;
//原微博
@property (nonatomic, assign) CGRect reTextFrame;

//@property (nonatomic, assign) CGRect reImageFrame;
@property (copy, nonatomic)NSMutableArray *reImgFrameArr;

//原微博的背景
@property (nonatomic, assign)CGRect bgImgFrame;

//整个微博的frame
@property (nonatomic, assign) CGRect weiboFrame;


@end
