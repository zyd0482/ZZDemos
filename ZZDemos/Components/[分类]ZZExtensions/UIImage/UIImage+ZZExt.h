#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (ZZExt)

/// 获取一张纯色的图片
+ (instancetype)imageWithColor:(UIColor *)color;

/// 从图片中心拉伸
- (UIImage *)stretchCenterImage;

@end

NS_ASSUME_NONNULL_END
