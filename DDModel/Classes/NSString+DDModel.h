//
//  NSString+md5.h
//  DDModel
//
//  Created by DeJohn Dong on 15-3-10.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DDModel)

/**
 *  cache string md5 encode
 *
 *  @return md5 string
 */
- (NSString *)dd_cacheMD5;

/**
 *  string convert to NSDictionary object
 *
 *  @return dictionary
 */
- (NSDictionary *)dd_dictionaryWithJSON;

@end
