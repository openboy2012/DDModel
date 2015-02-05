//
//  Post.m
//  DDKit
//
//  Created by Diaoshu on 14-12-15.
//  Copyright (c) 2014年 Dejohn Dong. All rights reserved.
//

#import "Post.h"

@implementation Post

/*
 * 对象解析的节点实现
 */
+ (NSString *)parseNode{
    return @"data";
}

/* jsonMapping 实现
 * 使用场景： 
 * 1.返回数据与数据模型不一致时通过映射对应赋值,举例: @{@"id":@"userId"} 返回数据中的id value 会赋值给数据模型的userId
 * 2.对象的嵌套关系，如本例里Post对象嵌套了User对象
 */
+ (NSDictionary *)parseMappings{
    id userHandler = [User mappingWithKey:@"user" mapping:[User parseMappings]];
    NSDictionary *jsonMappings = @{@"user":userHandler};
    return jsonMappings;
}

+ (void)getPostList:(id)params
           parentVC:(id)viewController
            showHUD:(BOOL)show
            success:(DDResponseSuccessBlock)success
            failure:(DDResponseFailureBlock)failure
{
    [[self class] get:@"stream/0/posts/stream/global" params:params showHUD:show parentViewController:viewController success:success failure:failure];
}

@end

@implementation User

+ (NSDictionary *)parseMappings{
    //支持keyPath的方式进行映射对象，可以随意重构数据对象
    return @{@"avatar_image.url":@"avatarImageURLString"};
}

@end