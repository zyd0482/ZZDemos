#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZDevicePermissionChecker : NSObject

/// 检查视频权限
+ (void)checkVideoEnable:(void (^)(BOOL enable))complete;
/// 检查麦克风权限
+ (void)checkAudioEnable:(void (^)(BOOL enable))complete;
/// 检查相册权限
+ (void)checkPhotoEnable:(void (^)(BOOL enable))complete;
/// 通讯录权限
+ (void)checkContactsEnable:(void (^)(BOOL enable))complete;

@end

NS_ASSUME_NONNULL_END
