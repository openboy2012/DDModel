//
//  AFHTTPSessionManager+DDModel.h
//  DDModel
//
//  Created by DeJohn Dong on 15/9/8.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFHTTPSessionManager (DDModel)

/**
 *  dynomic replace the url
 *
 *  @param url target url
 */
- (void)dd_exchangeURL:(NSString *)url;

/**
 *  add a new url into http client
 *
 *  @param url target url
 */
- (void)dd_addURL:(NSString *)url;

@end
