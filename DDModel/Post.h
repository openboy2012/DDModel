//
//  Post.h
//  DDKit
//
//  Created by DeJohn Dong on 14-12-15.
//  Copyright (c) 2014年 DDKit. All rights reserved.
//

#import "DDModel.h"

@interface User : DDModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatarImageURLString;

@end

@interface Post : DDModel

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) User *user;


+ (void)getPostList:(id)params
           parentVC:(id)viewController
            showHUD:(BOOL)show
            success:(DDResponseSuccessBlock)success
            failure:(DDResponsesFailureBlock)failure;

@end

@interface Station : DDModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, copy) NSString *streamURL;
@property (nonatomic, copy) NSString *picture;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

+ (void)getStationList:(id)params
              parentVC:(id)viewController
               showHUD:(BOOL)show
             dbSuccess:(DDSQLiteBlock)dbResult
               success:(DDResponseSuccessBlock)success
               failure:(DDResponsesFailureBlock)failure;

@end

@interface BESTItemList : DDModel

@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *style;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *salePrice;
@property (nonatomic, strong) NSNumber *marketPrice;

@end

@interface BESTItemListRoot : DDModel

@property (nonatomic, strong) NSArray *list;
@property (nonatomic) int count;

+ (void)getItemList:(id)params
            showHUD:(BOOL)show
parentViewController:(id)viewController
            success:(DDResponseSuccessBlock)success
            failure:(DDResponsesFailureBlock)failure;

@end