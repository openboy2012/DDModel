//
//  AFHTTPRequestOperationManager+DDAddition.m
//  DDModel
//
//  Created by DeJohn Dong on 15/6/3.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AFHTTPRequestOperationManager+DDAddition.h"
#import <objc/runtime.h>

@interface AFHTTPRequestOperationManager()

@property (nonatomic, strong) NSMutableArray *urls;

@end

@implementation AFHTTPRequestOperationManager (DDAddition)

#pragma mark - replace methods

+ (void)load{
    SEL originalSelector = @selector(baseURL);
    SEL swizzledSelector = NSSelectorFromString([@"dd_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
    
    Method originalMethod = class_getInstanceMethod(self, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (NSURL *)dd_baseURL{
    return [NSURL URLWithString:self.urls[0]];
}

#pragma mark - runtime methods

- (NSMutableArray *)urls{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setUrls:(NSMutableArray *)urls{
    objc_setAssociatedObject(self, @selector(urls), urls, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private Methods

- (void)dd_exchangeURL:(NSString *)url{
    [self.urls exchangeObjectAtIndex:0 withObjectAtIndex:[self.urls indexOfObject:url]];
}

- (void)dd_addURL:(NSString *)url{
    if(!self.urls){
        self.urls = [NSMutableArray new];
    }
    if([self.urls containsObject:url]){
        [self dd_exchangeURL:url];
        return;
    }
    [self.urls insertObject:url atIndex:0];
}

@end
