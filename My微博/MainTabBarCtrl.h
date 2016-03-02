//
//  MainTabBarCtrl.h
//  My微博
//
//  Created by Macx on 16/1/11.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemeView;
@interface MainTabBarCtrl : UITabBarController

@property (nonatomic, strong)ThemeView *tabbarView;
@property (nonatomic, strong)ThemeView *selectView;
@property (nonatomic, assign)NSInteger *selectIndex;

@end
