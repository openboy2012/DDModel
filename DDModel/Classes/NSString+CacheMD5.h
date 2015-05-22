//
//  NSString+md5.h
//  DDModel
//
//  Created by DeJohn Dong on 15-3-10.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CacheMD5)

- (NSString *)cacheMD5;

@end

@interface NSString (DDJSON)

- (NSDictionary *)dictionaryWithJSON;

@end
