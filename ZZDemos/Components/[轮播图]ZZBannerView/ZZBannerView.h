#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZBannerView;
@protocol ZZBannerViewDelegate <NSObject>

@required
/// 数据总量
- (NSInteger)bannerViewCountOfDatas:(ZZBannerView *)banner;
/// 图片URL
- (NSURL *)bannerView:(ZZBannerView *)banner urlForIndex:(NSInteger)index;

@optional
/// 点击图片
- (void)bannerView:(ZZBannerView *)banner didClickWithIndex:(NSInteger)index;

@end

@interface ZZBannerView : UIView

/// 自动滚动的动画间隔时长(秒) 设置为0表示不自动滚动
@property (nonatomic, assign) int autoScrollDuration;

@property (nonatomic, weak) id<ZZBannerViewDelegate> delegate;

/// 重新加载
- (void)reloadDatas;

@end

NS_ASSUME_NONNULL_END
