//
//  DDModel.m
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel.h"
#import "DDModelHttpClient.h"
#import "NSDictionary+DDModel.h"
#import "DDCache.h"
#import "NSString+DDModel.h"
#import "NSURLSessionTask+DDModel.h"

#define DDFILE @"fileInfo"

@implementation DDModel

#pragma mark - DB Cache - Http Handler Methods

+ (NSURLSessionDataTask *)get:(NSString *)path
                       params:(id)params
                    dbSuccess:(DDSQLiteBlock)dbBlock
                      success:(DDResponseSuccessBlock)success
                      failure:(DDResponseFailureBlock)failure
{
    if(dbBlock){
        //query the cache
        [DDCache queryWithPath:path
                     parameter:params
                        result:^(id data) {
                            DDCache *cache = data;
                            if(cache){
                                id JSON = [cache.content dd_dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
                            }
                        }];
    }
    
    
    NSDictionary *getParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    NSURLSessionDataTask *getTask =
    [[DDModelHttpClient sharedInstance] GET:path
                                 parameters:getParams
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        
                                        id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                        //save the cache
                                        [DDCache cacheWithPath:path parameter:params content:JSON];
                                        if (success && JSON){
                                            success([[self class] convertToObject:JSON]);
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        if(failure)
                                            failure(error, [error description], nil);
                                    }];
    return getTask;
}

+ (NSURLSessionDataTask *)post:(NSString *)path
                        params:(id)params
                     dbSuccess:(DDSQLiteBlock)dbBlock
                       success:(DDResponseSuccessBlock)success
                       failure:(DDResponseFailureBlock)failure
{
    
    if(dbBlock){
        //query the cache
        [DDCache queryWithPath:path
                     parameter:params
                        result:^(id data) {
                            DDCache *cache = data;
                            if([cache.content length] > 1){
                                id JSON = [cache.content dd_dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
                            }
                        }];
    }
    
    
    NSDictionary *postParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    NSURLSessionDataTask *postTask =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:postParams
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                         
                                         //save the cache
                                         [DDCache cacheWithPath:path parameter:params content:JSON];
                                         if (success && JSON){
                                             success([[self class] convertToObject:JSON]);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         if(failure)
                                             failure(error, [error description], nil);
                                     }];
    return postTask;
}

#pragma mark - HTTP Request Handler Methods

+ (NSURLSessionDataTask *)get:(NSString *)path
                       params:(id)params
                      success:(DDResponseSuccessBlock)success
                      failure:(DDResponseFailureBlock)failure{
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    NSURLSessionDataTask *getTask =
    [[DDModelHttpClient sharedInstance] GET:path
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                        if (success && JSON){
                                            success([[self class] convertToObject:JSON]);
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        if(failure)
                                            failure(error, [error description], nil);
                                    }];
    return getTask;
}

+ (NSURLSessionDataTask *)post:(NSString *)path
      params:(id)params
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure {
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    NSURLSessionDataTask *postTask =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                         if (success && JSON){
                                             success([[self class] convertToObject:JSON]);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         if(failure)
                                             failure(error, [error description], nil);
                                     }];
    return postTask;
}

+ (NSURLSessionDataTask *)post:(NSString *)path
                    fileStream:(NSData *)stream
                        params:(id)params
                      userInfo:(id)userInfo
                       success:(DDUploadReponseSuccessBlock)success
                       failure:(DDResponseFailureBlock)failure {
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    
    NSURLSessionUploadTask *uploadTask = (NSURLSessionUploadTask *)
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                       NSDictionary *uploadInfo = userInfo[DDFILE];
                       if(!uploadInfo)
                           uploadInfo = [NSDictionary dd_defaultFile];
                       [formData appendPartWithFileData:stream
                                                   name:uploadInfo.name
                                               fileName:uploadInfo.fileName
                                               mimeType:uploadInfo.mimeType];
                   }
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                         if (success && JSON)
                                             success([(NSURLSessionUploadTask *)task userInfo],[[self class] convertToObject:JSON]);
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         
                                     }];
    uploadTask.userInfo = userInfo;
    return uploadTask;
}

#pragma mark -

+ (id)getObjectFromReponseObject:(id)responseObject failure:(DDResponseFailureBlock)failure{
    NSDictionary *value = nil;
    if([responseObject isKindOfClass:[NSDictionary class]] && [DDModelHttpClient sharedInstance].type == DDResponseJSON){
        value = responseObject;
    }else if([responseObject isKindOfClass:[NSXMLParser class]] && [DDModelHttpClient sharedInstance].type == DDResponseXML){
        value = [NSDictionary dictionaryWithXMLParser:responseObject];
    }else{
        NSString *responseString  = nil;
        if([responseObject isKindOfClass:[NSData class]]){
            responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }else{
            responseString = responseObject;
        }
        /**
         *  decode if you should decode responseString
         */
        responseString = [[DDModelHttpClient sharedInstance] responseStringHandler:responseString];
        
        NSError *decodeError = nil;
        
        NSData *decodeData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        
        
        if([DDModelHttpClient sharedInstance].type == DDResponseXML){
            value = [NSDictionary dictionaryWithXMLData:decodeData];
        }else
            value = [NSJSONSerialization JSONObjectWithData:decodeData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&decodeError];
        
    }
    if(![[DDModelHttpClient sharedInstance] checkResponseValue:value failure:failure]){
        return nil;
    }
    return value?:@{};
}

#pragma mark - Propery Methods

- (NSDictionary *)propertiesOfObject{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id propertyValue = [self valueForKey:propertyName];
        if ([propertyValue isKindOfClass:[NSArray class]]){
            NSMutableArray *list = [NSMutableArray arrayWithCapacity:0];
            for (id propetyItem in propertyValue) {
                if([[propetyItem class] isSubclassOfClass:[DDModel class]]){
                    [list addObject:[propetyItem propertiesOfObject]];
                }else{
                    if(propetyItem)
                        [list addObject:propetyItem];
                }
            }
            [props setObject:list forKey:propertyName];
        }else if ([[propertyValue class] isSubclassOfClass:[DDModel class]]){
            [props setObject:[propertyValue propertiesOfObject] forKey:propertyName];
        }else{
            if(propertyValue)
                [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

#pragma mark - Object Mapping Handle Methods

+ (NSString *)parseNode{
    return @"NULL";
}

+ (NSDictionary *)parseMappings{
    return nil;
}

+ (id)convertToObject:(id)jsonObject{
    if(jsonObject == nil){
        return nil;
    }
    id data = nil;
    if([jsonObject isKindOfClass:[NSArray class]]){
        data = jsonObject;
    }else{
        if ([[[self class] parseNode] isEqualToString:@"NULL"]) {
            data = jsonObject;
        }else{
            data = [jsonObject objectForKey:[[self class] parseNode]];
        }
    }
    if(data == nil){
        return nil;
    }
    return [[self class] objectFromJSONObject:data mapping:[[self class] parseMappings]];
}


@end

@implementation DDModel(DDKit)

+ (NSArray *)getPropertyNames{
    NSMutableArray *propertiesArray = [[NSMutableArray alloc] initWithCapacity:0];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        [propertiesArray addObject:propertyName];
    }
    return propertiesArray;
}

@end
