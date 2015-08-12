//
//  AFHTTPRequestOperationManager+DDAddition.m
//  DDModel
//
//  Created by DeJohn Dong on 15/6/3.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AFHTTPRequestOperationManager+DDAddition.h"
#import <objc/runtime.h>

typedef void (^dd_AFURLConnectionOperationAuthenticationChallengeBlock)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge);

@interface AFHTTPRequestOperationManager()

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic) BOOL hasHttpsPrefix;
@property (readwrite, nonatomic, copy) dd_AFURLConnectionOperationAuthenticationChallengeBlock authenticationChallenge;

@end

@implementation AFHTTPRequestOperationManager (DDAddition)

#pragma mark - replace methods

+ (void)load{
    
    SEL selectors[] = {
        @selector(baseURL),
        @selector(HTTPRequestOperationWithRequest:success:failure:)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"dd_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSURL *)dd_baseURL{
    NSString *url = self.urls[0];
    if([url rangeOfString:@"http"].location == NSNotFound){
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    return [NSURL URLWithString:url];
}

- (AFHTTPRequestOperation *)dd_HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = self.responseSerializer;
    operation.shouldUseCredentialStorage = self.shouldUseCredentialStorage;
    operation.credential = self.credential;
    operation.securityPolicy = self.securityPolicy;
    
    if(self.hasHttpsPrefix){
        [operation setWillSendRequestForAuthenticationChallengeBlock:self.authenticationChallenge];
    }
    
    [operation setCompletionBlockWithSuccess:success failure:failure];
    operation.completionQueue = self.completionQueue;
    operation.completionGroup = self.completionGroup;
    
    return operation;
}


#pragma mark - runtime methods

- (dd_AFURLConnectionOperationAuthenticationChallengeBlock)authenticationChallenge{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAuthenticationChallenge:(dd_AFURLConnectionOperationAuthenticationChallengeBlock)authenticationChallenge{
    objc_setAssociatedObject(self, @selector(authenticationChallenge), authenticationChallenge, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableArray *)urls{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUrls:(NSMutableArray *)urls{
    objc_setAssociatedObject(self, @selector(urls), urls, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasHttpsPrefix{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHasHttpsPrefix:(BOOL)hasHttpsPrefix{
    objc_setAssociatedObject(self, @selector(hasHttpsPrefix), @(hasHttpsPrefix), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private Methods

- (void)dd_exchangeURL:(NSString *)url{
    self.hasHttpsPrefix = NO;
    if([url hasPrefix:@"https"]){
        self.hasHttpsPrefix = YES;
    }
    if([self.urls containsObject:url]){
        [self.urls exchangeObjectAtIndex:0 withObjectAtIndex:[self.urls indexOfObject:url]];
    }else{
        if(!self.urls){
            self.urls = [NSMutableArray new];
        }
        [self.urls insertObject:url atIndex:0];
    }
}

- (void)dd_addURL:(NSString *)url{
    if(!self.urls){
        self.urls = [NSMutableArray new];
    }
    if([url hasPrefix:@"https"]){
        self.hasHttpsPrefix = YES;
    }
    if([self.urls containsObject:url]){
        [self dd_exchangeURL:url];
        return;
    }
    [self.urls insertObject:url atIndex:0];
}

- (void)dd_setWillSendRequestForAuthenticationChallengeBlock:(void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *))block{
    self.authenticationChallenge = block;
}

@end
