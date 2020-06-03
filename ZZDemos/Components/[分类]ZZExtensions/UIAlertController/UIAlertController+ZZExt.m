#import "UIAlertController+ZZExt.h"

@implementation UIAlertController (ZZExt)

#pragma mark - 快捷弹窗
+ (void)showAlertWithMessage:(NSString *)message
                   okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler
               cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:okHandler]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelHandler]];
        [UIViewController.currentRootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void)showAlertWithMessage:(NSString *)message
                   okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:okHandler]];
        [UIViewController.currentRootViewController presentViewController:alertController animated:YES completion:nil];
    });
}

+ (void)showAlertWithMessage:(NSString *)message {
    [self showAlertWithMessage:message okHandler:nil];
}


#pragma mark - Debug模式下的切网提示
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
+ (void)showNetChangeAlertWithNet:(NSString *)net target:(id)target action:(SEL)action {
#ifdef DEBUG
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = [NSString stringWithFormat:@"需要切换到[%@]\n确认网络无误后继续执行操作", net];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull alertAction) {
            if ([target respondsToSelector:action]) {
                [target performSelector:action];
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [UIViewController.currentRootViewController presentViewController:alertController animated:YES completion:nil];
    });
#else
    if ([target respondsToSelector:action]) {
        [target performSelector:action];
    }
#endif
}
#pragma clang diagnostic pop

+ (void)showNetChangeAlertWithNet:(NSString *)net completeHandler:(void (^)(void))handler {
#ifdef DEBUG
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *message = [NSString stringWithFormat:@"需要切换到[%@]\n确认网络无误后继续执行操作", net];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull alertAction) {
            if (handler) handler();
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [UIViewController.currentRootViewController presentViewController:alertController animated:YES completion:nil];
    });
#else
    if (handler) handler();
#endif
}

@end
