//
//  DDModelHttpClient+Addition.h
//  DDModel
//
//  Created by HIK-DeJohn on 15/5/25.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModelHttpClient.h"

@interface DDModelHttpClient (Addition)

@property (nonatomic, strong) MBProgressHUD *hud;

/**
 *  show hud if flag = YES
 *
 *  @param flag flag
 */
- (void)showHud:(BOOL)flag;

/**
 *  hide hud if flag = YES
 *
 *  @param flag flag
 */
- (void)hideHud:(BOOL)flag;

@end
