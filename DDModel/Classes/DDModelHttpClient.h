//
//  DDHttpClient.h
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"

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

typedef enum : NSUInteger {
    DDResponseXML,
    DDResponseJSON,
    DDResponseOhter,
} DDResponseType;

@protocol DDHttpClientDelegate;

@interface DDModelHttpClient : AFHTTPSessionManager

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) NSDictionary *checkKeyValue;
@property (nonatomic) DDResponseType type;

/**
 *  show hud if flag = YES
 *
 *  @param flag flag
 */
- (void)showHud:(BOOL)flag;

/**
 *  hide hud if flag = YES
 *
 *  @param flag flag
 */
- (void)hideHud:(BOOL)flag;

#pragma mark - initlize methods
/**
 *  start a singleton HTTP client with url<启动一个设置URL单例HTTP请求>
 *
 *  @param url HTTP target url<http目标URL>
 */
+ (void)startWithURL:(NSString *)url;

/**
 *  start a singleton HTTP client with url and delegate
 *
 *  @param url      HTTP target url
 *  @param delegate DDHttpClientDelegate
 */
+ (void)startWithURL:(NSString *)url delegate:(id<DDHttpClientDelegate>)delegate;

/**
 *  singleton client<单例客户端>
 *
 *  @return instance client<实例化的客户端>
 */
+ (instancetype)sharedInstance;

#pragma mark -
/**
 *  set the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)addHTTPHeaderFieldValue:(NSDictionary *)keyValue;

/**
 *  remove the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)removeHTTPHeaderFieldValue:(NSDictionary *)keyValue;

#pragma mark - NSURLSessionDataTask handler methods

/**
 *  add the NSURLSessionDataTask with key identifier into the DDHttpClient Container
 *
 *  @param task NSURLSessionDataTask
 *  @param key  key identifier
 */
- (void)addTask:(NSURLSessionDataTask *)task withKey:(id)key;

/**
 *  remove the NSURLSessionDataTask with key identifier from the DDHttpClient Container
 *
 *  @param task NSURLSessionDataTask
 *  @param key  key idenitifier
 */
- (void)removeTask:(NSURLSessionDataTask *)task withKey:(id)key;

/**
 *  cancel all the NSURLSessionTask with the key identifier
 *
 *  @param key key identifier
 */
- (void)cancelTasksWithKey:(id)key;

#pragma mark - decode & encode methods
/**
 *  HTTP parameter the handler method
 *
 *  @param params origin parameters
 *
 *  @return new parameters
 */
- (NSDictionary *)parametersHandler:(NSDictionary *)params;

/**
 *  HTTP response string handler method
 *
 *  @param responseString origin responseString
 *
 *  @return new responseString
 */
- (NSString *)responseStringHandler:(NSString *)responseString;

/**
 *   Check the response values is an avaliable value
 *
 *  @param values  origin value
 *  @param failure failure block
 *
 *  @return true or false
 */
- (BOOL)checkResponseValue:(NSDictionary *)values failure:(DDResponseFailureBlock)failure;

@end

@protocol DDHttpClientDelegate <NSObject>

@optional
/**
 *  Parameter encode method if you should encode the parameter in your HTTP client
 *
 *  @param params original parameters
 *
 *  @return endcoded parameters
 */
- (NSDictionary *)encodeParameters:(NSDictionary *)params;

/**
 *  Response String decode methods in you HTTP client
 *
 *  @param responseString origin responseString
 *
 *  @return new responseString
 */
- (NSString *)decodeResponseString:(NSString *)responseString;

/**
 *  Check the response values is an avaliable value.
    e.g. You will sign in an account but you press a wrong username/password, server will response a error for you, you can catch them use this protocol methods and handle this error exception.
 *
 *  @param values  should check value
 *  @param failure failure block
 *
 *  @return true or false
 */
- (BOOL)checkResponseValueAvaliable:(NSDictionary *)values failure:(DDResponseFailureBlock)failure;

@end
