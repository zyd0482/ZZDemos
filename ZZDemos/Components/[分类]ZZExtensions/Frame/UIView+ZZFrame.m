#import "UIView+ZZFrame.h"

#pragma mark ---------- View ----------
@implementation UIView (ZZFrame)

#pragma mark -
- (CGFloat)top { return self.frame.origin.y; }
- (CGFloat)left { return self.frame.origin.x; }
- (CGFloat)width { return self.frame.size.width; }
- (CGFloat)centerX { return self.center.x; }
- (CGFloat)centerY { return self.center.y; }
- (CGFloat)height { return self.frame.size.height; }
- (CGFloat)bottom { return self.top + self.height; }
- (CGFloat)right { return self.left + self.width; }
- (void)setTop:(CGFloat)top { CGRect frame = self.frame; frame.origin.y = top; self.frame = frame; }
- (void)setLeft:(CGFloat)left { CGRect frame = self.frame; frame.origin.x = left; self.frame = frame; }
- (void)setWidth:(CGFloat)width { CGRect frame = self.frame; frame.size.width = width; self.frame = frame; }
- (void)setHeight:(CGFloat)height { CGRect frame = self.frame; frame.size.height = height; self.frame = frame; }
- (void)setRight:(CGFloat)right { self.left = right - self.width; }
- (void)setBottom:(CGFloat)bottom { self.top = bottom - self.height; }
- (void)setCenterX:(CGFloat)centerX { CGPoint center = self.center; center.x = centerX; self.center = center; }
- (void)setCenterY:(CGFloat)centerY { CGPoint center = self.center; center.y = centerY; self.center = center; }


- (void)fillWidth { self.width = self.superview.width; }
- (void)fillHeight { self.height = self.superview.height; }
- (void)fill { [self fillWidth];[self fillHeight]; }

- (void)flexWidth { self.width = self.superview.width - self.left; }
- (void)flexHeight { self.height = self.superview.height - self.top; }
- (void)flex { [self flexWidth]; [self flexHeight]; }

- (void)middleX { self.centerX = self.superview.width / 2; }
- (void)middleY { self.centerY = self.superview.height / 2; };

@end


#pragma mark ---------- Label ----------
@implementation UILabel (ZZFrame)

- (void)fit {
    CGSize size = [self sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    self.width = size.width;
    self.height = size.height;
}

- (void)fitHeight {
    self.height = [self sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)].height;
}

@end
