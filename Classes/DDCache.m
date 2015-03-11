//
//  DDCache.m
//  DDModel
//
//  Created by Diaoshu on 15-3-10.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDCache.h"
#import "NSDictionary+DDUploadFile.h"
#import "NSString+md5.h"

@implementation DDCache

+ (void)queryWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
               result:(DBQueryResult)result{
    NSString *queryParameter = [NSString stringWithFormat:@"WHERE parameter = '%@' AND path = '%@';",[[parameter JSONString] md5], [path md5]];
    [[self class] queryFirstItemByCriteria:queryParameter
                                    result:result];
}

- (instancetype)initWithPath:(NSString *)path
                   parameter:(NSDictionary *)parameter
                     content:(NSString *)content{
    self = [super init];
    if(self){
        self.path = [path md5];
        self.content = content;
        self.parameter = [[parameter JSONString] md5];
    }
    return self;
}

+ (void)cacheWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
              content:(NSString *)content{
    [self queryWithPath:path parameter:parameter result:^(id data) {
        DDCache *cache = data;
        if(!cache)
            cache = [[DDCache alloc] initWithPath:path parameter:parameter content:content];
        cache.content = content;
        [cache save];
    }];
}

@end
