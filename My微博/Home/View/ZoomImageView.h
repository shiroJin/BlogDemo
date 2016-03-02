//
//  ZoomImageView.h
//  84班微博
//
//  Created by Macx on 16/1/19.
//  Copyright © 2016年 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomImageView : UIImageView <NSURLSessionDataDelegate>

@property (copy, nonatomic) NSString *urlString;

@property (assign, nonatomic) BOOL isGif;

@end
