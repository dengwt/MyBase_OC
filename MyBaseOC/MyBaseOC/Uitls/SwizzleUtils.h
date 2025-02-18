//
//  SwizzleUtils.h
//  MyBaseOC
//
//  Created by dengwt on 2025/2/13.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface SwizzleUtils:NSObject

+ (void)swizzleInstanceMethod:(Class)class
        originalSelector:(SEL)originalSelector
        swizzledSelector:(SEL)swizzledSelector;

+ (void)swizzleClassMethod:(Class)class
          originalSelector:(SEL)originalSelector
          swizzledSelector:(SEL)swizzledSelector;

@end
