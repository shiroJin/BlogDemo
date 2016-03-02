//
//  MoreCell.m
//  My微博
//
//  Created by Macx on 16/1/12.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "MoreCell.h"

@implementation MoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged) name:kThemeChangeNotifiCation object:nil];
    
    UIImage *img = [[ThemeManager sharedThemeManager] getThemeImg:@"channel_sectionbar"];
    self.backgroundColor = [UIColor colorWithPatternImage:img];
    
}

- (void)themeChanged {
    UIImage *img = [[ThemeManager sharedThemeManager] getThemeImg:@"channel_sectionbar"];
    self.backgroundColor = [UIColor colorWithPatternImage:img];
}

@end
