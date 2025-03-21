//
//  Person.m
//  MyBaseOC
//
//  Created by LIANDI on 2025/3/4.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self xx_modelInitWithCoder:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self xx_modelEncodeWithCoder:aCoder];
}

void eat(id self, SEL sel) { NSLog(@"%@ %@", self, NSStringFromSelector(sel)); }

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eat)) {
        class_addMethod(self, @selector(eat), (IMP)eat, "v@:");
        return YES;
    }

    return [super resolveInstanceMethod:sel];
}

@end
