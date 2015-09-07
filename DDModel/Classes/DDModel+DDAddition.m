//
//  DDModel+DDAddition.m
//  DDModel
//
//  Created by DeJohn Dong on 15/6/3.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel+DDAddition.h"
#import "DDModelHttpClient.h"
#import "NSDictionary+DDUploadFile.h"
#import "DDCache.h"
#import "NSString+CacheMD5.h"
#import "DDModelHttpClient+DDAddition.h"
#import "AFHTTPRequestOperationManager+DDAddition.h"

@implementation DDModel (DDAddition)

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
                                id JSON = [cache.content dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
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
                                        
                                        id JSON = [[self class] getObjectFromReponseString:operation.responseString failure:failure];
                                        
                                        //save the cache
                                        [DDCache cacheWithPath:path parameter:params content:JSON];
                                        if (success && JSON){
                                            success([[self class] convertToObject:JSON]);
                                        }
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                        if(failure)
                                            failure(error, [error description], nil);
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
                                id JSON = [cache.content dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
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
                                         
                                         id JSON = [self getObjectFromReponseString:operation.responseString failure:failure];
                                         
                                         //save the cache
                                         [DDCache cacheWithPath:path parameter:params content:operation.responseString];
                                         if (success && JSON){
                                             success([[self class] convertToObject:JSON]);
                                         }
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         if(failure)
                                             failure(error, [error description], nil);
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
                                            success([[self class] convertToObject:JSON]);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                        if(failure)
                                            failure(error, [error description], nil);
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
                                             success([[self class] convertToObject:JSON]);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         if(failure)
                                             failure(error, [error description], nil);
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
                                             success(userInfo,[[self class] convertToObject:JSON]);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] showHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                     }];
    uploadOperation.userInfo = userInfo;
    [[DDModelHttpClient sharedInstance] addOperation:uploadOperation withKey:viewController];
}

+ (void)cancelRequest:(id)viewController{
    [[DDModelHttpClient sharedInstance] cancelOperationWithKey:viewController];
}

@end
