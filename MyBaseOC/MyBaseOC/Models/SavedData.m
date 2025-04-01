//
//  SavedData.m
//  MyBaseOC
//
//  Created by dengwt on 2025/4/1.
//

#import "SavedData.h"

@implementation SavedData

// 归档
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeBool:self.sex forKey:@"sex"];
}

// 解档
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.age = [aDecoder decodeIntegerForKey:@"age"];
        self.sex = [aDecoder decodeBoolForKey:@"sex"];
    }
    return self;
}

@end
