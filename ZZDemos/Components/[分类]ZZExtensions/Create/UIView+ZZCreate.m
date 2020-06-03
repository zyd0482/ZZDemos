#import "UIView+ZZCreate.h"


#pragma mark ========== View ==========
@implementation UIView (ZZCreate)

#pragma mark - public
+ (instancetype)addIn:(UIView *)view {
    UIView *sub = [[self alloc] init];
    [view addSubview:sub];
    [sub _defaultConfigure];
    return sub;
}

- (void)_defaultConfigure {}

@end


#pragma mark ========== UIScrollView ==========
@implementation UIScrollView (ZZCreate)

- (void)_defaultConfigure {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end


#pragma mark ========== UITableView ==========
@implementation UITableView (ZZCreate)

- (void)_defaultConfigure {
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

@end
