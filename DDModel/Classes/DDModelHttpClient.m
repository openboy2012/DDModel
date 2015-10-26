//
//  DDHttpClient.m
//  DDModel
//
//  Created by DeJohn Dong on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModelHttpClient.h"
#import "AFHTTPSessionManager+DDModel.h"

static NSString *kAppUrl;

@interface DDModelHttpClient()

@property (nonatomic, weak) id<DDHttpClientDelegate> delegate;
@property (nonatomic, readwrite) BOOL isFailureResponseCallback;

@end

@implementation DDModelHttpClient

#pragma mark - lifecycle methods

+ (void)startWithURL:(NSString *)url{
    kAppUrl = url;
    [self sharedInstance];
}

+ (instancetype)sharedInstance{
    static DDModelHttpClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *clientURL = [NSURL URLWithString:kAppUrl];
        if([clientURL.scheme isEqualToString:@"https"]){
            client.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        }
        if(!clientURL.host){
            NSLog(@"you have lost the method 'startWithURL:' or 'startWithURL:delegate:' in lanuching AppDelegate");
        }
        client = [[DDModelHttpClient alloc] initWithBaseURL:clientURL];
        [client dd_addURL:kAppUrl];
        client.type = DDResponseOhter;
    });
    return client;
}

+ (void)startWithURL:(NSString *)url delegate:(id<DDHttpClientDelegate>)delegate{
    [self startWithURL:url];
    [DDModelHttpClient sharedInstance].delegate = delegate;
}

#pragma mark - HTTP Header Field Value Handler Methods

+ (void)addHTTPHeaderFieldValue:(NSDictionary *)keyValue{
    for (id key in [keyValue allKeys]) {
        [[[self sharedInstance] requestSerializer] setValue:keyValue[key] forHTTPHeaderField:key];
    }
}

+ (void)removeHTTPHeaderFieldValue:(NSDictionary *)keyValue{
    for (id key in [keyValue allKeys]) {
        [[[self sharedInstance] requestSerializer] setValue:@"" forHTTPHeaderField:key];
    }
}

#pragma mark - HTTP Decode & Encode Methods

- (NSDictionary *)parametersHandler:(NSDictionary *)params{
    if([self.delegate respondsToSelector:@selector(encodeParameters:)]){
        params = [self.delegate encodeParameters:params];
    }
    return params;
}

- (NSString *)responseStringHandler:(NSString *)responseString{
    if([self.delegate respondsToSelector:@selector(decodeResponseString:)]){
        responseString = [self.delegate decodeResponseString:responseString];
    }
    return responseString;
}

- (BOOL)checkResponseValues:(NSDictionary *)values failure:(DDResponsesFailureBlock)failure {
    if([self.delegate respondsToSelector:@selector(checkResponseValueAvaliable:failure:)]){
        return [self.delegate checkResponseValuesAvailable:values failure:failure];
    }
    return YES;
}

#pragma mark - Get & set methods

- (void)setType:(DDResponseType)type{
    _type = type;
    if(type == DDResponseXML){
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }else if(type == DDResponseJSON){
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }else{
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
}

- (void)setFailureCallbackResponse:(BOOL)flag{
    self.isFailureResponseCallback = flag;
}

@end



@implementation DDModelHttpClient (DDDeprecated)


- (BOOL)checkResponseValue:(NSDictionary *)values failure:(DDResponseFailureBlock)failure{
    if([self.delegate respondsToSelector:@selector(checkResponseValueAvaliable:failure:)]){
        return [self.delegate checkResponseValueAvaliable:values failure:failure];
    }
    return YES;
}

@end


