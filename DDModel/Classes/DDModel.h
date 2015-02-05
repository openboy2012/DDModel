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

/**
 *  Basic Success Block callback an object or an object arrays;
 *
 *  @param data an object or an object arrays
 */
typedef void(^DDResponseSuccessBlock)(id data);
/**
 *  Basic Failure Block callback an error object & a message object
 *
 *  @param error   error
 *  @param message error message
 */
typedef void(^DDResponseFailureBlock)(NSError *error, NSString *message);

@interface DDModel : SQLitePersistentObject

/**
 *  set the parse node, every subclass override the method if you want parse any node
 *
 *  @return node
 */
+ (NSString *)parseNode;

/**
 *  handle the mappings about the json key-value transform to a model object.
    The method support for KeyPathValue. e.g. you have a  @property name, you want get value from "{user:{name:'mike',id:10011},picture:'https://xxxx/headerimage/header01.jpg'}", you just set mapping dictionary is @{@"user.name":@"name"}.
 *
 *  @return mappings
 */
+ (NSDictionary *)parseMappings;

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
     success:(DDResponseSuccessBlock)success
     failure:(DDResponseFailureBlock)failure;

/**
 *  cancel all the request in the viewController.
 *
 *  @param viewController viewcontroller
 */
+ (void)cancelRequest:(id)viewController;

@end
