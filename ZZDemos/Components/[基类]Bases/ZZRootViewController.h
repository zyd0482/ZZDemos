#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZRootViewController : UIViewController

/// 隐藏导航栏控制器 默认NO
@property (nonatomic, assign) BOOL hideNavigationBar;
/// 隐藏导航栏的返回箭头 默认NO
@property (nonatomic, assign) BOOL hideNagigationBackButton;
/// 禁止手势滑动返回 默认NO
@property (nonatomic, assign) BOOL disablePopGesture;

/// 返回上一页 当点击左上角返回箭头的时候触发
- (void)doGoBack;

/// 配置导航栏
- (void)setupNavigationBar;

@end

NS_ASSUME_NONNULL_END
