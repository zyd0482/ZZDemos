#import "TLBGuidingVC.h"

static NSInteger kGuidingMaxCount = 4;

#pragma mark -BG Content
@interface TLBGuidingBGContentView : UIView

@property (nonatomic, weak) UIImageView *titleIV;
@property (nonatomic, weak) UIImageView *subtitleIV;
@property (nonatomic, weak) UIImageView *starsView;


@end

@implementation TLBGuidingBGContentView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.starsView.frame = self.bounds;
    CGFloat titleMaxHeight = self.height * 0.25;
    self.subtitleIV.frame = CGRectMake(0, 0, 150, 150.0/342.0*47.0);
    self.subtitleIV.width = 100.f;
    self.subtitleIV.height = self.subtitleIV.width / 342.0 * 47.0;
    self.subtitleIV.bottom = titleMaxHeight;
    self.subtitleIV.centerX = self.width / 2;
    
    self.titleIV.width = 130.0f;
    self.titleIV.height = self.titleIV.width / 333.0 * 78.0;
    self.titleIV.bottom = self.subtitleIV.top - 15;
    self.titleIV.centerX = self.width / 2;
}

- (void)updateSetpWithIndex:(NSInteger)index {
    [self addTransitionIn:self.titleIV type:@"fade" duration:0.5f name:@"a"];
    [self.titleIV setImage:[UIImage t_imageInMainBundleWithName:[NSString stringWithFormat:@"引导_文字_主_%ld.png", index]]];
    [self addTransitionIn:self.subtitleIV type:@"cube" duration:0.5f name:@"b"];
    [self.subtitleIV setImage:[UIImage t_imageInMainBundleWithName:[NSString stringWithFormat:@"引导_文字_副_%ld.png", index]]];
    [self addTransitionIn:self.starsView type:@"oglFlip" duration:1.0f name:@"c"];
    [self.starsView setImage:[UIImage t_imageInMainBundleWithName:[NSString stringWithFormat:@"引导_背景元素_%ld.png", index]]];
}

- (void)addTransitionIn:(UIView *)view type:(NSString *)type duration:(float)duration name:(NSString *)name {
    CATransition *transition = [CATransition animation];
    transition.duration = duration;
    transition.type = type;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:transition forKey:name];
}

#pragma mark - getter
- (UIImageView *)starsView {
    if (!_starsView) {
        UIImageView *iv = [[UIImageView alloc] init];
        [self addSubview:iv];
        _starsView = iv;
    }
    return _starsView;
}

- (UIImageView *)titleIV {
    if (!_titleIV) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _titleIV = imageView;
    }
    return _titleIV;
}

- (UIImageView *)subtitleIV {
    if (!_subtitleIV) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _subtitleIV = imageView;
        CATransition *transition = [CATransition animation];
        transition.duration = 1.0;
        transition.type = @"SuckEffect";
        transition.removedOnCompletion = NO;
        [_subtitleIV.layer addAnimation:transition forKey:@"subtitleIVAnimation"];
    }
    return _subtitleIV;
}

@end








#pragma mark -Main
@interface TLBGuidingVC () <UIScrollViewDelegate>

@property (nonatomic, weak) TLBGuidingBGContentView *bgView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton *skipButton;
@property (nonatomic, weak) UIButton *completeButton;
@property (nonatomic, strong) NSArray<UIView *> *guidingItems;
@property (nonatomic, copy) TLBGuideCompleteBlock completeBlock;

@end

@implementation TLBGuidingVC {
    NSInteger _currentIndex;
}

+ (void)openGuidingFrom:(UIViewController *)vc complete:(TLBGuideCompleteBlock)complete {
    TLBGuidingVC *guidVC = [[TLBGuidingVC alloc] init];
    guidVC.modalPresentationStyle = UIModalPresentationFullScreen;
    guidVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    guidVC.completeBlock = complete;
    [vc presentViewController:guidVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setup];
    [self.bgView updateSetpWithIndex:0];
}

