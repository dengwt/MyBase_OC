//
//  NSObject+Model.h
//  MyBaseOC
//
//  Created by LIANDI on 2025/3/4.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Model)

- (void)xx_modelEncodeWithCoder:(NSCoder *)aCoder;

- (instancetype)xx_modelInitWithCoder:(NSCoder *)aDecoder;

@end

NS_ASSUME_NONNULL_END
