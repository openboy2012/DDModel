//
//  DDModel.m
//  DDModel
//
//  Created by DeJohn Dong on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel.h"
#import "DDModelHttpClient.h"
#import "NSDictionary+DDUploadFile.h"
#import "DDCache.h"
#import "NSString+CacheMD5.h"
#import "DDModelHttpClient+DDAddition.h"
#import "AFHTTPRequestOperationManager+DDAddition.h"

@interface DDModel()

@end

@implementation DDModel

#pragma mark - DB Cache - Http Handler Methods

+ (AFHTTPRequestOperation *)get:(NSString *)path
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
                                id JSON = [cache.content dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
                            }
                        }];
    }
    
    NSDictionary *getParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    
    return [[DDModelHttpClient sharedInstance] GET:path
                                        parameters:getParams
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               
                                               id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                               
                                               //save the cache
                                               [DDCache cacheWithPath:path parameter:params content:JSON];
                                               if (success && JSON){
                                                   success([[self class] convertToObject:JSON]);
                                               }
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               if(failure)
                                                   failure(error, [error description], nil);
                                           }];
}

+ (AFHTTPRequestOperation *)post:(NSString *)path
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
                                id JSON = [cache.content dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
                            }
                        }];
    }
    
    NSDictionary *postParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    AFHTTPRequestOperation *postOperation =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:postParams
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                         
                                         //save the cache
                                         [DDCache cacheWithPath:path parameter:params content:operation.responseString];
                                         if (success && JSON){
                                             success([[self class] convertToObject:JSON]);
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if(failure)
                                             failure(error, [error description], nil);
                                     }];
    return postOperation;
}

#pragma mark - HTTP Request Handler Methods

+ (AFHTTPRequestOperation *)get:(NSString *)path
                         params:(id)params
                        success:(DDResponseSuccessBlock)success
                        failure:(DDResponseFailureBlock)failure{
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    return [[DDModelHttpClient sharedInstance] GET:path
                                        parameters:params
                                           success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                               id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                               if (success && JSON)
                                                   success([[self class] convertToObject:JSON]);
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               if(failure)
                                                   failure(error, [error description], nil);
                                           }];
}

+ (AFHTTPRequestOperation *)post:(NSString *)path
                          params:(id)params
                         success:(DDResponseSuccessBlock)success
                         failure:(DDResponseFailureBlock)failure{
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    return [[DDModelHttpClient sharedInstance] POST:path
                                         parameters:params
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                                
                                                if (success && JSON)
                                                    success([[self class] convertToObject:JSON]);
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                if(failure)
                                                    failure(error, [error description], nil);
                                            }];
}

+ (AFHTTPRequestOperation *)post:(NSString *)path
                      fileStream:(NSData *)stream
                          params:(id)params
                        userInfo:(id)userInfo
                         success:(DDUploadReponseSuccessBlock)success
                         failure:(DDResponseFailureBlock)failure{
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    
    AFHTTPRequestOperation *uploadOperation =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                       NSDictionary *uploadInfo = userInfo[DDFILE];
                       if(!uploadInfo)
                           uploadInfo = [NSDictionary defaultFile];
                       [formData appendPartWithFileData:stream name:uploadInfo.name fileName:uploadInfo.fileName mimeType:uploadInfo.mimeType];
                   }
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                         if (success && JSON)
                                             success(userInfo,[[self class] convertToObject:JSON]);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     }];
    uploadOperation.userInfo = userInfo;
    return uploadOperation;
}

+ (AFHTTPRequestOperation *)post:(NSString *)path
                          params:(id)params
                     moreSuccess:(DDResponseSuccessMoreBlock)moreSuccess
                         failure:(DDResponseFailureBlock)failure{
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    return [[DDModelHttpClient sharedInstance] POST:path
                                         parameters:params
                                            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                                
                                                if (moreSuccess && JSON)
                                                    moreSuccess(JSON, [[self class] convertToObject:JSON]);
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                if(failure)
                                                    failure(error, [error description], nil);
                                            }];
}

#pragma mark - 

+ (id)getObjectFromReponseString:(NSString *)responseString failure:(DDResponseFailureBlock)failure{
    /**
     *  decode if you should decode responseString
     */
    responseString = [[DDModelHttpClient sharedInstance] responseStringHandler:responseString];
    
    NSError *decodeError = nil;
    NSDictionary *value = nil;
    
    NSData *decodeData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    if([DDModelHttpClient sharedInstance].type == DDResponseXML){
        value = [NSDictionary dictionaryWithXMLData:decodeData];
    }else
        value = [NSJSONSerialization JSONObjectWithData:decodeData
                                                options:NSJSONReadingAllowFragments
                                                  error:&decodeError];

    if(![[DDModelHttpClient sharedInstance] checkResponseValue:value failure:failure])
        //check the failure response callback status
    {
        if([DDModelHttpClient sharedInstance].isFailureResponseCallback && failure){
            NSInteger responseCode = [value[[DDModelHttpClient sharedInstance].resultKey?:@"resultCode"] integerValue];
            NSString *message = value[[DDModelHttpClient sharedInstance].descKey?:@"resultDesc"];
            NSError *error = [NSError errorWithDomain:[DDModelHttpClient sharedInstance].baseURL.host
                                                 code:responseCode
                                             userInfo:nil];
            id data = [[self class] convertToObject:value];
            failure(error, message, data);
        }
        return nil;
    }
    return value?:@{};
}

+ (id)getJSONObjectFromString:(NSString *)responseString failure:(DDResponseFailureBlock)failure{
    
    /**
     *  decode if you should decode responseString
     */
    responseString = [[DDModelHttpClient sharedInstance] responseStringHandler:responseString];
    
    NSError *decodeError = nil;
    NSData *decodeData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonValue = [NSJSONSerialization JSONObjectWithData:decodeData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&decodeError];
    if(![[DDModelHttpClient sharedInstance] checkResponseValue:jsonValue failure:failure]){
        return nil;
    }
    return jsonValue?:@{};
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

+ (id)convertToObject:(id)dictObject{
    if(dictObject == nil){
        return nil;
    }
    id data = nil;
    if([dictObject isKindOfClass:[NSArray class]]){
        data = dictObject;
    }else{
        if ([[[self class] parseNode] isEqualToString:@"NULL"]) {
            data = dictObject;
        }else{
            data = [dictObject valueForKeyPath:[[self class] parseNode]];
        }
    }
    if(data == nil){
        return nil;
    }
    return [[self class] objectFromJSONObject:data mapping:[[self class] parseMappings]];
}

@end
