//
//  CommentLayout.h
//  84班微博
//
//  Created by wenyuan on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"
#import "WXLabel.h"

#define kCmmtTextX 50
#define kCmmtTextY 50
#define kLinespace 10

#define kCmmtFontSize 15
#define kCmmtTextLinespace 4

@interface CommentLayout : NSObject

@property (nonatomic, strong)CommentModel *cmmtModel;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGRect textFrame;

@end
