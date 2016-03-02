//
//  UIView+viewController.m
//  My微博
//
//  Created by Macx on 16/1/20.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "UIView+viewController.h"

@implementation UIView (viewController)

-(UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
    }
    
    return nil;
}

@end
