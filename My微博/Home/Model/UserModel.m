//
//  UserModel.m
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)setAttributes:(NSDictionary *)jsonDic {
    [super setAttributes:jsonDic];
    
    _userDescription = [jsonDic objectForKey:@"descreption"];
}

@end
