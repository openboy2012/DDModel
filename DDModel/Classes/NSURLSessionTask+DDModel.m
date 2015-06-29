//
//  NSURLSessionTask+DDModel.m
//  DDModel
//
//  Created by diaoshu on 15/4/27.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "NSURLSessionTask+DDModel.h"
#import <objc/runtime.h>

@implementation NSURLSessionTask (DDModel)

- (void)setUserInfo:(NSDictionary *)userInfo{
    objc_setAssociatedObject(self, @selector(userInfo), userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)userInfo{
    return objc_getAssociatedObject(self, _cmd);
}

@end
