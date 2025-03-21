//
//  SwizzleUtils.m
//  MyBaseOC
//
//  Created by dengwt on 2025/2/13.
//

#import "SwizzleUtils.h"

@interface SwizzleUtils ()

@end

@implementation SwizzleUtils

+ (void)swizzleInstanceMethod:(Class)class
             originalSelector:(SEL)originalSelector
             swizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    // Check if the original method exists
    if (!originalMethod) {
        NSLog(@"Original method not found for selector: %@",
              NSStringFromSelector(originalSelector));
        return;
    }

    // Check if the swizzled method exists
    if (!swizzledMethod) {
        NSLog(@"Swizzled method not found for selector: %@",
              NSStringFromSelector(swizzledSelector));
        return;
    }

    // Attempt to add the swizzled method to the class
    BOOL didAddMethod = class_addMethod(
        class, originalSelector, method_getImplementation(swizzledMethod),
        method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        // If the method was added, replace the swizzled method with the
        // original implementation
        class_replaceMethod(class, swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        // If the method already exists, exchange the implementations
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)swizzleClassMethod:(Class)class
          originalSelector:(SEL)originalSelector
          swizzledSelector:(SEL)swizzledSelector {
    // Class methods are instance methods on the metaclass
    Class metaclass = object_getClass(class);

    [self swizzleInstanceMethod:metaclass
               originalSelector:originalSelector
               swizzledSelector:swizzledSelector];
}

@end
