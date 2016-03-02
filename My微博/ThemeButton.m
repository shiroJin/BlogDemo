//
//  ThemeButton.m
//  My微博
//
//  Created by Macx on 16/1/12.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadImg) name:kThemeChangeNotifiCation object:nil];
    }
    return self;
}

- (void)loadImg {
    
    ThemeManager *manager = [ThemeManager sharedThemeManager];
    UIImage *img = [manager getThemeImg:_buttonName];
    
    [self setImage:img forState:UIControlStateNormal];
}

- (void)setButtonName:(NSString *)buttonName {
    
    if (_buttonName != buttonName) {
        _buttonName = buttonName;
        [self loadImg];
    }
}

@end
