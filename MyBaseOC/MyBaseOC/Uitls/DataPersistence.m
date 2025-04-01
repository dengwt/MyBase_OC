//
//  StoreDataUtils.m
//  MyBaseOC
//
//  Created by dengwt on 2025/4/1.
//

#import "DataPersistence.h"

// Keychain配置
static NSString *kKeychainService;

static void initializeKeychainService(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      kKeychainService =
          [[NSBundle mainBundle] bundleIdentifier] ?: @"com.default.service";
    });
}

@implementation DataPersistence

#pragma mark - 初始化
+ (void)initialize {
    initializeKeychainService();
}

#pragma mark - 通用接口实现
+ (BOOL)saveData:(id)data
          forKey:(NSString *)key
            type:(DataPersistenceType)type
           error:(NSError **)error {
    switch (type) {
    case DataPersistenceTypeUserDefaults:
        return [self saveToUserDefaults:data key:key error:error];
    case DataPersistenceTypePlist:
        return [self saveToPlist:data fileName:key error:error];
    case DataPersistenceTypeArchive:
        return [self archiveData:data fileName:key error:error];
    case DataPersistenceTypeKeychain:
        return [self saveToKeychain:data account:key error:error];
    }
}

+ (id)loadData:(NSString *)key
          type:(DataPersistenceType)type
         error:(NSError **)error {
    switch (type) {
    case DataPersistenceTypeUserDefaults:
        return [self loadFromUserDefaults:key error:error];
    case DataPersistenceTypePlist:
        return [self loadFromPlist:key error:error];
    case DataPersistenceTypeArchive:
        return [self unarchiveData:key error:error];
    case DataPersistenceTypeKeychain:
        return [self loadFromKeychain:key
                          objectClass:[NSObject class]
                                error:error];
    }
}

+ (BOOL)removeData:(NSString *)key
              type:(DataPersistenceType)type
             error:(NSError **)error {
    switch (type) {
    case DataPersistenceTypeUserDefaults:
        return [self removeFromUserDefaults:key error:error];
    case DataPersistenceTypePlist:
        return [self removePlistFile:key error:error];
    case DataPersistenceTypeArchive:
        return [self removeArchiveFile:key error:error];
    case DataPersistenceTypeKeychain:
        return [self removeFromKeychain:key error:error];
    }
}

#pragma mark - UserDefaults
+ (void)saveToUserDefaults:(id)data forKey:(NSString *)key {
    [self saveToUserDefaults:data key:key error:nil];
}

+ (id)loadFromUserDefaults:(NSString *)key {
    return [self loadFromUserDefaults:key error:nil];
}

+ (BOOL)saveToUserDefaults:(id)data
                       key:(NSString *)key
                     error:(NSError **)error {
    if (![self validatePlistObject:data]) {
        if (error)
            *error = [NSError errorWithDomain:@"DataPersistenceErrorDomain"
                                         code:1001
                                     userInfo:@{
                                         NSLocalizedDescriptionKey :
                                             @"Invalid UserDefaults data type"
                                     }];
        return NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
    return YES;
}

+ (id)loadFromUserDefaults:(NSString *)key error:(NSError **)error {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (BOOL)removeFromUserDefaults:(NSString *)key error:(NSError **)error {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    return YES;
}

#pragma mark - Plist文件
+ (NSString *)plistPath:(NSString *)fileName {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask, YES)
                .firstObject
        stringByAppendingPathComponent:
            [fileName stringByAppendingPathExtension:@"plist"]];
}

+ (BOOL)saveToPlist:(id)data
           fileName:(NSString *)fileName
              error:(NSError **)error {
    if (![self validatePlistObject:data]) {
        if (error)
            *error = [NSError errorWithDomain:@"DataPersistenceErrorDomain"
                                         code:1002
                                     userInfo:@{
                                         NSLocalizedDescriptionKey :
                                             @"Invalid Plist data type"
                                     }];
        return NO;
    }
    return [data writeToFile:[self plistPath:fileName] atomically:YES];
}

+ (id)loadFromPlist:(NSString *)fileName error:(NSError **)error {
    NSString *path = [self plistPath:fileName];
    return [NSArray arrayWithContentsOfFile:path]
               ?: [NSDictionary dictionaryWithContentsOfFile:path];
}

+ (BOOL)removePlistFile:(NSString *)fileName error:(NSError **)error {
    return [self removeFileAtPath:[self plistPath:fileName] error:error];
}

