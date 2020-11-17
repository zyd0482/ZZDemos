#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TLBGuideCompleteBlock)(BOOL isClickCompleteButton);

@interface TLBGuidingVC : UIViewController

+ (void)openGuidingFrom:(UIViewController *)vc complete:(TLBGuideCompleteBlock)complete;

@end

NS_ASSUME_NONNULL_END
