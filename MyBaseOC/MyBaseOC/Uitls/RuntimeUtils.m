//
//  RuntimeUtils.m
//  MyBaseOC
//
//  Created by LIANDI on 2025/3/4.
//

#import "RuntimeUtils.h"

@implementation RuntimeUtils

- (void)fetchIvarList:(Class)className {
    if (!className) {
        NSLog(@"Error: Class is nil.");
        return;
    }

    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(className, &count);

    if (ivarList) {
        NSLog(@"Instance variables for class: %@",
              NSStringFromClass(className));
        for (unsigned int i = 0; i < count; i++) {
            Ivar ivar = ivarList[i];
            const char *ivarName = ivar_getName(ivar);
            const char *ivarType = ivar_getTypeEncoding(ivar);
            NSLog(@"Ivar name: %s, Type: %s", ivarName, ivarType);
        }
        free(ivarList);
    } else {
        NSLog(@"No instance variables found for class: %@",
              NSStringFromClass(className));
    }
}

- (void)fetchPropertyList:(Class)className {
    if (!className) {
        NSLog(@"Error: Class is nil.");
        return;
    }

    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList(className, &count);

    if (propertyList) {
        NSLog(@"Properties for class: %@", NSStringFromClass(className));
        for (unsigned int i = 0; i < count; i++) {
            objc_property_t property = propertyList[i];
            const char *propertyName = property_getName(property);
            const char *propertyAttributes = property_getAttributes(property);
            NSLog(@"Property name: %s, Attributes: %s", propertyName,
                  propertyAttributes);
        }
        free(propertyList);
    } else {
        NSLog(@"No properties found for class: %@",
              NSStringFromClass(className));
    }
}

- (void)fetchMethodList:(Class)className {
    if (!className) {
        NSLog(@"Error: Class is nil.");
        return;
    }

    unsigned int count = 0;
    Method *methodList = class_copyMethodList(className, &count);

    if (methodList) {
        NSLog(@"Instance methods for class: %@", NSStringFromClass(className));
        for (unsigned int i = 0; i < count; i++) {
            Method method = methodList[i];
            SEL methodSEL = method_getName(method);
            const char *methodType = method_getTypeEncoding(method);

            NSLog(@"Method: %@, Type encoding: %s",
                  NSStringFromSelector(methodSEL), methodType);
        }
        free(methodList);
    } else {
        NSLog(@"No instance methods found for class: %@",
              NSStringFromClass(className));
    }
}

- (BOOL)isPropertyExist:(NSString *)propertyName inClass:(Class)className {
    Class currentClass = className;

    while (currentClass != nil) {
        unsigned int count;
        objc_property_t *propertyList =
            class_copyPropertyList(currentClass, &count);
        for (unsigned int i = 0; i < count; i++) {
            objc_property_t property = propertyList[i];
            const char *propertyString = property_getName(property);

            if ([propertyName
                    isEqualToString:[NSString
                                        stringWithUTF8String:propertyString]]) {
                free(propertyList);
                return YES;
            }
        }
        free(propertyList);

        // Move to the superclass
        currentClass = class_getSuperclass(currentClass);
    }

    return NO;
}

- (NSString *)categoryProperty {
    return objc_getAssociatedObject(
        self, _cmd); // _cmd is equivalent to @selector(categoryProperty)
}

- (void)setCategoryProperty:(NSString *)categoryProperty {
    objc_setAssociatedObject(self, @selector(categoryProperty),
                             categoryProperty,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
