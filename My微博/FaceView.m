//
//  FaceView.m
//  My微博
//
//  Created by Macx on 16/1/22.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "FaceView.h"
#import "EmotionView.h"

@implementation FaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.contentSize = CGSizeMake(4 * kScreenWidth, frame.size.height);
        _emotionView = [[EmotionView alloc] initWithFrame:CGRectMake(0, 0, 5 * kScreenWidth, 400)];
        [self addSubview:_emotionView];
        self.scrollEnabled = YES;
        self.pagingEnabled = YES;
    }
    return self;
}

@end
