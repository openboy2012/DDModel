//
//  DDCache.m
//  DDModel
//
//  Created by Diaoshu on 15-3-10.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDCache.h"
#import "NSDictionary+DDModel.h"
#import "NSString+DDModel.h"
#import "XMLDictionary.h"

@implementation DDCache

+ (void)queryWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
               result:(DBQueryResult)result{
    NSString *queryParameter = [NSString stringWithFormat:@"WHERE parameter = '%@' AND path = '%@';",[[parameter dd_jsonString] dd_cacheMD5], [path dd_cacheMD5]];
    [[self class] queryFirstItemByCriteria:queryParameter
                                    result:result];
}

- (instancetype)initWithPath:(NSString *)path
                   parameter:(NSDictionary *)parameter
                     content:(id)content{
    self = [super init];
    if(self){
        self.path = [path dd_cacheMD5];
        self.content = [[self class] contentHandler:content];
        self.parameter = [[parameter dd_jsonString] dd_cacheMD5];
    }
    return self;
}

+ (void)cacheWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
              content:(id)content{
    [self queryWithPath:path parameter:parameter result:^(id data) {
        DDCache *cache = data;
        if(!cache)
            cache = [[DDCache alloc] initWithPath:path parameter:parameter content:content];
        cache.content = [self contentHandler:content];
        [cache save];
    }];
}

+ (NSString *)contentHandler:(id)content{
    if([content isKindOfClass:[NSString class]]){
        return content;
    }else if([content isKindOfClass:[NSDictionary class]]){
        return [content dd_jsonString];
    }else if([content isKindOfClass:[NSXMLParser class]]){
        NSDictionary *jsonDict = [NSDictionary dictionaryWithXMLParser:content];
        return [jsonDict dd_jsonString];
    }
    return @"";
}

@end
