//
//  BaseViewController.h
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)showSuccessHUD:(NSString *)title withDelayHideTime:(NSTimeInterval)delay;
- (void)showFailHUD:(NSString *)title withDelayTime:(NSTimeInterval)delay;

@end
