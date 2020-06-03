#import "ZZBannerView.h"
#import <YYWebImage/YYWebImage.h>

static NSInteger const kDefaultScrollInterval = 5;

typedef NS_ENUM(NSUInteger, ZZBannerViewScrollType) {
    ZZBannerViewScrollTypeStatic, // 非滑动状态
    ZZBannerViewScrollTypeLeft,
    ZZBannerViewScrollTypeRight
};

@interface ZZBannerView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *displayView;
@property (nonatomic, weak) UIImageView *reuseView;
@property (nonatomic, weak) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ZZBannerView {
    ZZBannerViewScrollType _scrollType;
    NSInteger _currentDisplayIndex;
    
    struct {
        unsigned int Count : 1;
        unsigned int Url : 1;
        unsigned int Click : 1;
    } _delegateFlag;
    
    NSInteger _total;
}

#pragma mark - life cycle
- (void)removeFromSuperview {
    [self stopTimer];
    [super removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _autoScrollDuration = kDefaultScrollInterval;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, 0);
    CGFloat vWidth = self.scrollView.frame.size.width;
    CGFloat vHeight = self.scrollView.frame.size.height;
    self.displayView.frame = CGRectMake(vWidth, 0, vWidth, vHeight);
    self.reuseView.frame = CGRectMake(0, 0, vWidth, vHeight);
    
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:_total];
    CGFloat pageX = self.frame.size.width - pageSize.width - 10;
    CGFloat pageY = self.frame.size.height - pageSize.height;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageSize.width, pageSize.height);
    
    if (self.scrollView.contentOffset.x < 1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    }
}

#pragma mark - public
- (void)reloadDatas {
    [self stopTimer];
    self.scrollView.hidden = YES;
    self.pageControl.hidden = YES;
    _total = [self.delegate bannerViewCountOfDatas:self];
    if (_total < 1) return;
    self.scrollView.hidden = NO;
    self.pageControl.hidden = NO;
    self.pageControl.numberOfPages = _total;
    [self bringSubviewToFront:self.pageControl];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    _scrollType = ZZBannerViewScrollTypeStatic;
    _currentDisplayIndex = 0;
    [self loadDisplayInfo];
    if (self.autoScrollDuration > 0) {
        [self startTimer];
    }
}

#pragma mark - click actions
- (void)displayViewDidClick {
    if (_delegateFlag.Click) {
        [self.delegate bannerView:self didClickWithIndex:_currentDisplayIndex];
    }
}

#pragma mark - timer
- (void)startTimer {
    if (self.timer) [self stopTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollDuration target:self selector:@selector(scrolledHandler) userInfo:nil repeats:YES];
    [NSRunLoop.mainRunLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrolledHandler {
    [self.scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.autoScrollDuration > 0) [self startTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat cosX = scrollView.contentOffset.x;
    if (![self isDisplayViewInScreen]) {
        // update _currentDisplayIndex
        if (_scrollType == ZZBannerViewScrollTypeLeft) {
            _currentDisplayIndex = [self formatIndexWithIndex:_currentDisplayIndex - 1];
        } else if (_scrollType == ZZBannerViewScrollTypeRight) {
            _currentDisplayIndex = [self formatIndexWithIndex:_currentDisplayIndex + 1];
        }
        // reset _scrollType
        _scrollType = ZZBannerViewScrollTypeStatic;
        [self loadDisplayInfo];
    } else if (cosX > scrollView.frame.size.width) {
        if (_scrollType != ZZBannerViewScrollTypeRight) {
            _scrollType = ZZBannerViewScrollTypeRight;
            [self loadReuseInfo];
        }
    } else if (cosX < scrollView.frame.size.width) {
        if (_scrollType != ZZBannerViewScrollTypeLeft) {
            _scrollType = ZZBannerViewScrollTypeLeft;
            [self loadReuseInfo];
        }
    }
}

#pragma mark - private
- (BOOL)isDisplayViewInScreen {
    CGFloat conX = self.scrollView.contentOffset.x;
    CGFloat scrollWidth = CGRectGetWidth(self.scrollView.frame);
    return (conX > 0) && (conX < scrollWidth * 2);
}

- (NSInteger)formatIndexWithIndex:(NSInteger)idx {
    NSInteger resultIdx = idx;
    if (resultIdx < 0) {
        resultIdx = _total - 1;
    } else if (resultIdx >= _total) {
        resultIdx = 0;
    }
    return resultIdx;
}

- (void)loadDisplayInfo {
    if (!_delegateFlag.Url) return;
    NSURL *url = [self.delegate bannerView:self urlForIndex:_currentDisplayIndex];
    [self.displayView yy_setImageWithURL:url placeholder:nil];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
    self.pageControl.currentPage = _currentDisplayIndex;
    NSLog(@"显示图片 %ld", _currentDisplayIndex);
}

- (void)loadReuseInfo {
    if (!_delegateFlag.Url) return;
    CGRect frame = self.reuseView.frame;
    if (frame.size.width < 1) {
        frame.size.width = self.scrollView.frame.size.width;
        frame.size.height = self.scrollView.frame.size.height;
    }
    NSInteger reuseIndex = _currentDisplayIndex;
    if (_scrollType == ZZBannerViewScrollTypeLeft) {
        frame.origin.x = 0;
        reuseIndex = [self formatIndexWithIndex:reuseIndex - 1];
    } else {
        frame.origin.x = self.scrollView.frame.size.width * 2;
        reuseIndex = [self formatIndexWithIndex:reuseIndex + 1];
    }
    self.reuseView.frame = frame;
    NSURL *url = [self.delegate bannerView:self urlForIndex:reuseIndex];
    [self.reuseView yy_setImageWithURL:url placeholder:nil];
}

#pragma mark - setter
- (void)setDelegate:(id<ZZBannerViewDelegate>)delegate {
    _delegate = delegate;
    _delegateFlag.Count = [_delegate respondsToSelector:@selector(bannerViewCountOfDatas:)];
    _delegateFlag.Url = [_delegate respondsToSelector:@selector(bannerView:urlForIndex:)];
    _delegateFlag.Click = [_delegate respondsToSelector:@selector(bannerView:didClickWithIndex:)];
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self addSubview:scrollView];
        _scrollView = scrollView;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [self addSubview:pageControl];
        _pageControl = pageControl;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _pageControl;
}

- (UIImageView *)displayView {
    if (!_displayView) {
        UIImageView *displayView = [[UIImageView alloc] init];
        [self.scrollView addSubview:displayView];
        _displayView = displayView;
        _displayView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayViewDidClick)];
        [_displayView addGestureRecognizer:tgr];
    }
    return _displayView;
}

- (UIImageView *)reuseView {
    if (!_reuseView) {
        UIImageView *reuseView = [[UIImageView alloc] init];
        [self.scrollView addSubview:reuseView];
        _reuseView = reuseView;
    }
    return _reuseView;
}

@end
