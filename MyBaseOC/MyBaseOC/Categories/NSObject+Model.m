//
//  NSObject+Model.m
//  MyBaseOC
//
//  Created by LIANDI on 2025/3/4.
//

#import "NSObject+Model.h"

@implementation NSObject (Model)

// encoder
- (void)xx_modelEncodeWithCoder:(NSCoder *)aCoder {
    if (!aCoder)
        return;
    if (!self) {
        return;
    }
    unsigned int count;
    objc_property_t *propertyList =
        class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];

        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(propertyList);
}

// decode
- (instancetype)xx_modelInitWithCoder:(NSCoder *)aDecoder {
    if (!aDecoder)
        return self;
    if (!self) {
        return self;
    }

    unsigned int count;
    objc_property_t *propertyList =
        class_copyPropertyList([self class], &count);
    for (unsigned int i = 0; i < count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];

        id value = [aDecoder decodeObjectForKey:name];
        [self setValue:value forKey:name];
    }
    free(propertyList);

    return self;
}

@end
