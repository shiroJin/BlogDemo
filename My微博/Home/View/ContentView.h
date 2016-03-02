//
//  ContentView.h
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
@class WeiboModel;
@interface ContentView : UIView <WXLabelDelegate>

@property (strong, nonatomic)WXLabel *textLabel;
@property (strong, nonatomic)WXLabel *reTextLabel;

@property(nonatomic, strong, readonly)NSMutableArray *imgArr;       //微博多图数组
@property(nonatomic, strong, readonly)NSMutableArray *reImgArr;//转发微博多图数组

@property (strong, nonatomic)UIView *backImgView;

@property (strong, nonatomic)WeiboModel *weiboModel;

@end
