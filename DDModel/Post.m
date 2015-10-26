//
//  Post.m
//  DDKit
//
//  Created by DeJohn Dong on 14-12-15.
//  Copyright (c) 2014年 DDKit. All rights reserved.
//

#import "Post.h"
#import "DDModel+DDAddition.h"

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
    /**
     *  in [mappingWithKey:mappings:] method, key is your defined property key;
     *  在'mappingWithKey:mapping:'中的key值是您定义的属性名名称,所以JSON字符串中的Value会映射给该属性字段；
     */
    id userHandler = [User mappingWithKey:@"user" mapping:[User parseMappings]];
    /**
     *  this 'user' key is the JSON String's Key
     *  这个字典中的'user' key值就是 JSON 字符串中的 user key;
     */
    NSDictionary *jsonMappings = @{@"user":userHandler};
    
    /**
     *  所以整个JSON的映射关系就是把JSON字符串的User内容映射给我定义属性的user属性里，内部递归的关系按照user的parseMapping执行
     */
    return jsonMappings;
}

+ (void)getPostList:(id)params
           parentVC:(id)viewController
            showHUD:(BOOL)show
            success:(DDResponseSuccessBlock)success
            failure:(DDResponsesFailureBlock)failure
{
    [[self class] get:@"stream/0/posts/stream/global" params:params showHUD:show parentViewController:viewController  successBlock:success failureBlock:failure];
}

@end

@implementation User

+ (NSDictionary *)parseMappings{
    //支持keyPath的方式进行映射对象，可以随意重构数据对象
    return @{@"avatar_image.url":@"avatarImageURLString"};
}

@end

@implementation Station

+ (NSString *)parseNode{
    return @"Item";
}

+ (NSDictionary *)parseMappings{
    NSDictionary *mappings = @{@"StationID":@"id",
                               @"StationName":@"name",
                               @"StationDescription":@"desc"};
    return mappings;
}

+ (void)getStationList:(id)params
              parentVC:(id)viewController
               showHUD:(BOOL)show
             dbSuccess:(DDSQLiteBlock)dbResult
               success:(DDResponseSuccessBlock)success
               failure:(DDResponsesFailureBlock)failure{
    [[self class] get:@"index.php"  params:params showHUD:show parentViewController:params dbSuccess:dbResult successBlock:success failureBlock:failure];
}

@end


@implementation BESTItemList


@end

@implementation BESTItemListRoot

+ (NSString *)parseNode{
    return @"data";
}

+ (NSDictionary *)parseMappings{
    id handlerItemList = [BESTItemList mappingWithKey:@"list" mapping:[BESTItemList parseMappings]];
    NSDictionary *mappings = @{@"list":handlerItemList};
    return mappings;
}

+ (void)getItemList:(id)params
            showHUD:(BOOL)show
parentViewController:(id)viewController
            success:(DDResponseSuccessBlock)success
            failure:(DDResponsesFailureBlock)failure{
    
    [[self class] post:@"/v1/search/list" params:params showHUD:show parentViewController:viewController successBlock:success failureBlock:failure];
    
}

@end