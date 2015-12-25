//
//  AFHTTPSessionManager+DDModel.m
//  DDModel
//
//  Created by DeJohn Dong on 15/9/8.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AFHTTPSessionManager+DDModel.h"
#import <objc/runtime.h>

@interface AFHTTPSessionManager()

@property (nonatomic, strong, readwrite) NSMutableArray *urls;

@end

@implementation AFHTTPSessionManager (DDModel)

#pragma mark - replace methods

+ (void)load {
    
    SEL selectors[] = {
        @selector(baseURL)
    };
    
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"dd_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSURL *)dd_baseURL {
    NSString *url = self.urls[0];
    if ([url rangeOfString:@"http"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    return [NSURL URLWithString:url];
}

#pragma mark - runtime methods

- (NSMutableArray *)urls {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUrls:(NSMutableArray *)urls {
    objc_setAssociatedObject(self, @selector(urls), urls, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)hasHttpsPrefix {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setHasHttpsPrefix:(BOOL)hasHttpsPrefix {
    objc_setAssociatedObject(self, @selector(hasHttpsPrefix), @(hasHttpsPrefix), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private Methods

- (void)dd_exchangeURL:(NSString *)url {
    self.hasHttpsPrefix = NO;
    if ([url hasPrefix:@"https"]) {
        self.hasHttpsPrefix = YES;
    }
    if ([self.urls containsObject:url]) {
        [self.urls exchangeObjectAtIndex:0 withObjectAtIndex:[self.urls indexOfObject:url]];
    } else {
        if (!self.urls) {
            self.urls = [NSMutableArray new];
        }
        [self.urls insertObject:url atIndex:0];
    }
}

- (void)dd_addURL:(NSString *)url{
    if (!self.urls) {
        self.urls = [NSMutableArray new];
    }
    if ([url hasPrefix:@"https"]) {
        self.hasHttpsPrefix = YES;
    }
    if ([self.urls containsObject:url]) {
        [self dd_exchangeURL:url];
        return;
    }
    [self.urls insertObject:url atIndex:0];
}

@end
