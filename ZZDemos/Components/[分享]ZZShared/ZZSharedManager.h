#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_OPTIONS(NSUInteger, ZZSharedOption) {
    ZZShareOptionWechat = 1 << 0,
    ZZShareOptionQQ = 1 << 1,
    ZZShareOptionSms = 1 << 2,
};

typedef void(^ZZSharedCompleteHandler)(void);

@interface ZZSharedInfo : NSObject

#pragma mark - 面板信息
/// 当前唤起分享面板的VC,在短信分享的时候需要设置,其他情况下可以置空
@property (nonatomic, weak) UIViewController *currentVC;
/// 面板的标题, 默认为"分享到"
@property (nonatomic, copy) NSString *panelTitle;
/// 面板的副标题,默认不显示.
@property (nonatomic, copy) NSString *panelSubTitle;

#pragma mark - 分享信息
/// 分享的标题
@property (nonatomic, copy) NSString *title;
/// 分享的描述信息
@property (nonatomic, copy) NSString *message;
/// 分享的链接
@property (nonatomic, copy) NSString *url;
/// 分享的缩略图名字
@property (nonatomic, copy) NSString *iconName;

@end


@interface ZZSharedManager : NSObject

/// 初始化分享组件(在app launch中调用)
+ (void)setup;

/// 分享回调处理(在appdelegate 中调用)
+ (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/// 调起分享面板
+ (void)openSharedWithOption:(ZZSharedOption)option info:(ZZSharedInfo *)info complete:(ZZSharedCompleteHandler)complete;

@end

NS_ASSUME_NONNULL_END
