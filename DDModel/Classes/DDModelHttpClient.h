//
//  DDHttpClient.h
//  DDModel
//
//  Created by DeJohn Dong on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

/**
 *  Http Response Success Block callback an object or an object arrays;
 *
 *  @param data an object or an object arrays
 */
typedef void(^DDResponseSuccessBlock)(id data);

/**
 *  Http Response Failure Block callback an error object & a message object & a parased object
 *
 *  @param error   error
 *  @param message message info
 *  @param data    data an object or an object arrays
 */
typedef void(^DDResponsesFailureBlock)(NSError *error, NSString *message, id data);

/**
 *  Http Response Failure Block callback an error object & a message object
 *
 *  @param error   error
 *  @param message message info
 */
typedef void(^DDResponseFailureBlock)(NSError *error, NSString *message) __deprecated_msg("Please use 'DDResponsesFailureBlock' instead.");


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

@property (nonatomic) DDResponseType type; //reponse type

/**
 *  Check failure response callback flag status
 */
@property (nonatomic, readonly) BOOL isFailureResponseCallback;

@property (nonatomic, copy) NSString *descKey;   //error description key

/**
 *  Error code key, .eg. your response json is {'resultCode':0,'resultDesc':'success',list:[{'xxx':xxx},...]}
 *  so you should set the resultKey is 'resultCode' hook the result code info and set the descKey is 'resultDesc' hook the
 *  result description
 */
@property (nonatomic, copy) NSString *resultKey;


/**
 *  Set if the response callback when it's failure request
 *
 *  @param flag YES/NO, default is NO.
 */
- (void)setFailureCallbackResponse:(BOOL)flag;

#pragma mark - initlize methods
/**
 *  Start a singleton HTTP client with url.
 *
 *  @param url HTTP target url
 */
+ (void)startWithURL:(NSString *)url;

/**
 *  Start a singleton HTTP client with url & delegate
 *
 *  @param url      HTTP target url
 *  @param delegate DDHttpClientDelegate
 */
+ (void)startWithURL:(NSString *)url delegate:(id<DDHttpClientDelegate>)delegate;

/**
 *  Singleton client
 *
 *  @return instance client
 */
+ (instancetype)sharedInstance;

#pragma mark -
/**
 *  Set the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)addHTTPHeaderFieldValue:(NSDictionary *)keyValue;

/**
 *  Remove the HTTP header field value
 *
 *  @param keyValue keyValue
 */
+ (void)removeHTTPHeaderFieldValue:(NSDictionary *)keyValue;


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
 *   Check the response values is an available value
 *
 *  @param values  origin value
 *  @param failure failure block
 *
 *  @return true or false
 */
- (BOOL)checkResponseValues:(NSDictionary *)values failure:(DDResponsesFailureBlock)failure;

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
 *  Check the response values is an available value.
    e.g. You will sign in an account but you press a wrong username/password, server will response a error for you, you can catch them use this protocol methods and handle this error exception.
 *
 *  @param values  should check value
 *  @param failure failure block
 *
 *  @return true or false
 */
- (BOOL)checkResponseValuesAvailable:(NSDictionary *)values failure:(DDResponsesFailureBlock)failure;


- (BOOL)checkResponseValueAvaliable:(NSDictionary *)values failure:(DDResponseFailureBlock)failure __deprecated_enum_msg("Please use the -checkResponseValueAvailable:failure: instead.");


@end

@interface DDModelHttpClient (DDDeprecated)

- (BOOL)checkResponseValue:(NSDictionary *)values failure:(DDResponseFailureBlock)failure __deprecated_msg("Please use the -checkResponseValues:failure: instead.");

@end
