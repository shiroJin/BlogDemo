//
//  EmotionView.m
//  My微博
//
//  Created by Macx on 16/1/22.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "EmotionView.h"

#define kRowEmotions 4
#define kColumnEmotions 7
#define kRowSpace 5
#define kColumnSpace 5
#define kPageEmotions (kRowEmotions * kColumnEmotions)
#define kEmotionSize ((kScreenWidth - 8 * kColumnSpace) / kColumnEmotions)

@implementation EmotionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self createMagnifierView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createMagnifierView];
    }
    return self;
}

//返回表情数组
- (NSArray *)getEmotionPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
    NSArray *emotions = [NSArray arrayWithContentsOfFile:path];
    
    return emotions;
}


- (void)drawRect:(CGRect)rect {
    
    NSArray *emotions = [self getEmotionPlist];
    
    //绘制表情
    //页数
    NSInteger pageCount = emotions.count / kPageEmotions;
    if (pageCount % kPageEmotions != 0) {
        pageCount++;
    }
    //行列
    int row = 0, column = 0, count = 0;
    for (int i = 0; i < pageCount; i++) {
        for (int j = 0; j < kPageEmotions; j++) {
            count++;
            row = j / kColumnEmotions;
            column = j % kColumnEmotions;
            
            UIImage *image = [UIImage imageNamed:emotions[i*kPageEmotions + j][@"png"]];
            [image drawInRect:CGRectMake(i*kScreenWidth + column*(kEmotionSize+kColumnSpace) + kColumnSpace, kRowSpace + row*(kEmotionSize+kRowSpace), kEmotionSize, kEmotionSize)];
            
            if (count == emotions.count) {
                break;
            }
        }
    }
}

- (void)createMagnifierView {
    UIImageView *magnifierView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
    magnifierView.frame = CGRectMake(0, 0, magnifierView.width, magnifierView.height);
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((magnifierView.image.size.width - 40) / 2, 12, 40, 40)];
    img.tag = 100;
    [magnifierView addSubview:img];
    magnifierView.hidden = YES;
    
    [self addSubview:magnifierView];
}

#pragma mark - 触摸事件处理

- (void)touchEmotion:(CGPoint)point {
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    NSInteger selectPage = x / kScreenWidth;
    NSInteger selectRow = y / (kEmotionSize+kRowSpace);
    NSInteger selectColumn = (x - selectPage*kScreenWidth) / (kEmotionSize+kColumnSpace);
    
    NSArray *emotions = [self getEmotionPlist];
    UIImageView *selectImg = [self viewWithTag:100];
    selectImg.image = [UIImage imageNamed:emotions[selectPage*kPageEmotions + selectRow*kColumnEmotions + selectColumn][@"png"]];
    selectImg.superview.hidden = NO;
    
    UIImageView *magnifier = (UIImageView *)[selectImg superview];
    magnifier.frame = CGRectMake(selectColumn*(kEmotionSize+kColumnSpace), (selectRow-1)*(kEmotionSize+kRowSpace), magnifier.width, magnifier.height);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    ((UIScrollView *)self.superview).scrollEnabled = NO;
    
    [self touchEmotion:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImageView *selectImg = [self viewWithTag:100];
    selectImg.superview.hidden = YES;
    ((UIScrollView *)self.superview).scrollEnabled = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    //确定表情位置
    NSInteger selectPage = x / kScreenWidth;
    NSInteger selectRow = y / (kEmotionSize+kRowSpace);
    NSInteger selectColumn = (x - selectPage*kScreenWidth) / (kEmotionSize+kColumnSpace);
    selectRow = MAX(0, MIN(kRowEmotions, selectRow));
    selectColumn = MAX(0, MIN(kColumnEmotions, selectColumn));
    
    NSArray *emotions = [self getEmotionPlist];
    
    NSInteger selectInteger = selectPage*kPageEmotions + selectRow*kColumnEmotions + selectColumn;
    //异常处理
    if (selectInteger >= emotions.count) {
        return;
    }
    
    //block 回调
    NSString *emotionName = emotions[selectInteger][@"chs"];
    //安全性检查
    if (!emotionName || [emotionName isKindOfClass:[NSNull class]]) {
        return;
    }
    if (_emotionBlock) {
        _emotionBlock(emotions[selectInteger][@"chs"]);
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIImageView *selectImg = [self viewWithTag:100];
    selectImg.superview.hidden = YES;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchEmotion:point];
}



@end
