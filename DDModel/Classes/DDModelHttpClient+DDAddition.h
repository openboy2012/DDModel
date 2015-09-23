//
//  DDModelHttpClient+DDAddition.h
//  DDModel
//
//  Created by HIK-DeJohn on 15/5/25.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "DDModelHttpClient.h"
#import "MBProgressHUD.h"

@interface DDModelHttpClient (DDAddition)

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

@interface DDModelHttpClient (NSURLSessionTaskHandler)

@property (nonatomic, strong) NSMutableDictionary *ddHttpQueueDict;

#pragma mark - operation handler methods
/**
 *  Add operation with key <根据Key值加入Opeartion>
 *
 *  @param operation requesting operation <正在请求的HTTP Operation>
 *  @param key       key <关键字，方便再次查找>
 */
- (void)addTask:(NSURLSessionDataTask *)task withKey:(id)key;

/**
 *  Cancel operation with key <根据Key值取消某个Opeartion>
 *
 *  @param operation requesting operation <正在请求的HTTP Operation>
 *  @param key       key <关键字，方便再次查找>
 */
- (void)removeTask:(NSURLSessionDataTask *)task withKey:(id)key;

/**
 *  Cancel all operation with key <根据Key取消所有的Operation>
 *
 *  @param key key <关键字>
 */
- (void)cancelTaskWithKey:(id)key;


@end
