#import "UIViewController+ZZExt.h"

@implementation UIViewController (ZZExt)

+ (instancetype)currentRootViewController {
    UIViewController *topVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    int overCount = 0;
    while (topVC.presentedViewController && overCount < 20) {
        topVC = topVC.presentedViewController;
        overCount++;
    }
    return topVC;
}

+ (instancetype)currentTopViewController {
    UIViewController *currentVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    int overCount = 0;
    while (overCount < 30) {
        if ([currentVC isKindOfClass:[UITabBarController class]]) {
            currentVC = ((UITabBarController *)currentVC).selectedViewController;
        }
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            currentVC = ((UINavigationController *)currentVC).visibleViewController;
        }
        if (currentVC.presentedViewController) {
            currentVC = currentVC.presentedViewController;
        } else {
            break;
        }
        overCount++;
    }
    return currentVC;
}

@end
