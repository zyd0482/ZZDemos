#import "UIImage+ZZExt.h"

@implementation UIImage (ZZExt)

+ (instancetype)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)stretchCenterImage {
    CGFloat vertical = self.size.height / 2.0;
    CGFloat horizontal = self.size.width / 2.0;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(vertical, horizontal, vertical, horizontal) resizingMode:UIImageResizingModeStretch];
}


+ (instancetype)t_imageInMainBundleWithName:(NSString *)imageName {
    if (![imageName length]) return nil;
    NSString *path = [NSBundle.mainBundle pathForResource:imageName ofType:nil];
    if (![path length]) return nil;
    return [UIImage imageWithContentsOfFile:path];
}


@end
