//
//  DDModel.h
//  DDModel
//
//  Created by DeJohn Dong on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLitePersistentObject.h"
#import "NSObject+JTObjectMapping.h"
#import "XMLDictionary.h"
#import "DDModelHttpClient.h"

#define DDFILE @"fileInfo"

@protocol DDMappings <NSObject>

/**
 *  Set the parse node, every subclass override the method if you want parse any node
 *
 *  @return node
 */
+ (NSString *)parseNode;

/**
 *  Handle the mappings about the json key-value transform to a model object.
 The method support for KeyPathValue. e.g. you have a  @property name, you want get value from "{user:{name:'mike',id:10011},picture:'https://xxxx/headerimage/header01.jpg'}", you just set mapping dictionary is @{@"user.name":@"name"}.
 *
 *  @return mappings
 */
+ (NSDictionary *)parseMappings;

@end

/**
 *  DB callback an object or an object arrays
 *
 *  @param data an object or an object arrays
 */
typedef void(^DDSQLiteBlock)(id data);

@interface DDModel : SQLitePersistentObject<DDMappings>{
    
}

/**
 *  Get json data first from db cache then from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param dbResult       db cache result block
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)get:(NSString *)path
                       params:(id)params
                    dbSuccess:(DDSQLiteBlock)dbResult
                      success:(DDResponseSuccessBlock)success
                      failure:(DDResponsesFailureBlock)failure;

/**
 *  Get json data first from db cache then from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param dbResult       db cache result block
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)post:(NSString *)path
                        params:(id)params
                     dbSuccess:(DDSQLiteBlock)dbResult
                       success:(DDResponseSuccessBlock)success
                       failure:(DDResponsesFailureBlock)failure;

/**
 *  Get json data from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)get:(NSString *)path
                       params:(id)params
                      success:(DDResponseSuccessBlock)success
                      failure:(DDResponsesFailureBlock)failure;

/**
 *  Get json data from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         POST Paramtters
 *  @param success        success block
 *  @param failure        failre block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)post:(NSString *)path
                        params:(id)params
                       success:(DDResponseSuccessBlock)success
                       failure:(DDResponsesFailureBlock)failure;

/**
 *  Upload a data stream to http server by HTTP POST Method.
 *
 *  @param path           HTTP Path
 *  @param stream         stream data
 *  @param params         POST Parameters
 *  @param userInfo       userInfo dictionary
 *  @param success        success block
 *  @param failure        failure block
 *
 *  @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)post:(NSString *)path
                    fileStream:(NSData *)stream
                        params:(id)params
                      userInfo:(id)userInfo
                       success:(DDUploadReponseSuccessBlock)success
                       failure:(DDResponsesFailureBlock)failure;

/**
 *  Parse self entity into a dictionary
 *
 *  @return a dictionary of self entity
 */
- (NSDictionary *)propertiesOfObject;

/**
 *  Get Object(s) from reponse string
 *
 *  @param reponseString reponse string
 *  @param failure       failure handler block
 *
 *  @return Object(s)
 */
+ (id)getObjectFromReponseObject:(NSString *)responseObject
                         failure:(DDResponsesFailureBlock)failure;

/**
 *  conver dictionary object to Model
 *
 *  @param dictObject dictionary object
 *
 *  @return modol or model array
 */
+ (id)convertToObject:(id)dictObject;

@end

