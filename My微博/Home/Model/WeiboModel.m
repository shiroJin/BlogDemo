//
//  WeiboModel.m
//  My微博
//
//  Created by Macx on 16/1/13.
//  Copyright © 2016年 jinquanbin. All rights reserved.
//

#import "WeiboModel.h"

@implementation WeiboModel

-(void)setAttributes:(NSDictionary *)dataDic {
    [super setAttributes:dataDic];
    
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    UserModel *user = [[UserModel alloc] initContentWithDic:userDic];
    self.user = user;
    
    NSDictionary *retweetDic = dataDic[@"retweeted_status"];
    if (retweetDic != nil) {
        
        WeiboModel *reWeibo = [[WeiboModel alloc] initContentWithDic:retweetDic];
        self.reWeibo = reWeibo;
    }

}

- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic
{
    //请求下来的值 ： 属性名
    NSDictionary *mapAtt = @{
                             @"created_at" :@"createDate",
                             @"id":@"weiboId",
                             @"text":@"text",
                             @"source":@"source",
                             @"favorited":@"favorited",
                             @"thumbnail_pic":@"thumbnailImage",
                             @"bmiddle_pic":@"bmiddlelImage",
                             @"original_pic":@"originalImage",
                             @"geo":@"geo",
                             @"reposts_count":@"repostsCount",
                             @"comments_count":@"commentsCount",
                             @"pic_urls" : @"pic_urls"
                             };
    
    return mapAtt;
}

//- (void)setText:(NSString *)text {
//    if (_text != text) {
//        
//        NSString *regex = @"\\[\\w+\\]";
//        NSArray *arr = [text componentsMatchedByRegex:regex];
//        
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
////        NSArray *emotionArr = [NSArray arrayWithContentsOfFile:path];
//        NSArray *emotionArr = [NSArray arrayWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"documents/emotions.plist"]];
//        
//        for (NSString *emotion in arr) {
//            
//            NSString *str = [NSString stringWithFormat:@"value='%@'", emotion];
//#warning notice:format 中一定要放NSString！！！
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:str];
//            NSArray *item = [emotionArr filteredArrayUsingPredicate:predicate];
//            
//            if (item.count > 0) {
//                NSDictionary *dic = item[0];
//                NSString *emotionStr = [dic objectForKey:@"url"];
//                
//                NSString *emotionString = [NSString stringWithFormat:@"<image url = '%@'>", emotionStr];
//                
//                text = [text stringByReplacingOccurrencesOfString:emotion withString:emotionString];
//            }
//        }
//        
//        _text = text;
//    }
//}

@end
