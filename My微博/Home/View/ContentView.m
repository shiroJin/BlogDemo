//
//  ContentView.m
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ContentView.h"
#import "WeiboModel.h"
#import "WeiboViewLayoutFrame.h"
#import "WXLabel.h"
#import "ZoomImageView.h"

@implementation ContentView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _textLabel = [[WXLabel alloc] init];
    _reTextLabel = [[WXLabel alloc] init];
    _backImgView = [[UIView alloc] init];
    _imgArr = [NSMutableArray array];
    _reImgArr = [NSMutableArray array];
    
    for (int i = 0; i < 9; i++) {
        ZoomImageView *image = [[ZoomImageView alloc] init];
        image.frame = CGRectZero;
        [_imgArr addObject:image];
        [self addSubview:image];
    }
    
    for (int i = 0; i < 9; i++) {
        ZoomImageView *reImage = [[ZoomImageView alloc] init];
        reImage.frame = CGRectZero;
        [_reImgArr addObject:reImage];
        [_backImgView addSubview:reImage];
    }
    
    _textLabel.linespace = 10;
    _reTextLabel.linespace = 8;
    _textLabel.font = [UIFont systemFontOfSize:15];
    _reTextLabel.font = [UIFont systemFontOfSize:13];
    _textLabel.numberOfLines = 0;
    _reTextLabel.numberOfLines = 0;
    _backImgView.backgroundColor = [UIColor whiteColor];
    
    _textLabel.wxLabelDelegate = self;
    _reTextLabel.wxLabelDelegate = self;
    
    [_backImgView addSubview:_reTextLabel];
    [self addSubview:_textLabel];
    [self addSubview:_backImgView];
}

- (void)setWeiboModel:(WeiboModel *)weiboModel {
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        for (int i = 0; i < 9; i++) {
            ZoomImageView *imgView = self.imgArr[i];
            ZoomImageView *reImgView = self.reImgArr[i];
            imgView.frame = CGRectZero;
            reImgView.frame = CGRectZero;
        }
        
        //retext
        NSString *text;
        if (_weiboModel.reWeibo != nil) {
            NSString *userName = [NSString stringWithFormat:@"@%@:", _weiboModel.reWeibo.user.screen_name];
            text = [userName stringByAppendingString:_weiboModel.reWeibo.text];
        }

        _reTextLabel.text = text;
        _textLabel.text = _weiboModel.text;
        
        WeiboViewLayoutFrame *layout = [[WeiboViewLayoutFrame alloc] init];
        [layout setWeiboModel:weiboModel];
        
        self.frame = layout.weiboFrame;
        _textLabel.frame = layout.textFrame;
        _reTextLabel.frame = layout.reTextFrame;

        for (int i = 0; i < self.weiboModel.pic_urls.count; i++) {
            ZoomImageView *imgView = self.imgArr[i];
            NSString *imgUrlStr = layout.weiboModel.pic_urls[i][@"thumbnail_pic"];
            imgView.frame = [layout.imgFrameArr[i] CGRectValue];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
            
            NSMutableString *url = [NSMutableString stringWithString:imgUrlStr];
            NSRange range = [url rangeOfString:@"thumbnail"];
            [url replaceCharactersInRange:range withString:@"large"];
            imgView.urlString = url;
            
            NSString *str = [imgView.urlString pathExtension];
            if ([str isEqualToString:@"gif"]) {
                imgView.isGif = YES;
            }else {
                imgView.isGif = NO;
            }

        }
        
        for (int i = 0; i < self.weiboModel.reWeibo.pic_urls.count; i++) {
            ZoomImageView *imgView = self.reImgArr[i];
            NSString *imgUrlStr = layout.weiboModel.reWeibo.pic_urls[i][@"thumbnail_pic"];
            imgView.frame = [layout.reImgFrameArr[i] CGRectValue];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
            
            NSMutableString *url = [NSMutableString stringWithString:imgUrlStr];
            NSRange range = [url rangeOfString:@"thumbnail"];
            [url replaceCharactersInRange:range withString:@"large"];
            imgView.urlString = url;
            
            NSString *str = [imgView.urlString pathExtension];
            if ([str isEqualToString:@"gif"]) {
                imgView.isGif = YES;
            }else {
                imgView.isGif = NO;
            }
        }
//        self.frame = layout.weiboFrame;
        _backImgView.frame = layout.bgImgFrame;
    }
}

- (NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    return @"\\[\\w+\\]";
}

- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    NSString *regEx1 = @"http://([a-zA-Z0-9_.-]+(/)?)+";
    NSString *regEx2 = @"@[\\w.-]{2,30}";
    NSString *regEx3 = @"#[^#]+#";
    
    NSString *regEx =
    [NSString stringWithFormat:@"(%@)|(%@)|(%@)", regEx1, regEx2, regEx3];
    
    return regEx;
}

//设置链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [UIColor orangeColor];
}


@end
