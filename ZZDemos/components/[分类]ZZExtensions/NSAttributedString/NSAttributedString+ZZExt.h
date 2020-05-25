#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kAttrText = @"kAttrText";
static NSString *kAttrFont = @"kAttrFont";
static NSString *kAttrColor = @"kAttrColor";

@interface NSAttributedString (ZZExt)

+ (instancetype)attributeStringWithArray:(NSArray<NSDictionary *> *)array;

@end

NS_ASSUME_NONNULL_END