- (void)setup {
    NSMutableArray *array = [NSMutableArray new];
    for (int i = 0; i < kGuidingMaxCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [self p_guidingImageWithIndex:i];
        [self.scrollView addSubview:imageView];
        [array addObject:imageView];
    }
    self.guidingItems = array;
    [self.view sendSubviewToBack:self.bgView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.bgView.frame = self.view.bounds;
    self.scrollView.frame = self.view.bounds;
    for (int i = 0; i < self.guidingItems.count; i++) {
        [self p_layoutGuidingItemWithIndex:i];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * kGuidingMaxCount, 0);
    
    self.completeButton.frame = CGRectMake(0, 0, 120, 44);
    self.completeButton.bottom = self.view.height - 30 - (IPHONE_X ? 30 : 0);
    self.completeButton.centerX = self.view.width / 2;
    
    self.skipButton.frame = CGRectMake(0, 40 + (IPHONE_X ? 24 : 0), 60, 24);
    self.skipButton.right = self.view.width - 16;
}

- (UIImage *)p_guidingImageWithIndex:(NSInteger)index {
    return [UIImage t_imageInMainBundleWithName:[NSString stringWithFormat:@"引导_浮动图_%ld.png", index]];
}

- (void)p_layoutGuidingItemWithIndex:(NSInteger)index {
    UIView *view = [self.guidingItems objectAtIndex:index];
    CGFloat viewHeight = self.view.height * 0.62;
    CGFloat viewTop = self.scrollView.height - viewHeight;
    CGFloat viewWidth = viewHeight / 1470.0 * 1125;
    view.frame = CGRectMake(0, viewTop, viewWidth, viewHeight);
    view.centerX = self.scrollView.width / 2 + (index * self.scrollView.width);
}

#pragma mark - private
- (void)p_handleSetupWithIndex:(NSInteger)index {
    if (_currentIndex == index) return;
    _currentIndex = index;
    [self.bgView updateSetpWithIndex:index];
    
    [UIView animateWithDuration:0.2f animations:^{
        self.completeButton.alpha = (index == kGuidingMaxCount - 1 ? 1 : 0);
    }];
    [UIView animateWithDuration:0.2f animations:^{
        self.skipButton.alpha = (index != 0);
    }];
}

#pragma mark - click action
- (void)completeClick {
    [self dismissViewControllerAnimated:YES completion:^{
        self.completeBlock(YES);
        self.completeBlock = nil;
    }];
}

- (void)skipClick {
    [self dismissViewControllerAnimated:YES completion:^{
        self.completeBlock(NO);
        self.completeBlock = nil;
    }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self p_handleSetupWithIndex:index];
}

#pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = UIColor.clearColor;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (TLBGuidingBGContentView *)bgView {
    if (!_bgView) {
        TLBGuidingBGContentView *view = [[TLBGuidingBGContentView alloc] init];
        [self.view addSubview:view];
        _bgView = view;
    }
    return _bgView;
}

- (UIButton *)completeButton {
    if (!_completeButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:button];
        _completeButton = button;
        [_completeButton setTitle:@"立即体验" forState:UIControlStateNormal];
        _completeButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_completeButton addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
        _completeButton.alpha = 0;
        _completeButton.backgroundColor = UIColor.redColor;
        _completeButton.layer.cornerRadius = 22;
        [_completeButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    }
    return _completeButton;
}

- (UIButton *)skipButton {
    if (!_skipButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:button];
        _skipButton = button;
        [_skipButton setTitle:@"跳过" forState:UIControlStateNormal];
        _skipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_skipButton addTarget:self action:@selector(skipClick) forControlEvents:UIControlEventTouchUpInside];
        _skipButton.alpha = 0;
        [_skipButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        _skipButton.layer.borderWidth = 1;
        _skipButton.layer.cornerRadius = 12;
        _skipButton.layer.borderColor = UIColor.redColor.CGColor;
    }
    return _skipButton;
}

@end
