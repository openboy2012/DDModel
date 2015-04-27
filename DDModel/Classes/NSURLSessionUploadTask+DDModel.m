//
//  NSURLSessionUploadTask+DDModel.m
//  DDModel
//
//  Created by diaoshu on 15/4/27.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "NSURLSessionUploadTask+DDModel.h"
#import <objc/runtime.h>

static char *userInfoKey;

@implementation NSURLSessionUploadTask (DDModel)

- (void)setUserInfo:(NSDictionary *)userInfo{
    objc_setAssociatedObject(self, &userInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)userInfo{
    return objc_getAssociatedObject(self, &userInfoKey);
}

@end
