//
//  ZoomImageView.m
//  84班微博
//
//  Created by Macx on 16/1/19.
//  Copyright © 2016年 george. All rights reserved.
//

#import "ZoomImageView.h"
#import "SDPieProgressView.h"
#import <ImageIO/ImageIO.h>
@implementation ZoomImageView {
    
    UIImageView *_fullImageView;
    UIScrollView *_scrollView;
    SDPieProgressView *_progressView;
    //网络请求
    NSMutableData *_data;
    NSURLSession *_session;
    NSURLSessionDataTask *_task;
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)_createView {
    _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
    [_scrollView addGestureRecognizer:tap];
    
    //图片视图
    _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    _fullImageView.image = self.image;
    [_scrollView addSubview:_fullImageView];
    
    
    //加载进度条
    _progressView = [[SDPieProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _progressView.center = self.window.center;
    [_scrollView addSubview:_progressView];
    _progressView.hidden = YES;
}

- (void)zoomIn {
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self _createView];

    CGRect rect = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = rect;
    
    [UIView animateWithDuration:0.5 animations:^{
        _fullImageView.frame = _scrollView.bounds;
    } completion:^(BOOL finished) {
        _progressView.hidden = NO;
        _data = [[NSMutableData alloc] init];
        
        if (self.urlString.length > 0) {
            NSURL *url = [NSURL URLWithString:self.urlString];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            _task = [_session dataTaskWithRequest:request];
            
            [_task resume];
        }
    }];
    
   }

- (void)zoomOut {
    [UIApplication sharedApplication].statusBarHidden = NO;
    [_task cancel];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = rect;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
    }];
}

#pragma mark - url session delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [_data appendData:data];
    
    _progressView.progress = (CGFloat)dataTask.countOfBytesReceived / dataTask.countOfBytesExpectedToReceive;
    
    if (dataTask.countOfBytesReceived == dataTask.countOfBytesExpectedToReceive) {
        UIImage *image = [UIImage imageWithData:_data];
        _fullImageView.image = image;
        
        CGFloat height = image.size.height / image.size.width * kScreenWidth;
        if (height < kScreenHeight) {
            _fullImageView.top = (kScreenHeight - height) / 2;
        }
        _fullImageView.height = height;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
        
        if (self.isGif) {
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(_data), NULL);
            NSTimeInterval duration = 0.0f;
            
            size_t count = CGImageSourceGetCount(source);
            NSMutableArray *images = [NSMutableArray array];
            for (size_t i = 0; i < count; i++) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
                UIImage *imageUI = [UIImage imageWithCGImage:image];
                duration += 0.1;
                CGImageRelease(image);
                [images addObject:imageUI];
            }
            UIImage *imageGIF = [UIImage animatedImageWithImages:images duration:duration];
            _fullImageView.image = imageGIF;
            CFRelease(source);
        }
        
        _progressView.hidden = YES;
    }
    
}


@end
