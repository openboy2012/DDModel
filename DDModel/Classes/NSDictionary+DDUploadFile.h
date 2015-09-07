//
//  NSDictionary+DDModelKit.h
//  DDModel
//
//  Created by DeJohn Dong on 15-2-9.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DDUploadFile)

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *mimeType;

+ (instancetype)dictionaryWithName:(NSString *)name
                          fileName:(NSString *)fileName
                          mimeType:(NSString *)mimeType;

+ (instancetype)defaultFile;

@end


@interface NSDictionary (DDJSON)

- (NSString *)JSONString;

@end