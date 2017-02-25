//
//  FFMacroSupport.m
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/15.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "FFMacroSupport.h"


@implementation FFMacroSupport

+ (void)main:(JSContext *)context
{
    context[@"CGFLOAT_MIN"] = ^CGFloat() {
        return CGFLOAT_MIN;
    };
}

@end
