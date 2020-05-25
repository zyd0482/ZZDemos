#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZZExt)

/// 添加单击手势操作
- (void)addTapGestureWithTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
