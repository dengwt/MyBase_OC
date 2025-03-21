//
//  ViewController.m
//  MyBaseOC
//
//  Created by dengwt on 2021/7/20.
//

#import "ViewController.h"
#import "Person.h"
#import "SwizzleUtils.h"
#import <objc/runtime.h>

@interface ViewController ()

@property(nonatomic, strong) Person *person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (int)testIsKindOfClass {
    if ([[NSString class] isKindOfClassITX:[NSString class]]) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }
    if ([[NSString class] isKindOfClass:[NSString class]]) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }

    if ([[NSObject class] isKindOfClassITX:[NSObject class]]) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }
    if ([[NSObject class] isKindOfClass:[NSObject class]]) {
        NSLog(@"YES");
    } else {
        NSLog(@"NO");
    }

    return 0;
}

+ (BOOL)isKindOfClassITX:(Class)class {
    Class r0 = object_getClass(self);
    while (1) {
        if (r0 == 0) {
            return 0;
        } else {
            NSLog(@"class->%@:%p", NSStringFromClass(class), class);
            NSLog(@"r0->%@:%p", NSStringFromClass(r0), r0);
            if (r0 != class) {
                r0 = [r0 superclass];
            } else {
                return 1;
            }
        }
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      [SwizzleUtils swizzleInstanceMethod:[self class]
                         originalSelector:@selector(viewWillAppear:)
                         swizzledSelector:@selector(AA_viewWillAppear:)];
    });
}

- (void)AA_viewWillAppear:(BOOL)animated {

    NSLog(@"UIViewController");

    // call original method
    [self AA_viewWillAppear:animated];
}

- (void)personEat {
    Person *p = [[Person alloc] init];
    [p performSelector:@selector(eat)];
}

- (void)observePerson {
    self.person = [[Person alloc] init];
    self.person.age = 30;
    NSKeyValueObservingOptions options =
        NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.person addObserver:self
                  forKeyPath:@"age"
                     options:options
                     context:@"test info"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.person.age = 35;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == @"test info") {
        NSLog(@"%@", @"code to be executed upon observing keypath");
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

@end
