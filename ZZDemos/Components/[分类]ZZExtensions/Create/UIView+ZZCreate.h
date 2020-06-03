#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark ========== View ==========
@interface UIView (ZZCreate)

#pragma mark - 外部调用
+ (instancetype)addIn:(UIView *)view;

#pragma mark - 子类重写
- (void)_defaultConfigure;

@end


#pragma mark ========== ScrollView ==========
@interface UIScrollView (ZZCreate)

@end


#pragma mark ========== UITableView ==========
@interface UITableView (ZZCreate)

@end

NS_ASSUME_NONNULL_END
