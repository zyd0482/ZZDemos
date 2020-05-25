#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZSafer : NSObject

/// 检查是否越狱
- (BOOL)isJailBroken;

/// 检查App是否被修改
- (BOOL)isAppChanged;

/// 监听用户截屏
- (void)userTakeScreenshot:(void(^)(NSNotification * _Nonnull note))handler;

@end

NS_ASSUME_NONNULL_END
