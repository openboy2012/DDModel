//
//  DDModel+DDAddition.m
//  DDModel
//
//  Created by DeJohn Dong on 15/6/3.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel+DDAddition.h"
#import "DDModelHttpClient.h"
#import "NSDictionary+DDModel.h"
#import "DDCache.h"
#import "NSString+DDModel.h"
#import "DDModelHttpClient+DDAddition.h"
#import "NSURLSessionTask+DDModel.h"

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
                                id JSON = [cache.content dd_dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
                            }
                        }];
    }
    
    [[DDModelHttpClient sharedInstance] showHud:show];
    
    NSDictionary *getParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    NSURLSessionDataTask *getTask =
    [[DDModelHttpClient sharedInstance] GET:path
                                 parameters:getParams
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                        
                                        id JSON = [[self class] getObjectFromReponseObject:responseObject failure:failure];
                                        
                                        //save the cache
                                        [DDCache cacheWithPath:path parameter:params content:JSON];
                                        if (success && JSON){
                                            success([[self class] convertToObject:JSON]);
                                        }
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                        if(failure)
                                            failure(error, [error description], nil);
                                    }];
    [[DDModelHttpClient sharedInstance] addTask:getTask withKey:viewController];
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
                                id JSON = [cache.content dd_dictionaryWithJSON];
                                dbBlock([[self class] convertToObject:JSON]);
                            }
                        }];
    }
    
    [[DDModelHttpClient sharedInstance] showHud:show];
    
    NSDictionary *postParams = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    NSURLSessionDataTask *getTask =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:postParams
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                         
                                         id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                         
                                         //save the cache
                                         [DDCache cacheWithPath:path parameter:params content:responseObject];
                                         if (success && JSON){
                                             success([[self class] convertToObject:JSON]);
                                         }
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                         if(failure)
                                             failure(error, [error description], nil);
                                     }];
    [[DDModelHttpClient sharedInstance] addTask:getTask withKey:viewController];
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
    NSURLSessionDataTask *getTask =
    [[DDModelHttpClient sharedInstance] GET:path
                                 parameters:params
                                    success:^(NSURLSessionDataTask *operation, id responseObject) {
                                        
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeTask:operation withKey:viewController];
                                        id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                        if (success && JSON)
                                            success([[self class] convertToObject:JSON]);
                                    }
                                    failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                        [[DDModelHttpClient sharedInstance] hideHud:show];
                                        
                                        [[DDModelHttpClient sharedInstance] removeTask:operation withKey:viewController];
                                        if(failure)
                                            failure(error, [error description], nil);
                                    }];
    [[DDModelHttpClient sharedInstance] addTask:getTask withKey:viewController];
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
    NSURLSessionDataTask *postTask =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         /**
                                          *  hide the hud view
                                          */
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                         
                                         id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                         
                                         if (success && JSON)
                                             success([[self class] convertToObject:JSON]);
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                         if(failure)
                                             failure(error, [error description], nil);
                                     }];
    [[DDModelHttpClient sharedInstance] addTask:postTask withKey:viewController];
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
    
    NSURLSessionUploadTask *uploadTask =
    (NSURLSessionUploadTask *)[[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                       NSDictionary *uploadInfo = userInfo[DDFILE];
                       if(!uploadInfo)
                           uploadInfo = [NSDictionary dd_defaultFile];
                       [formData appendPartWithFileData:stream name:uploadInfo.name fileName:uploadInfo.fileName mimeType:uploadInfo.mimeType];
                   }
                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                         id JSON = [self getObjectFromReponseObject:responseObject failure:failure];
                                         if (success && JSON)
                                             success(userInfo,[[self class] convertToObject:JSON]);
                                     }
                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] showHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeTask:task withKey:viewController];
                                     }];
    uploadTask.userInfo = userInfo;
    [[DDModelHttpClient sharedInstance] addTask:uploadTask withKey:viewController];
}

+ (void)cancelRequest:(id)viewController{
    [[DDModelHttpClient sharedInstance] cancelTaskWithKey:viewController];
}

@end
