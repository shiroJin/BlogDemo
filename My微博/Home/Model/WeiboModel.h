//
//  WeiboModel.h
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface WeiboModel : BaseModel

@property(nonatomic,copy)NSString       *createDate;       //微博创建时间
@property(nonatomic,retain)NSNumber     *weiboId;           //微博ID
@property(nonatomic,copy)NSString       *text;              //微博的内容
@property(nonatomic,copy)NSString       *source;              //微博来源
@property(nonatomic,retain)NSNumber     *favorited;         //是否已收藏
@property(nonatomic,copy)NSString       *thumbnailImage;     //缩略图片地址
@property(nonatomic,copy)NSString       *bmiddlelImage;     //中等尺寸图片地址
@property(nonatomic,copy)NSString       *originalImage;     //原始图片地址
@property(nonatomic,retain)NSDictionary *geo;               //地理信息字段
@property(nonatomic,retain)NSNumber     *repostsCount;      //转发数
@property(nonatomic,retain)NSNumber     *commentsCount;      //评论数
@property(nonatomic, strong)NSArray* pic_urls;    //微博多图的url数组

@property(nonatomic,strong)UserModel *user;   //微博的作者用户
//原微博（被转发的微博Model）
@property(nonatomic,strong)WeiboModel *reWeibo;

@end
