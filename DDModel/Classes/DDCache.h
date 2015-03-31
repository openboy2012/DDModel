//
//  DDCache.h
//  DDModel
//
//  Created by Diaoshu on 15-3-10.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "SQLitePersistentObject.h"

@interface DDCache : SQLitePersistentObject

@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *parameter;

/**
 *  Query the cache from db
 *
 *  @param path      url path
 *  @param parameter request parameter
 *  @param result    DDCache object
 */
+ (void)queryWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
               result:(DBQueryResult)result;

/**
 *  Initialize a DDCache object
 *
 *  @param path      url
 *  @param parameter request parameter
 *  @param content   should cahced content
 *
 *  @return DDCache object
 */
- (instancetype)initWithPath:(NSString *)path
                   parameter:(NSDictionary *)parameter
                     content:(NSString *)content;

/**
 *  save a DDCache Object
 *
 *  @param path      url
 *  @param parameter request parameter
 *  @param content   should cahced content
 */
+ (void)cacheWithPath:(NSString *)path
            parameter:(NSDictionary *)parameter
              content:(NSString *)content;

@end
