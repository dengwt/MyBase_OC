//
//  GCDUtils.m
//  MyBaseOC
//
//  Created by dengwt on 2025/3/20.
//

#import "GCDUtils.h"

@interface GCDUtils ()

@property(assign, nonatomic) int ticketSurplusCount;

@end

@implementation GCDUtils

dispatch_semaphore_t semaphoreLock;
/**
 * 同步执行 + 并发队列
 * 特点：在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncConcurrent {
    NSLog(@"current thread:%@", [NSThread currentThread]);
    NSLog(@"syncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });

    NSLog(@"syncConcurrent---end");
}

/**
 * 异步执行 + 并发队列
 * 特点：可以开启多个线程，任务交替（同时）执行。
 */
- (void)asyncConcurrent {
    NSLog(@"current thread:%@", [NSThread currentThread]);
    NSLog(@"syncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });

    NSLog(@"asyncConcurrent---end");
}

/**
 * 同步执行 + 串行队列
 * 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)syncSerial {
    NSLog(@"current thread:%@", [NSThread currentThread]);
    NSLog(@"syncSerial---begin");
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_SERIAL);

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });

    NSLog(@"syncSerial---end");
}

/**
 * 异步执行 + 串行队列
 * 特点：会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)asyncSerial {
    NSLog(@"current thread:%@", [NSThread currentThread]);
    NSLog(@"asyncSerial---begin");
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_SERIAL);

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });

    NSLog(@"asyncSerial---end");
}

/**
 * 同步执行 + 主队列
 * 特点(主线程调用)：互等卡主不执行。
 * 特点(其他线程调用)：不会开启新线程，执行完一个任务，再执行下一个任务。
 */
- (void)syncMainQueue {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"syncMainQueue---begin");

    dispatch_queue_t queue = dispatch_get_main_queue();

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_sync(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });

    NSLog(@"syncMainQueue---end");
}

/**
 * 异步执行 + 主队列
 * 特点：只在主线程中执行任务，执行完一个任务，再执行下一个任务
 */
- (void)asyncMainQueue {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"asyncMainQueue---begin");

    dispatch_queue_t queue = dispatch_get_main_queue();

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });

    NSLog(@"asyncMainQueue---end");
}

/**
 * 线程间通信
 */
- (void)communication {
    // 获取全局并发队列
    dispatch_queue_t queue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    // 获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程

      // 回到主线程
      dispatch_async(mainQueue, ^{
        [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
        NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
      });
    });
}

/**
 * 栅栏方法 dispatch_barrier_async
 */
- (void)barrier {
    dispatch_queue_t queue = dispatch_queue_create("testQueue", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    });
    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_barrier_async(queue, ^{
      // 追加任务 barrier
      [NSThread sleepForTimeInterval:2];                // 模拟耗时操作
      NSLog(@"barrier---%@", [NSThread currentThread]); // 打印当前线程
    });

    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
    });
    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
    });
}

/**
 * 延时执行方法 dispatch_after
 */
- (void)after {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"asyncMain---begin");

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          // 2.0 秒后异步追加任务代码到主队列，并开始执行
          NSLog(@"after---%@", [NSThread currentThread]); // 打印当前线程
        });
}

/**
 * 一次性代码（只执行一次）dispatch_once
 */
- (void)once {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
                      // 只执行 1 次的代码（这里面默认是线程安全的）
                  });
}

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"group---begin");

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
          NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
          NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程

      NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"group---begin");

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程

      dispatch_group_leave(group);
    });

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程

      dispatch_group_leave(group);
    });

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      // 等前面的异步操作都执行完毕后，回到主线程.
      [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
      NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程

      NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"group---begin");

    dispatch_group_t group = dispatch_group_create();

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
          NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
        });

    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [NSThread sleepForTimeInterval:2];          // 模拟耗时操作
          NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        });

    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);

    NSLog(@"group---end");
}

/**
 * 线程安全：使用 semaphore 加锁
 * 初始化火车票数量、卖票窗口（线程安全）、并开始卖票
 */
- (void)initTicketStatusSave {
    NSLog(@"currentThread---%@", [NSThread currentThread]); // 打印当前线程
    NSLog(@"semaphore---begin");

    semaphoreLock = dispatch_semaphore_create(1);

    self.ticketSurplusCount = 50;

    // queue1 代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("testQueue1", DISPATCH_QUEUE_SERIAL);
    // queue2 代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("testQueue2", DISPATCH_QUEUE_SERIAL);

    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
      [weakSelf saleTicketSafe];
    });

    dispatch_async(queue2, ^{
      [weakSelf saleTicketSafe];
    });
}

/**
 * 售卖火车票（线程安全）
 */
- (void)saleTicketSafe {
    while (1) {
        // 相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);

        if (self.ticketSurplusCount > 0) { // 如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%d 窗口：%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { // 如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");

            // 相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }

        // 相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}

@end
