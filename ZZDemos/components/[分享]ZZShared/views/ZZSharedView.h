#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZSharedView : UIView

@property (nonatomic, assign) BOOL wechatEnable;
@property (nonatomic, assign) BOOL qqEnable;
@property (nonatomic, assign) BOOL smsEnable;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

/// identify: wechat | qq | sms
- (void)showWithClickHandler:(void(^)(NSString *identify))handler;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
