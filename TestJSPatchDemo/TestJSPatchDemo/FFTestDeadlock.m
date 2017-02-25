//
//  FFTestDeadlock.m
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/16.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "FFTestDeadlock.h"

@implementation FFTestDeadlock

- (void)methodA
{
}
- (void)methodB
{
    @synchronized(self) {   //X锁
        int a = 0;
    }
}
@end
