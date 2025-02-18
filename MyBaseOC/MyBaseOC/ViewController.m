//
//  ViewController.m
//  MyBaseOC
//
//  Created by dengwt on 2021/7/20.
//

#import "ViewController.h"
#import "SwizzleUtils.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (int)testIsKindOfClass {
    if ([[NSString class] isKindOfClassITX:[NSString class]]) {
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    if ([[NSString class] isKindOfClass:[NSString class]]) {
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    
    if ([[NSObject class] isKindOfClassITX:[NSObject class]]) {
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    if ([[NSObject class] isKindOfClass:[NSObject class]]) {
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    
    return 0;
}

+ (BOOL)isKindOfClassITX:(Class)class
{
    Class r0 = object_getClass(self);
    while (1) {
        if (r0 == 0) {
            return 0;
        }else{
            NSLog(@"class->%@:%p",NSStringFromClass(class), class);
            NSLog(@"r0->%@:%p",NSStringFromClass(r0), r0);
            if (r0 != class) {
                r0 = [r0 superclass];
            }else{
                return 1;
            }
        }
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SwizzleUtils swizzleInstanceMethod:[self class] originalSelector:@selector(viewWillAppear:) swizzledSelector:@selector(AA_viewWillAppear:)];
    });
}

- (void)AA_viewWillAppear:(BOOL)animated {
    
    NSLog(@"UIViewController");
    
    [self AA_viewWillAppear:animated];
}

@end
