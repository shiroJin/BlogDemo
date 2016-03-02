//
//  WeiboViewLayoutFrame.m
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeiboViewLayoutFrame.h"
#import "WXLabel.h"

#define kImageHeight 50
#define kImgSpace 5

@interface WeiboViewLayoutFrame ()
{
    CGFloat imgWidth;
}

@end

@implementation WeiboViewLayoutFrame
- (void)setWeiboModel:(WeiboModel *)weiboModel {
    
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        _imgFrameArr = [NSMutableArray array];
        _reImgFrameArr = [NSMutableArray array];
        for (int i=0; i<9; i++) {
            [_imgFrameArr addObject:[NSValue valueWithCGRect:CGRectZero]];
            [_reImgFrameArr addObject:[NSValue valueWithCGRect:CGRectZero]];
        }

        [self layoutFrame];
    }
    
}

//根据微博Model中的数据，计算每一个微博子视图的frame
- (void)layoutFrame {
    
    //weiboFrame 预设值
    self.weiboFrame = CGRectMake(10, 70, kScreenWidth - 20, 0);
    
    //weibo视图的高度
    
    //计算文本高度
    CGFloat textWidth = CGRectGetWidth(self.weiboFrame) - 20;
    
    NSString *text = self.weiboModel.text;
    CGFloat textHeight = [WXLabel getTextHeight:15 width:textWidth text:text linespace:10];
    
    self.textFrame = CGRectMake(10, 0, textWidth, textHeight);
    
//#warning 是否在有原微博的情况下，要显示微博的图片
    //原微博的图片
    int row = 0, column = 0;
    
    CGFloat imgX = CGRectGetMinX(self.textFrame);
    CGFloat imgY = CGRectGetMaxY(self.textFrame);
    imgWidth = (self.textFrame.size.width - 2*kImgSpace) / 3;//计算单张图片的高度
    CGRect imageFrame = CGRectZero;
    for (int i = 0; i < _weiboModel.pic_urls.count; i++) {
        row = i / 3;
        column = i % 3;
        imageFrame = CGRectMake(imgX + column * (imgWidth+kImgSpace), imgY + row * (imgWidth+kImgSpace), imgWidth, imgWidth);
        [self.imgFrameArr replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:imageFrame]];
    }
    
    //转发微博的高度
    if (self.weiboModel.reWeibo != nil) {
        
        //计算retext的高度
        CGFloat retextWidth = CGRectGetWidth(self.textFrame);
        
        NSString *retext;
        if (_weiboModel.reWeibo != nil) {
            NSString *userName = [NSString stringWithFormat:@"@%@:", _weiboModel.reWeibo.user.screen_name];
            retext = [userName stringByAppendingString:_weiboModel.reWeibo.text];
        }
        
        CGFloat retextHeight = [WXLabel getTextHeight:13 width:retextWidth text:retext linespace:8];
        
        self.reTextFrame = CGRectMake(0, 10, retextWidth, retextHeight);
        
        //计算转发微博的图片
        NSString *image = self.weiboModel.reWeibo.thumbnailImage;

        //多图大小。
        int row = 0, column = 0;
        
        CGFloat imgX = CGRectGetMinX(self.reTextFrame);
        CGFloat imgY = CGRectGetMaxY(self.reTextFrame);
        imgWidth = (self.reTextFrame.size.width - 2*kImgSpace) / 3;
        CGRect reImageFrame = CGRectZero;
        for (int i = 0; i < _weiboModel.reWeibo.pic_urls.count; i++) {
            row = i / 3;
            column = i % 3;
            reImageFrame = CGRectMake(imgX + column * (imgWidth+kImgSpace), imgY + row * (imgWidth+kImgSpace), imgWidth, imgWidth);
            [self.reImgFrameArr replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:reImageFrame]];
        }
        
        //转发微博的背景高度
        NSInteger line = (_weiboModel.pic_urls.count + 2) / 3;
        CGFloat imgsHeight = line * imgWidth + MAX(0, (line-1)) * imgWidth;
        
        NSInteger reline = (_weiboModel.reWeibo.pic_urls.count + 2) / 3;
        CGFloat reImgsHeight = reline*imgWidth + MAX(0, (line-1)) * imgWidth;
        
        CGFloat bgX = CGRectGetMinX(self.textFrame);
        CGFloat bgY = CGRectGetMaxY(self.textFrame) + imgsHeight;
        CGFloat bgWidth = CGRectGetWidth(self.reTextFrame);
        CGFloat bgHeight = CGRectGetHeight(self.reTextFrame) + 10;
        
        if (image != nil) {
            bgHeight += reImgsHeight + 10;
        }
        
        self.bgImgFrame = CGRectMake(bgX, bgY, bgWidth, bgHeight);
    }

    //微博视图的高度
    NSInteger line = (_weiboModel.pic_urls.count + 2) / 3;
    CGFloat imgsHeight = line * imgWidth + MAX((line-1), 0) * kImgSpace;
    
    CGRect frame = self.weiboFrame;
    frame.size.height = self.textFrame.size.height + imgsHeight + self.bgImgFrame.size.height + 10;
    
    self.weiboFrame = frame;
}

- (void)_setAttribute {
    
}
@end
