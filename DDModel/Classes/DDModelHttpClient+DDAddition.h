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
 *  show hud if flag is YES
 *
 *  @param flag flag
 */
- (void)showHud:(BOOL)flag;

/**
 *  hide hud if flag is YES
 *
 *  @param flag flag
 */
- (void)hideHud:(BOOL)flag;

@end

@interface DDModelHttpClient (NSURLSessionTaskHandler)

@property (nonatomic, strong) NSMutableDictionary *ddHttpQueueDict;

/**
 *  Add the requesting task into the tasks queue with the key. the tasks queue may have many keys, so we use the key value to 
 *
 *  @param task requesting task
 *  @param key  key
 */
- (void)addTask:(NSURLSessionDataTask *)task withKey:(id)key;

/**
 *  Cancel the requesting task in the tasks queue with the key.
 *
 *  @param task requesting task
 *  @param key  key
 */
- (void)removeTask:(NSURLSessionDataTask *)task withKey:(id)key;

/**
 *  Cancel the all requesting tasks in tasks queue with the key.
 *
 *  @param key key
 */
- (void)cancelTasksWithKey:(id)key;


@end
