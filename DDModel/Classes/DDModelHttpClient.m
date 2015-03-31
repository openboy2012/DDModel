//
//  DDHttpClient.m
//  DDModel
//
//  Created by Diaoshu on 15-2-4.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModelHttpClient.h"

static NSString *kAppUrl;

static int hudCount = 0;

@interface DDModelHttpClient()

@property (nonatomic, strong) NSMutableDictionary *ddHttpQueueDict;
@property (nonatomic, weak) id<DDHttpClientDelegate> delegate;

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
        
        //instance the ddHttpQueueDictionary
        client.ddHttpQueueDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        client.type = DDResponseJSON;
        
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

#pragma mark - HTTP Operation Methods

- (void)addOperation:(AFURLConnectionOperation *)operation withKey:(id)key{
    __block NSString *keyStr = [self description];
    if(key)
        keyStr = [key description];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *operations = self.ddHttpQueueDict[keyStr];
        if(!operations)
            operations = [[NSMutableArray alloc] initWithObjects:operation, nil];
        else
            [operations addObject:operation];
        [self.ddHttpQueueDict setObject:operations forKey:keyStr];
    });
}

- (void)removeOperation:(AFURLConnectionOperation *)operation withKey:(id)key{
    __block NSString *keyStr = [self description];
    if(key)
        keyStr = [key description];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *operations = self.ddHttpQueueDict[keyStr];
        [operations removeObject:operation];
    });
}

- (void)cancelOperationWithKey:(id)key{
    __block NSString *keyStr = [self description];
    if(key)
        keyStr = [key description];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *operations = self.ddHttpQueueDict[keyStr];
        if(operations.count > 0)
            [operations makeObjectsPerformSelector:@selector(cancel)];
        [self.ddHttpQueueDict removeObjectForKey:keyStr];
    });
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

- (BOOL)checkResponseValue:(NSDictionary *)values failure:(DDResponseFailureBlock)failure{
    if([self.delegate respondsToSelector:@selector(checkResponseValueAvaliable:failure:)]){
        return [self.delegate checkResponseValueAvaliable:values failure:failure];
    }
    return YES;
}

#pragma mark - Get & set methods

- (void)setType:(DDResponseType)type{
    _type = type;
    if(type == DDResponseXML){
        self.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }else{
        self.responseSerializer = [AFJSONResponseSerializer serializer];
    }
}

#pragma mark - HTTP HUD methods

- (void)showHud:(BOOL)flag{
    if(!flag)
        return;
    if(hudCount > 0){
        hudCount ++;
        return;
    }
    UIWindow *topWindow = [[[UIApplication sharedApplication] windows] lastObject];
    if(!_hud){
        _hud = [[MBProgressHUD alloc] initWithView:topWindow];
        _hud.labelText = @"请稍候...";
        _hud.yOffset = -20.0f;
        _hud.userInteractionEnabled = NO;
        _hud.mode = MBProgressHUDModeIndeterminate;
        _hud.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3f];
    }
    [topWindow addSubview:_hud];
    //处理背景颜色 按需更换
    hudCount++;
    [_hud show:NO];
}

- (void)hideHud:(BOOL)flag{
    if(!flag)
        return;
    if(hudCount == 1 && _hud){
        [_hud hide:NO];
    }
    hudCount --;
}

@end
