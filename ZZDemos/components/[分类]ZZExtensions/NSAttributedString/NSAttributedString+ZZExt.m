#import "NSAttributedString+ZZExt.h"

@implementation NSAttributedString (ZZExt)

+ (instancetype)attributeStringWithArray:(NSArray<NSDictionary *> *)array {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    for (NSDictionary *dict in array) {
        if (!dict[kAttrText]) continue;
        UIFont *font = dict[kAttrFont] ? dict[kAttrFont] : UIFontSize(14);
        UIColor *color = dict[kAttrColor] ? dict[kAttrColor] : UIColorHex(@"#333333");
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:dict[kAttrText] attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: color}]];
    }
    return [attr copy];
}

@end
