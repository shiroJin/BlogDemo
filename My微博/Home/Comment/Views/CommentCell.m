//
//  CommentCell.m
//  84班微博
//
//  Created by Macx on 16/1/19.
//  Copyright © 2016年 george. All rights reserved.
//

#import "CommentCell.h"
#import "NSDate+TimeAgo.h"
#import "WXLabel.h"
#import "ThemeManager.h"
#import "CommentLayout.h"
//#import "CommentModel.h"
//#import "UserModel.h"

@implementation CommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _commentLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
    _commentLabel.font = [UIFont systemFontOfSize:13];
    _commentLabel.wxLabelDelegate = self;
    _commentLabel.linespace = 8;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:_commentLabel];
}


- (void)setCommentLayout:(CommentLayout *)commentLayout {
    if (_commentLayout != commentLayout) {
        _commentLayout = commentLayout;
        
        NSDictionary *dic = (NSDictionary *)_commentLayout.cmmtModel.user;
        NSString *url = [dic objectForKey:@"profile_image_url"];
        NSString *nickName = [dic objectForKey:@"screen_name"];
        
        [_userIcon sd_setImageWithURL:[NSURL URLWithString:url]];
        _nickName.text = nickName;
        _time.text = [self parseDateStr:_commentLayout.cmmtModel.created_at];
        
        self.commentLabel.text = _commentLayout.cmmtModel.text;
        self.commentLabel.frame = _commentLayout.textFrame;
    }
}

#pragma mark - utils
//Sat Oct 24 14:40:05 +0800 2015
-(NSString *)parseDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *format = @"E M d HH:mm:ss Z yyyy";
    [formatter setDateFormat:format];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    
    NSDate *date = [formatter dateFromString:dateStr];
    return [date timeAgo];
}

#pragma mark - WXLabel Delegate
//返回正则表达式匹配的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    NSString *regEx1 = @"http://([a-zA-Z0-9_.-]+(/)?)+";
    NSString *regEx2 = @"@[\\w.-]{2,30}";
    NSString *regEx3 = @"#[^#]+#";
    
    NSString *regEx =
    [NSString stringWithFormat:@"(%@)|(%@)|(%@)", regEx1, regEx2, regEx3];
    
    return regEx;
}

- (NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    return @"\\[\\w+\\]{1,30}";
}

- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:context]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:context]];
    }
}

////设置链接文本的颜色
//- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
//    
//    return [[ThemeManager sharedThemeManager] getThemeColor:@"Link_color"];
//}

@end