#pragma mark - 对象归档
+ (NSString *)archivePath:(NSString *)fileName {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                NSUserDomainMask, YES)
                .firstObject stringByAppendingPathComponent:fileName];
}

+ (BOOL)archiveData:(id)data
           fileName:(NSString *)fileName
              error:(NSError **)error {
    if (![data conformsToProtocol:@protocol(NSSecureCoding)]) {
        if (error)
            *error =
                [NSError errorWithDomain:@"DataPersistenceErrorDomain"
                                    code:1003
                                userInfo:@{
                                    NSLocalizedDescriptionKey :
                                        @"Object must implement NSSecureCoding"
                                }];
        return NO;
    }

    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data
                                                 requiringSecureCoding:YES
                                                                 error:error];
    if (!archivedData)
        return NO;

    return [archivedData writeToFile:[self archivePath:fileName]
                             options:NSDataWritingAtomic
                               error:error];
}

+ (id)unarchiveData:(NSString *)fileName error:(NSError **)error {
    NSData *data = [NSData dataWithContentsOfFile:[self archivePath:fileName]
                                          options:0
                                            error:error];
    return data ? [NSKeyedUnarchiver unarchivedObjectOfClass:[NSObject class]
                                                    fromData:data
                                                       error:error]
                : nil;
}

+ (BOOL)removeArchiveFile:(NSString *)fileName error:(NSError **)error {
    return [self removeFileAtPath:[self archivePath:fileName] error:error];
}

#pragma mark - Keychain
+ (NSMutableDictionary *)keychainQuery:(NSString *)account {
    initializeKeychainService();
    return [@{
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService : kKeychainService,
        (__bridge id)kSecAttrAccount : account,
        (__bridge id)kSecAttrAccessible :
            (__bridge id)kSecAttrAccessibleWhenUnlockedThisDeviceOnly
    } mutableCopy];
}

+ (BOOL)saveToKeychain:(id<NSSecureCoding>)data
               account:(NSString *)account
                 error:(NSError **)error {
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:data
                                                 requiringSecureCoding:YES
                                                                 error:error];
    if (!archivedData)
        return NO;

    NSMutableDictionary *query = [self keychainQuery:account];
    [query setObject:archivedData forKey:(__bridge id)kSecValueData];

    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    if (status == errSecDuplicateItem) {
        [self removeFromKeychain:account error:error];
        status = SecItemAdd((__bridge CFDictionaryRef)query, NULL);
    }

    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                     code:status
                                 userInfo:nil];
        return NO;
    }
    return YES;
}

+ (id)loadFromKeychain:(NSString *)account
           objectClass:(Class)cls
                 error:(NSError **)error {
    NSMutableDictionary *query = [self keychainQuery:account];
    [query setObject:@YES forKey:(__bridge id)kSecReturnData];
    [query setObject:(__bridge id)kSecMatchLimitOne
              forKey:(__bridge id)kSecMatchLimit];

    CFTypeRef result = NULL;
    OSStatus status =
        SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);

    if (status != errSecSuccess) {
        if (error)
            *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                         code:status
                                     userInfo:nil];
        return nil;
    }

    NSData *data = (__bridge_transfer NSData *)result;
    return [NSKeyedUnarchiver unarchivedObjectOfClass:cls
                                             fromData:data
                                                error:error];
}

+ (BOOL)removeFromKeychain:(NSString *)account error:(NSError **)error {
    NSMutableDictionary *query = [self keychainQuery:account];
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)query);

    if (status != errSecSuccess && error) {
        *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                     code:status
                                 userInfo:nil];
        return NO;
    }
    return YES;
}

#pragma mark - 通用辅助方法
+ (BOOL)removeFileAtPath:(NSString *)path error:(NSError **)error {
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        if (error)
            *error = [NSError
                errorWithDomain:@"DataPersistenceErrorDomain"
                           code:404
                       userInfo:@{
                           NSLocalizedDescriptionKey : @"File not exist"
                       }];
        return NO;
    }
    return [fm removeItemAtPath:path error:error];
}

+ (BOOL)validatePlistObject:(id)obj {
    return [obj isKindOfClass:[NSArray class]] ||
           [obj isKindOfClass:[NSDictionary class]] ||
           [obj isKindOfClass:[NSString class]] ||
           [obj isKindOfClass:[NSNumber class]] ||
           [obj isKindOfClass:[NSDate class]] ||
           [obj isKindOfClass:[NSData class]];
}

@end
