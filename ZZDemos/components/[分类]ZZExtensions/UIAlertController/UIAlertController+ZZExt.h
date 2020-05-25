#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (ZZExt)

#pragma mark - 快捷弹窗
/**
 弹窗
 title显示"温馨提示"
 两个按钮 确认和取消
*/
+ (void)showAlertWithMessage:(NSString *)message
                   okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler
               cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

/**
 弹窗
 title显示"温馨提示"
 只有一个按钮,并且带回调
*/
+ (void)showAlertWithMessage:(NSString *)message
                   okHandler:(void (^ __nullable)(UIAlertAction *action))okHandler;

/**
 弹窗
 title显示"温馨提示"
 只有一个确认按钮
*/
+ (void)showAlertWithMessage:(NSString *)message;


#pragma mark - Debug模式下的切网提示
/// 切网提示 通过target和action回调
+ (void)showNetChangeAlertWithNet:(NSString *)net target:(id)target action:(SEL)action;
/// 切网提示 通过block回调
+ (void)showNetChangeAlertWithNet:(NSString *)net completeHandler:(void (^)(void))handler;

@end

NS_ASSUME_NONNULL_END
