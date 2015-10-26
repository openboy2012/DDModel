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

/**
 *  Initilization with name, fileName & mimeType dictionary object
 *
 *  @param name     name
 *  @param fileName file name
 *  @param mimeType mime type
 *
 *  @return dictionary
 */
+ (instancetype)dd_dictionaryWithName:(NSString *)name
                             fileName:(NSString *)fileName
                             mimeType:(NSString *)mimeType;

/**
 *  Default initilize
 *
 *  @return dictionary
 */
+ (instancetype)dd_defaultFile;


/**
 *  NSDictionary object convert to JSON string
 *
 *  @return json string
 */
- (NSString *)dd_jsonString;

@end
