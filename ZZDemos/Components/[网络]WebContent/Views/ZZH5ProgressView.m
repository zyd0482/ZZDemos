#import "ZZH5ProgressView.h"

@interface ZZH5ProgressView ()

@property (nonatomic, weak) CALayer *lineLayer;

@end

@implementation ZZH5ProgressView

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.lineLayer.frame;
    frame.size.height = self.frame.size.height;
    self.lineLayer.frame = frame;
}

#pragma mark - setter
- (void)setShown:(BOOL)shown {
    _shown = shown;
    self.lineLayer.hidden = !_shown;
}

- (void)setProgress:(double)progress {
    _progress = progress;
    CGRect frame = self.lineLayer.frame;
    frame.size.width = self.bounds.size.width * _progress;
    self.lineLayer.frame = frame;
}

#pragma mark - getter
- (CALayer *)lineLayer {
    if (!_lineLayer) {
        CALayer *layer = [[CALayer alloc] init];
        [self.layer addSublayer:layer];
        _lineLayer = layer;
        _lineLayer.backgroundColor = [UIColor.redColor colorWithAlphaComponent:0.5].CGColor;
    }
    return _lineLayer;
}

@end
