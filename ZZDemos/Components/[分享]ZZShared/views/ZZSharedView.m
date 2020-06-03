#import "ZZSharedView.h"



#pragma mark ---------- Item ----------
@interface ZZSharedItem : UIButton
@end
@implementation ZZSharedItem

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageWidth = MIN(contentRect.size.width * 0.7, contentRect.size.height * 0.5);
    CGFloat imageY = (contentRect.size.height * 0.7 - imageWidth) * 0.5;
    CGFloat imageX = (contentRect.size.width - imageWidth) * 0.5;
    return CGRectMake(imageX, imageY, imageWidth, imageWidth);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height * 0.3;
    CGFloat titleY = contentRect.size.height - titleHeight;
    return CGRectMake(0, titleY, titleWidth, titleHeight);
}

@end


#pragma mark ---------- Main ----------
@interface ZZSharedView ()

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *line1View;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, strong) NSArray<UIView *> *buttons;
@property (nonatomic, weak) UIView *line2View;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UILabel *noneLabel;

@property (nonatomic, copy) void(^clickHandler)(NSString *identify);

@end

@implementation ZZSharedView

- (void)showWithClickHandler:(void(^)(NSString *identify))handler; {
    self.clickHandler = handler;
    [UIApplication.sharedApplication.keyWindow addSubview:self];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (_wechatEnable) {
        [array addObject:[self addItemWithTitle:@"微信" imageName:@"zzshared_wechat" action:@selector(wechatClick)]];
    }
    if (_qqEnable) {
        [array addObject:[self addItemWithTitle:@"QQ" imageName:@"zzshared_qq" action:@selector(qqClick)]];
    }
    if (_smsEnable) {
        [array addObject:[self addItemWithTitle:@"短信" imageName:@"zzshared_sms" action:@selector(smsClick)]];
    }
    self.buttons = [array copy];
    [self setup];
    [self layout];
    [self show];
    
}

- (void)setup {
    self.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
}

- (void)layout {
    self.frame = self.superview.bounds;
    CGFloat maxWidth = CGRectGetWidth(self.frame);
    self.titleLabel.frame = CGRectMake(0, 0, maxWidth, 50);
    self.line1View.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), maxWidth, 2);
    CGFloat maxY = CGRectGetMaxY(self.line1View.frame);
    if (!self.detailLabel.isHidden) {
        self.detailLabel.frame = CGRectMake(0, maxY, maxWidth, 30);
        maxY = CGRectGetMaxY(self.detailLabel.frame);
    }
    if (!self.noneLabel.isHidden) {
        self.noneLabel.frame = CGRectMake(0, maxY, maxWidth, 200);
        maxY = CGRectGetMaxY(self.noneLabel.frame);
    } else {
        NSInteger count = self.buttons.count;
        CGFloat margin = 20;
        CGFloat itemWidth = (maxWidth - (count + 1) * margin) / count;
        CGFloat itemY = maxY + 25;
        CGFloat itemHeight = 100;
        for (int i = 0; i < count; i++) {
            UIView *item = self.buttons[i];
            CGFloat itemX = margin + (itemWidth + margin) * i;
            item.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
        }
        maxY = CGRectGetMaxY(self.buttons.lastObject.frame);
    }
    self.line2View.frame = CGRectMake(0, maxY + 25, maxWidth, 2);
    CGFloat cancelHeight = 50 + ([self isX] ? 30 : 0);
    self.cancelButton.frame = CGRectMake(0, CGRectGetMaxY(self.line2View.frame), maxWidth, cancelHeight);
    CGFloat contentHeight = CGRectGetMaxY(self.cancelButton.frame);
    self.contentView.frame = CGRectMake(0, CGRectGetHeight(self.frame), maxWidth, contentHeight);
    CGFloat backHeight = CGRectGetHeight(self.frame) - CGRectGetHeight(self.contentView.frame);
    self.backView.frame = CGRectMake(0, 0, maxWidth, backHeight);
}

- (BOOL)isX {
    if (@available(iOS 11.0, *)) {
        return [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
    }
    return NO;
}

- (ZZSharedItem *)addItemWithTitle:(NSString *)title imageName:(NSString *)imageName action:(SEL)action {
    ZZSharedItem *item = [[ZZSharedItem alloc] init];
    [self.contentView addSubview:item];
    [item setTitle:title forState:UIControlStateNormal];
    [item setTitleColor:UIColor.lightGrayColor forState:UIControlStateNormal];
    item.titleLabel.textAlignment = NSTextAlignmentCenter;
    item.titleLabel.font = [UIFont systemFontOfSize:15];
    NSBundle *sharedBundle = [NSBundle bundleWithPath:[NSBundle.mainBundle pathForResource:@"ZZSharedResource" ofType:@"bundle"]];
    NSString *icon = [sharedBundle pathForResource:imageName ofType:@"png"];
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [item addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}


- (void)show {
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.contentView.frame));
    }];
}

- (void)dismiss {
    self.backView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

#pragma mark - click
- (void)wechatClick {
    if (self.clickHandler) {
        self.clickHandler(@"wechat");
        self.clickHandler = nil;
    }
}

- (void)qqClick {
    if (self.clickHandler) {
        self.clickHandler(@"qq");
        self.clickHandler = nil;
    }
}

- (void)smsClick {
    if (self.clickHandler) {
        self.clickHandler(@"sms");
        self.clickHandler = nil;
    }
}

#pragma mark - setter
- (void)setWechatEnable:(BOOL)wechatEnable {
    _wechatEnable = wechatEnable;
    self.noneLabel.hidden = _wechatEnable || _qqEnable || _smsEnable;
}

- (void)setQqEnable:(BOOL)qqEnable {
    _qqEnable = qqEnable;
    self.noneLabel.hidden = _wechatEnable || _qqEnable || _smsEnable;
}

- (void)setSmsEnable:(BOOL)smsEnable {
    _smsEnable = smsEnable;
    self.noneLabel.hidden = _wechatEnable || _qqEnable || _smsEnable;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = [title length] ? title : @"分享到";
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.detailLabel.text = subTitle;
    self.detailLabel.hidden = [subTitle length] > 0;
}

#pragma mark - getter
- (UIView *)contentView {
    if (!_contentView) {
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        _contentView = view;
        _contentView.backgroundColor = UIColor.whiteColor;
    }
    return _contentView;
}

- (UIView *)backView {
    if (!_backView) {
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        _backView = view;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [_backView addGestureRecognizer:tgr];
    }
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _titleLabel = label;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = UIColor.darkTextColor;
        _titleLabel.text = @"分享到";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _detailLabel = label;
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.font = [UIFont systemFontOfSize:13];
        _detailLabel.textColor = UIColor.lightTextColor;
        _detailLabel.hidden = YES;
    }
    return _detailLabel;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:button];
        _cancelButton = button;
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)noneLabel {
    if (!_noneLabel) {
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        _noneLabel = label;
        _noneLabel.textAlignment = NSTextAlignmentCenter;
        _noneLabel.text = @"本机暂无可分享平台";
        _noneLabel.textColor = UIColor.lightGrayColor;
        _noneLabel.font = [UIFont systemFontOfSize:14];
    }
    return _noneLabel;
}

- (UIView *)line1View {
    if (!_line1View) {
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        _line1View = view;
        _line1View.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
    }
    return _line1View;
}

- (UIView *)line2View {
    if (!_line2View) {
        UIView *view = [[UIView alloc] init];
        [self.contentView addSubview:view];
        _line2View = view;
        _line2View.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.1];
    }
    return _line2View;
}

@end
