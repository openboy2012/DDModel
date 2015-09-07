//
//  NSDictionary+DDModelKit.h
//  DDModel
//
//  Created by Diaoshu on 15-2-9.
//  Copyright (c) 2015年 DDKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (DDModel)

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSString *mimeType;

+ (instancetype)dd_dictionaryWithName:(NSString *)name
                             fileName:(NSString *)fileName
                             mimeType:(NSString *)mimeType;

+ (instancetype)dd_defaultFile;


- (NSString *)dd_jsonString;

@end
