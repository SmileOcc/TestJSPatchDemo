//
//  FFTestObject.h
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/14.
//  Copyright © 2017年 occ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OCBlock)(NSDictionary *dict);

@interface FFTestObject : NSObject

+ (FFTestObject *)sharedInstance;

@property (nonatomic, copy)   NSString            *name;
@property (nonatomic, strong) NSMutableDictionary *info;
@property (nonatomic, strong) NSArray             *users;

@property (nonatomic, strong) NSNumber            *number;
@property (nonatomic, assign) int                 age;

+ (NSString *)staticName;

+ (BOOL)testNull:(NSNull *)null;

+ (void)request:(void(^)(NSString *content, BOOL success))callBack;

+ (OCBlock)genBlock;

+ (void)execBlock:(OCBlock)blk;

@end
