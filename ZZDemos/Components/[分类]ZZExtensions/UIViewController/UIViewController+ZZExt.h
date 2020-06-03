#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZZExt)

/// 获取最顶层控制器
+ (instancetype)currentRootViewController;

/// 获取当前控制器
+ (instancetype)currentTopViewController;

@end

NS_ASSUME_NONNULL_END
