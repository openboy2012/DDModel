//
//  DDModel.m
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel.h"
#import "DDModelHttpClient.h"

@interface DDModel()

/**
 *  parse the responseString to JSON object
 */
+ (id)getJSONObjectFromString:(NSString *)responseString;

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
                                        id JSON = [self getJSONObjectFromString:operation.responseString];
                                        if (success)
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
                                         
                                         id JSON = [self getJSONObjectFromString:operation.responseString];
                                         if (success)
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
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure{
    
    [[DDModelHttpClient sharedInstance] showHud:show];
    params = [[DDModelHttpClient sharedInstance] parametersHandler:params];
    
    AFHTTPRequestOperation *uploadOperation =
    [[DDModelHttpClient sharedInstance] POST:path
                                  parameters:params
                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                       NSString *name = userInfo[@"fileInfo"][@"name"]?:@"uploadFile";
                       NSString *fileName = userInfo[@"fileInfo"][@"fileName"]?:@"file";
                       NSString *mineType = userInfo[@"fileInfo"][@"mimeType"]?:@"image/jpg";
                       [formData appendPartWithFileData:stream name:name fileName:fileName mimeType:mineType];
                   }
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         [[DDModelHttpClient sharedInstance] hideHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         id JSON = [self getJSONObjectFromString:operation.responseString];
                                         if (success)
                                             success([[self class] convertJsonToObject:JSON]);
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         [[DDModelHttpClient sharedInstance] showHud:show];
                                         
                                         [[DDModelHttpClient sharedInstance] removeOperation:operation withKey:viewController];
                                         if([error code] != kCFURLErrorCancelled){
                                             NSLog(@"error = %@",error);
                                         }
                                     }];
    uploadOperation.userInfo = userInfo;
    [[DDModelHttpClient sharedInstance] addOperation:uploadOperation withKey:viewController];
}

#pragma mark -

+ (id)getJSONObjectFromString:(NSString *)responseString{
    
    /**
     *  decode if you should decode responseString
     */
    responseString = [[DDModelHttpClient sharedInstance] responseStringHandler:responseString];
    
    NSError *decodeError = nil;
    NSData *decodeData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *jsonValue = [NSJSONSerialization JSONObjectWithData:decodeData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&decodeError];
    return jsonValue?:@{};
}

+ (void)cancelRequest:(id)viewController{
    [[DDModelHttpClient sharedInstance] cancelOperationWithKey:NSStringFromClass([viewController class])];
}

#pragma mark - Object Mapping Handle Methods

+ (NSString *)parseNode{
    return @"NULL";
}

+ (NSDictionary *)parseMappings{
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
