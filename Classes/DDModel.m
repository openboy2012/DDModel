//
//  DDModel.m
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel.h"
#import "DDModelHttpClient.h"
#import "NSDictionary+DDUploadFile.h"
#import "DDCache.h"

#define DDFILE @"fileInfo"

@interface DDModel()

+ (id)getObjectFromReponseString:(NSString *)reponseString
                         failure:(DDResponseFailureBlock)failure;

/**
 *  parse the responseString to JSON object
 */
+ (id)getJSONObjectFromString:(NSString *)responseString
                      failure:(DDResponseFailureBlock)failure __deprecated_msg(" use 'getObjectFromReponseString:failure:' method replace.");

/**
 *  conver JSON object to Model
 *
 *  @param jsonObject json object
 *
 *  @return modol or model array
 */
+ (id)convertJsonToObject:(id)jsonObject;

@end

@implementation DDModel

#pragma mark - DB Cache - Http Handler Methods

+ (void)get:(NSString *)path
     params:(id)params
    showHUD:(BOOL)show
parentViewController:(id)viewController
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
                                id JSON = [self getObjectFromReponseString:cache.content failure:NULL];
                                dbBlock([[self class] convertJsonToObject:JSON]);
                            }
                        }];
    }
    
    [[DDModelHttpClient sharedInstance] showHud:show];
    
    NSDictionary *getParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    AFHTTPRequestOperation *getOperation =
    [[DDModelHttpClient sharedInstance] GET:path
                                 parameters:getParams
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                        
                                        //save the cache
                                        [DDCache cacheWithPath:path parameter:params content:operation.responseString];
                                        
                                        id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                        if (success && JSON){
                                            success([[self class] convertJsonToObject:JSON]);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                        if(failure)
                                            failure(error, [error description]);
                                    }];
    [[DDModelHttpClient sharedInstance] addOperation:getOperation withKey:viewController];
}

+ (void)post:(NSString *)path
      params:(id)params
     showHUD:(BOOL)show
parentViewController:(id)viewController
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
                                id JSON = [self getObjectFromReponseString:cache.content failure:NULL];
                                dbBlock([[self class] convertJsonToObject:JSON]);
                            }
                        }];
    }
    
    [[DDModelHttpClient sharedInstance] showHud:show];
    
    NSDictionary *postParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    AFHTTPRequestOperation *getOperation =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:postParams
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         
                                         //save the cache
                                         [DDCache cacheWithPath:path parameter:params content:operation.responseString];
                                         
                                         id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                         if (success && JSON){
                                             success([[self class] convertJsonToObject:JSON]);
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         if(failure)
                                             failure(error, [error description]);
                                     }];
    [[DDModelHttpClient sharedInstance] addOperation:getOperation withKey:viewController];
}

#pragma mark - HTTP Request Handler Methods

+ (void)get:(NSString *)path
     params:(id)params
    showHUD:(BOOL)show
parentViewController:(id)viewController
    success:(DDResponseSuccessBlock)success
    failure:(DDResponseFailureBlock)failure{
    
    [[DDModelHttpClient sharedInstance] showHud:show];
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    AFHTTPRequestOperation *getOperation =
    [[DDModelHttpClient sharedInstance] GET:path
                                 parameters:params
                                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                        id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                        if (success && JSON)
                                            success([[self class] convertJsonToObject:JSON]);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                        if(failure)
                                            failure(error, [error description]);
                                    }];
    [[DDModelHttpClient sharedInstance] addOperation:getOperation withKey:viewController];
}

+ (void)post:(NSString *)path
      params:(id)params
     showHUD:(BOOL)show
parentViewController:(id)viewController
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure{
    /**
     *  show the hud view
     */
    [[DDModelHttpClient sharedInstance] showHud:show];
    
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    AFHTTPRequestOperation *postOperation =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         /**
                                          *  hide the hud view
                                          */
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         
                                         id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                         
                                         if (success && JSON)
                                             success([[self class] convertJsonToObject:JSON]);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         if(failure)
                                             failure(error, [error description]);
                                     }];
    [[DDModelHttpClient sharedInstance] addOperation:postOperation withKey:viewController];
}

+ (void)post:(NSString *)path
  fileStream:(NSData *)stream
      params:(id)params
    userInfo:(id)userInfo
     showHUD:(BOOL)show
parentViewController:(id)viewController
     success:(DDUploadReponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure{
    
    [[DDModelHttpClient sharedInstance] showHud:show];
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
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                         if (success && JSON)
                                             success(userInfo,[[self class] convertJsonToObject:JSON]);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] showHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                     }];
    uploadOperation.userInfo = userInfo;
    [[DDModelHttpClient sharedInstance] addOperation:uploadOperation withKey:viewController];
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

    if(![[DDModelHttpClient sharedInstance] checkResponseValue:value failure:failure]){
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

+ (void)cancelRequest:(id)viewController{
    [[DDModelHttpClient sharedInstance] cancelOperationWithKey:viewController];
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
    //Compatibility to the jsonNode Method in old version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if([self jsonNode]){
        return [self jsonNode];
    }
#pragma clang diagnostic pop
    return @"NULL";
}

+ (NSDictionary *)parseMappings{
    //Compatibile to the jsonMappings Method in old version
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if([self jsonMappings]){
        return [self jsonMappings];
    }
#pragma clang diagnostic pop
    return nil;
}

+ (id)convertJsonToObject:(id)jsonObject{
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

@implementation DDModel(Deprecated)

+ (NSString *)jsonNode{
    return @"NULL";
}

+ (NSDictionary *)jsonMappings{
    return nil;
}

- (NSDictionary *)propertiesOfSelf{
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
                if([propetyItem isKindOfClass:[DDModel class]]){
                    [list addObject:[propetyItem propertiesOfSelf]];
                }else{
                    if(propetyItem)
                        [list addObject:propetyItem];
                }
            }
            [props setObject:list forKey:propertyName];
        }else if ([propertyValue isKindOfClass:[DDModel class]]){
            [props setObject:[propertyValue propertiesOfSelf] forKey:propertyName];
        }else{
            if(propertyValue)
                [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}

+ (void)post:(NSString *)path params:(id)params postParams:(id)postParams parentView:(id)view success:(DDResponseSuccessBlock)success failure:(DDResponseFailureBlock)failure{
    //depreacted
}

@end
