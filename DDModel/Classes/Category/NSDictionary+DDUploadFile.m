//
//  NSDictionary+DDModelKit.m
//  DDModel
//
//  Created by Diaoshu on 15-2-9.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "NSDictionary+DDUploadFile.h"

#define ddmime @"mimeType"
#define ddfile @"fileName"
#define ddname @"name"

@implementation NSDictionary (DDUploadFile)

+ (instancetype)dictionaryWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSDictionary *)mimeType{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [dictionary setObject:name forKey:ddname];
    [dictionary setObject:fileName forKey:ddfile];
    [dictionary setObject:mimeType forKey:mimeType];
    return dictionary;
}

- (NSString *)mimeType{
    return [self objectForKey:ddmime];
}

- (NSString *)fileName{
    return [self objectForKey:ddmime];
}

- (NSString *)name{
    return [self objectForKey:ddname];
}

@end
