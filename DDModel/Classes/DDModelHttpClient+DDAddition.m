//
//  DDModelHttpClient+DDAddition.m
//  DDModel
//
//  Created by HIK-DeJohn on 15/5/25.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModelHttpClient+DDAddition.h"
#import <objc/runtime.h>

@implementation DDModelHttpClient (DDAddition)

static int hudCount = 0;

#pragma mark - runtime methods

- (MBProgressHUD *)hud{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setHud:(MBProgressHUD *)hud{
    objc_setAssociatedObject(self, @selector(hud), hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    if(!self.hud){
        self.hud = [[MBProgressHUD alloc] initWithView:topWindow];
        self.hud.labelText = @"请稍候...";
        self.hud.yOffset = -20.0f;
        self.hud.userInteractionEnabled = NO;
        self.hud.mode = MBProgressHUDModeIndeterminate;
        self.hud.color = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3f];
    }
    [topWindow addSubview:self.hud];
    //处理背景颜色 按需更换
    hudCount++;
    [self.hud show:NO];
}

- (void)hideHud:(BOOL)flag{
    if(!flag)
        return;
    if(hudCount == 1 && self.hud){
        [self.hud hide:NO];
    }
    hudCount --;
}

@end

@implementation DDModelHttpClient (NSURLSessionTaskHandler)

- (NSMutableDictionary *)ddHttpQueueDict{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setDdHttpQueueDict:(NSMutableDictionary *)ddHttpQueueDict{
    objc_setAssociatedObject(self, @selector(ddHttpQueueDict), ddHttpQueueDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - HTTP Operation Methods

- (void)addTask:(NSURLSessionTask *)task withKey:(id)key{
    __block NSString *keyStr = [self description];
    if(key)
        keyStr = [key description];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *tasks = self.ddHttpQueueDict[keyStr];
        if(!tasks)
            tasks = [[NSMutableArray alloc] initWithObjects:task, nil];
        else
            [tasks addObject:task];
        [self.ddHttpQueueDict setObject:tasks forKey:keyStr];
    });
}

- (void)removeTask:(NSURLSessionTask *)task withKey:(id)key{
    __block NSString *keyStr = [self description];
    if(key)
        keyStr = [key description];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *tasks = self.ddHttpQueueDict[keyStr];
        [tasks removeObject:task];
    });
}

- (void)cancelTaskWithKey:(id)key{
    __block NSString *keyStr = [self description];
    if(key)
        keyStr = [key description];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *tasks = self.ddHttpQueueDict[keyStr];
        if(tasks.count > 0)
            [tasks makeObjectsPerformSelector:@selector(cancel)];
        [self.ddHttpQueueDict removeObjectForKey:keyStr];
    });
}

@end
