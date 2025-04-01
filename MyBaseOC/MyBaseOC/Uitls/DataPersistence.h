//
//  StoreDataUtils.h
//  MyBaseOC
//
//  Created by dengwt on 2025/4/1.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DataPersistenceType) {
    DataPersistenceTypeUserDefaults,
    DataPersistenceTypePlist,
    DataPersistenceTypeArchive,
    DataPersistenceTypeKeychain
};

@interface DataPersistence : NSObject

#pragma mark - 通用接口
+ (BOOL)saveData:(id)data
         forKey:(NSString *)key
           type:(DataPersistenceType)type
          error:(NSError **)error;

+ (id _Nullable)loadData:(NSString *)key
                   type:(DataPersistenceType)type
                  error:(NSError **)error;

+ (BOOL)removeData:(NSString *)key
             type:(DataPersistenceType)type
            error:(NSError **)error;

#pragma mark - 快捷方法
// UserDefaults
+ (void)saveToUserDefaults:(id)data forKey:(NSString *)key;
+ (id _Nullable)loadFromUserDefaults:(NSString *)key;

// Plist
+ (BOOL)saveToPlist:(id)data fileName:(NSString *)fileName error:(NSError **)error;
+ (id _Nullable)loadFromPlist:(NSString *)fileName error:(NSError **)error;

// Keychain
+ (BOOL)saveToKeychain:(id<NSSecureCoding>)data account:(NSString *)account error:(NSError **)error;
+ (id _Nullable)loadFromKeychain:(NSString *)account objectClass:(Class)cls error:(NSError **)error;

@end

NS_ASSUME_NONNULL_END
