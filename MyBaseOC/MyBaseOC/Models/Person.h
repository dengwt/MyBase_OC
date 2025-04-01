//
//  Person.h
//  MyBaseOC
//
//  Created by dengwt on 2025/3/4.
//

#import "NSObject+Model.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(strong, nonatomic) NSString *name;

@property(assign, nonatomic) int age;

@end

NS_ASSUME_NONNULL_END
