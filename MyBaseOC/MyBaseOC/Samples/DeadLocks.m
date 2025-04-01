//
//  DeadLocks.m
//  MyBaseOC
//
//  Created by dengwt on 2025/3/21.
//

#import "DeadLocks.h"
#import <os/lock.h>
#include <pthread.h>

@implementation DeadLocks {
    NSMutableArray *_elements;
}

// 控制台输出：1 ，后面就崩溃了。
- (void)deadLockCase1 {
    NSLog(@"1"); // 任务1
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"2"); // 任务2
    });
    NSLog(@"3"); // 任务3
}

// 控制台输出：1 2 ，执行到2后面就崩溃了。
- (void)deadLockCase2 {
    dispatch_queue_t aSerialDispatchQueue = dispatch_queue_create("com.test.deadlock.queue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1"); //任务1
    dispatch_sync(aSerialDispatchQueue, ^{
        NSLog(@"2"); //任务2
        dispatch_sync(aSerialDispatchQueue, ^{
            NSLog(@"3"); //任务3
        });
        NSLog(@"4");  //任务4
    });
    NSLog(@"5");  //任务5
}

- (void)viewDidLoad {
    // need to write in viewcontroller
//    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSLog(@"semaphore create!");
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_semaphore_signal(semaphore);
        NSLog(@"semaphore plus 1");
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore minus 1");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _elements = [NSMutableArray array];
    }
    return self;
}

- (void)increment:(id) element {
    @synchronized (self) {
        [_elements addObject:element];
    }
}

- (void)demoOfLock {
    @autoreleasepool {
        // spin lock
        __block os_unfair_lock spinLock = OS_UNFAIR_LOCK_INIT;
        __block int spinCounter = 0;
        dispatch_group_t spinGroup = dispatch_group_create();
        for (int i = 0; i < 1000; i++) {
            dispatch_group_enter(spinGroup);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                os_unfair_lock_lock(&spinLock);
                spinCounter++;
                os_unfair_lock_unlock(&spinLock);
                dispatch_group_leave(spinGroup);
            });
        }
        dispatch_group_wait(spinGroup, DISPATCH_TIME_FOREVER);
        
        // mutex lock
        __block int mutexCounter = 0;
        __block pthread_mutex_t mutex;
        pthread_mutex_init(&mutex, NULL);
        dispatch_group_t mutexGroup = dispatch_group_create();
        for (int i = 0; i < 1000; i++) {
            dispatch_group_enter(mutexGroup);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                pthread_mutex_lock(&mutex);
                mutexCounter++;
                pthread_mutex_unlock(&mutex);
                dispatch_group_leave(mutexGroup);
            });
        }
        dispatch_group_wait(mutexGroup, DISPATCH_TIME_FOREVER);
        pthread_mutex_destroy(&mutex);
        
        // read/write lock
        __block int rwCounter = 0;
        __block pthread_rwlock_t rwlock;
        pthread_rwlock_init(&rwlock, NULL);
        dispatch_group_t rwGroup = dispatch_group_create();
        // read lock
        for (int i = 0; i < 1000; i++) {
            dispatch_group_enter(rwGroup);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                pthread_rwlock_rdlock(&rwlock);
                mutexCounter++;
                pthread_rwlock_unlock(&rwlock);
                dispatch_group_leave(rwGroup);
            });
        }
        // write lock
        for (int i = 0; i < 1000; i++) {
            dispatch_group_enter(rwGroup);
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
                pthread_rwlock_wrlock(&rwlock);
                mutexCounter++;
                pthread_rwlock_unlock(&rwlock);
                dispatch_group_leave(rwGroup);
            });
        }
        dispatch_group_wait(rwGroup, DISPATCH_TIME_FOREVER);
        pthread_rwlock_destroy(&rwlock);
    }
}

@end
