//
//  NSDictionary+DDModelKit.m
//  DDModel
//
//  Created by Diaoshu on 15-2-9.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import "NSDictionary+DDModel.h"

#define ddmime @"mimeType"
#define ddfile @"fileName"
#define ddname @"name"

@implementation NSDictionary (DDUploadFile)

+ (instancetype)dd_dictionaryWithName:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [dictionary setObject:name forKey:ddname];
    [dictionary setObject:fileName forKey:ddfile];
    [dictionary setObject:mimeType forKey:ddmime];
    return dictionary;
}

+ (instancetype)defaultFile{
    return [self dd_dictionaryWithName:@"uploadFile" fileName:@"file" mimeType:@"image/jpg"];
}

- (NSString *)mimeType{
    return [self objectForKey:ddmime];
}

- (NSString *)fileName{
    return [self objectForKey:ddfile];
}

- (NSString *)name{
    return [self objectForKey:ddname];
}

- (NSString *)dd_jsonString{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if(error)
        NSLog(@"error = %@",error);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end

