//
//  WeiboCell.m
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeiboCell.h"
#import "ContentView.h"
#import "NSDate+TimeAgo.h"

@implementation WeiboCell

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_layoutFrame != nil) {
        UserModel *user = _layoutFrame.weiboModel.user;
        
        NSURL *iconURL = [NSURL URLWithString:user.profile_image_url];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = _userIcon.bounds.size.width / 2;
        [_userIcon sd_setImageWithURL:iconURL];
        
        _nickName.text = user.screen_name;
        _time.text = [self parseDateStr:_layoutFrame.weiboModel.createDate];
        _resource.text = [self parseWeiboSource:_layoutFrame.weiboModel.source];
        
        [_repost setTitle:[NSString stringWithFormat:@"转发%@", _layoutFrame.weiboModel.repostsCount] forState:UIControlStateNormal];
        [_comment setTitle:[NSString stringWithFormat:@"评论%@", _layoutFrame.weiboModel.commentsCount] forState:UIControlStateNormal];
        [_favour setTitle:[NSString stringWithFormat:@"赞%@", _layoutFrame.weiboModel.favorited] forState:UIControlStateNormal];
        
        _weiboContent.weiboModel = _layoutFrame.weiboModel;
        
    }
}

- (void)setLayoutFrame:(WeiboViewLayoutFrame *)layoutFrame {
    if (_layoutFrame != layoutFrame) {
        _layoutFrame = layoutFrame;
        
        [self layoutSubviews];
    }
}

-(NSString *)parseWeiboSource:(NSString *)sourceStr
{
    NSUInteger start = [sourceStr rangeOfString:@">"].location;
    NSUInteger end = [sourceStr rangeOfString:@"<" options:NSBackwardsSearch].location;
    
    if (start != NSNotFound && end != NSNotFound) {
        return [sourceStr substringWithRange:NSMakeRange(start+1, end-start-1)];
    }else{
        return sourceStr;
    }
}

-(NSString *)parseDateStr:(NSString *)dateStr
{
    //创建格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //日期的格式
    NSString *format = @"E M d HH:mm:ss Z yyyy";
    [formatter setDateFormat:format];
    
    //设置本地化时间
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    
    NSDate *date = [formatter dateFromString:dateStr];
    return [date timeAgo];
}



- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
