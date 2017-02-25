//
//  FFTestObject.m
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/14.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "FFTestObject.h"

static NSString *staticName = @"1";

@implementation FFTestObject

+ (FFTestObject *)sharedInstance
{
    static FFTestObject *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (NSString *)staticName {
    return staticName;
}

+ (BOOL)testNull:(NSNull *)null {
    return [null isKindOfClass:[NSNull class]];
}

+ (void)request:(void(^)(NSString *content, BOOL success))callBack {
    callBack(@"I'm content", YES);
}


+ (OCBlock)genBlock {
    NSString *ctn = @"OCBlock";
    OCBlock block = ^(NSDictionary *dict) {
        NSLog(@"I'm %@, version: %@", ctn, dict[@"v"]);
    };
    return block;
}

+ (void)execBlock:(OCBlock)blk {
    
}
@end
