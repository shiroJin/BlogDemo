//
//  EmotionView.h
//  My微博
//
//  Created by Macx on 16/1/22.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EmotionBlock)(NSString *emotion);

@interface EmotionView : UIView

@property (nonatomic, copy)EmotionBlock emotionBlock;

@end
