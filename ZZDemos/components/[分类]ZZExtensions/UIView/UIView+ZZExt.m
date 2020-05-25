#import "UIView+ZZExt.h"

@implementation UIView (ZZExt)

- (void)addTapGestureWithTarget:(id)target action:(SEL)action {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tgr];
}


@end
