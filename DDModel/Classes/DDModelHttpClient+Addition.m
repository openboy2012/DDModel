//
//  DDModelHttpClient+Addition.m
//  DDModel
//
//  Created by HIK-DeJohn on 15/5/25.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModelHttpClient+Addition.h"
#import <objc/runtime.h>

@implementation DDModelHttpClient (Addition)

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
