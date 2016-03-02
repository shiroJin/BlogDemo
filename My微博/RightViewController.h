//
//  RightViewController.h
//  My微博
//
//  Created by Macx on 16/1/21.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThemeButton;
@interface RightViewController : UIViewController
@property (weak, nonatomic) IBOutlet ThemeButton *writeBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *cameraBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *VideoBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *photoBtn;
- (IBAction)clickAction:(id)sender;


@end
