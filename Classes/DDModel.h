//
//  DDModel.h
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SQLitePersistentObject.h>
#import <NSObject+JTObjectMapping.h>
#import <XMLDictionary.h>

/**
 *  Http Response Success Block callback an object or an object arrays;
 *
 *  @param data an object or an object arrays
 */
typedef void(^DDResponseSuccessBlock)(id data);
/**
 *  Http Response Failure Block callback an error object & a message object
 *
 *  @param error   error
 *  @param message error message
 */
typedef void(^DDResponseFailureBlock)(NSError *error, NSString *message);

/**
 *  Http Upload file response success block callback with userinfo & response object
 *
 *  @param userInfo userInfo
 *  @param data     response object
 */
typedef void(^DDUploadReponseSuccessBlock)(NSDictionary *userInfo, id data);

/**
 *  DB callback an object or an object arrays
 *
 *  @param data an object or an object arrays
 */
typedef void(^DDSQLiteBlock)(id data);

@interface DDModel : SQLitePersistentObject{
    
}

@property (nonatomic, copy) NSString *parameter;

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

/**
 *  Get json data first from db cache then from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param dbResult       db cache result block
 *  @param success        success block
 *  @param failure        failre block
 */
+ (void)get:(NSString *)path
     params:(id)params
    showHUD:(BOOL)show
parentViewController:(id)viewController
  dbSuccess:(DDSQLiteBlock)dbResult
    success:(DDResponseSuccessBlock)success
    failure:(DDResponseFailureBlock)failure;

/**
 *  Get json data first from db cache then from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param dbResult       db cache result block
 *  @param success        success block
 *  @param failure        failre block
 *
 */
+ (void)post:(NSString *)path
      params:(id)params
     showHUD:(BOOL)show
parentViewController:(id)viewController
   dbSuccess:(DDSQLiteBlock)dbResult
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure;

/**
 *  Get json data from http server by HTTP GET Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param success        success block
 *  @param failure        failre block
 *
 */
+ (void)get:(NSString *)path
     params:(id)params
    showHUD:(BOOL)show
parentViewController:(id)viewController
    success:(DDResponseSuccessBlock)success
    failure:(DDResponseFailureBlock)failure;

/**
 *  Get json data from http server by HTTP POST Mehod.
 *
 *  @param path           HTTP Path
 *  @param params         GET Paramtters
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param success        success block
 *  @param failure        failre block
 *
 */
+ (void)post:(NSString *)path
      params:(id)params
     showHUD:(BOOL)show
parentViewController:(id)viewController
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure;

/**
 *  Upload a data stream to http server by HTTP POST Method.
 *
 *  @param path           HTTP Path
 *  @param stream         stream data
 *  @param params         POST Parameters
 *  @param userInfo       userInfo dictionary
 *  @param show           is show the HUD on the view
 *  @param viewController parentViewController
 *  @param success        success block
 *  @param failure        failure block
 */
+ (void)post:(NSString *)path
  fileStream:(NSData *)stream
      params:(id)params
    userInfo:(id)userInfo
     showHUD:(BOOL)show
parentViewController:(id)viewController
     success:(DDUploadReponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure;

/**
 *  Cancel all the request in the viewController.
 *
 *  @param viewController viewcontroller
 */
+ (void)cancelRequest:(id)viewController;

/**
 *  Parse self entity into a dictionary
 *
 *  @return a dictionary of self entity
 */
- (NSDictionary *)propertiesOfObject;

@end

@interface DDModel(Deprecated)


/**
 *  First Version Post Methods, now is deprecated
 *
 *  @param path       HTTP path
 *  @param params     get params
 *  @param postParams post params
 *  @param view       carray view
 *  @param success    success block
 *  @param failure    failure block
 */
+ (void)post:(NSString *)path
      params:(id)params
  postParams:(id)postParams
  parentView:(id)view
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure __deprecated_msg("use' post:params:showHUD:parentViewController:success:failure:' method replace");
/**
 *  Parse self to a dictionary (deprecated)
 *
 *  @return a dictionary of self
 */
- (NSDictionary *)propertiesOfSelf __deprecated_msg("use 'propertiesOfObject' method replace");

/**
 *  Parse json node, deprecated
 *
 *  @return string key
 */
+ (NSString *)jsonNode __deprecated_msg("use 'parseNode:' method replace");

/**
 *  Parse mapping method, deprecated
 *
 *  @return a parse mapping dictionary
 */
+ (NSDictionary *)jsonMappings __deprecated_msg("use 'parseMappings:' method replace");


@end
