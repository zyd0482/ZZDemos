#import "UITextField+ZZExt.h"
#import <objc/runtime.h>

@implementation UITextField (ZZExt)

#pragma mark - 设置可输入的最长限制
- (void)setMaxLength:(int)maxLength {
    objc_setAssociatedObject(self, "ext_maxLength", @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(TextDidChangedForCheckMaxLength) forControlEvents:UIControlEventEditingChanged];
}

- (void)TextDidChangedForCheckMaxLength {
    int maxLength = [objc_getAssociatedObject(self, "ext_maxLength") intValue];
    if (maxLength < 1) return;
    if (self.text.length > maxLength) {
        self.text = [self.text substringToIndex:maxLength];
    }
}

@end
