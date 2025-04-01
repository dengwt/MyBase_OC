//
//  SavedData.h
//  MyBaseOC
//
//  Created by dengwt on 2025/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavedData : NSObject<NSCoding>

/**name*/
@property(nonatomic ,copy)NSString *name;
/**age*/
@property(nonatomic ,assign)NSInteger age;
/**sex*/
@property(nonatomic ,assign)BOOL sex;

@end

NS_ASSUME_NONNULL_END
