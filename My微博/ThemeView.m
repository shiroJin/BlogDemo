//
//  ThemeView.m
//  My微博
//
//  Created by Macx on 16/1/12.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "ThemeView.h"

@implementation ThemeView

- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadThemeImg) name:kThemeChangeNotifiCation object:nil];
    }
    return self;
}

- (void)loadThemeImg {
    ThemeManager *manager = [ThemeManager sharedThemeManager];
    self.image = [manager getThemeImg:@"mask_navbar"];
}

- (void)setName:(NSString *)name {
    
    if (_name != name) {
        _name = name;
        [self loadThemeImg];
    }
}

@end
