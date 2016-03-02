//
//  CommentLayout.m
//  84班微博
//
//  Created by wenyuan on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "CommentLayout.h"

@implementation CommentLayout

- (void)setCmmtModel:(CommentModel *)cmmtModel
{
    if (_cmmtModel != cmmtModel) {
        _cmmtModel = cmmtModel;
        
        [self layoutFrame];
    }
}

- (void)layoutFrame
{
    CGFloat minitrim = kLinespace / 2;
    CGFloat textWidth = kScreenWidth - kCmmtTextX - kLinespace * 2 - minitrim;
    CGFloat textHeight = [WXLabel getTextHeight:kCmmtFontSize width:textWidth text:_cmmtModel.text linespace:kCmmtTextLinespace];
    self.textFrame = CGRectMake(kCmmtTextX + kLinespace + minitrim, kCmmtTextY +kLinespace, textWidth, textHeight);
    self.cellHeight = CGRectGetMaxY(self.textFrame) + kLinespace;
}

@end
