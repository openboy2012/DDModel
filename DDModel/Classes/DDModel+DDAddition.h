//
//  DDModel+DDAddition.h
//  DDModel
//
//  Created by DeJohn Dong on 15/6/3.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModel.h"

@interface DDModel (DDAddition)

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
successBlock:(DDResponseSuccessBlock)success
failureBlock:(DDResponsesFailureBlock)failure;

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
     successBlock:(DDResponseSuccessBlock)success
     failureBlock:(DDResponsesFailureBlock)failure;

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
    successBlock:(DDResponseSuccessBlock)success
    failureBlock:(DDResponsesFailureBlock)failure;

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
     successBlock:(DDResponseSuccessBlock)success
     failureBlock:(DDResponsesFailureBlock)failure;

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
     successBlock:(DDUploadReponseSuccessBlock)success
     failureBlock:(DDResponsesFailureBlock)failure;

/**
 *  Cancel all the request in the viewController.
 *
 *  @param viewController viewcontroller
 */
+ (void)cancelRequest:(id)viewController;

@end


@interface DDModel (DDDeprecated)

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
    failure:(DDResponseFailureBlock)failure __deprecated_msg("");

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
     failure:(DDResponseFailureBlock)failure __deprecated_msg("");

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
    failure:(DDResponseFailureBlock)failure __deprecated_msg("");

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
     failure:(DDResponseFailureBlock)failure __deprecated_msg("");

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
     failure:(DDResponseFailureBlock)failure __deprecated_msg("");

@end
