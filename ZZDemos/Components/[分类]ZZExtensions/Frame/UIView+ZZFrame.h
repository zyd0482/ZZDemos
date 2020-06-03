#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark ---------- View ----------
@interface UIView (ZZFrame)

#pragma mark - base
- (CGFloat)top;
- (CGFloat)left;
- (CGFloat)bottom;
- (CGFloat)right;
- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)centerX;
- (CGFloat)centerY;
- (void)setTop:(CGFloat)top;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setCenterX:(CGFloat)centerX;
- (void)setCenterY:(CGFloat)centerY;


#pragma mark - fill 填充
// 宽度填充super
- (void)fillWidth;
// 高度填充super
- (void)fillHeight;
// fillWidth & fillHeight
- (void)fill;

#pragma mark - flex 延展
// 填充x右边的部分
- (void)flexWidth;
// 填充y下面的部分
- (void)flexHeight;
// flexWidth & flexHeight
- (void)flex;

#pragma mark - center
// 水平居中
- (void)middleX;
// 垂直居中
- (void)middleY;

@end


#pragma mark ---------- View ----------
@interface UILabel (ZZFrame)

/// 自适应布局
- (void)fit;

/// 宽度确定后,根据文本自动适应高度
- (void)fitHeight;

@end


NS_ASSUME_NONNULL_END
