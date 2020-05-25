#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZZExt)

/// 根据format返回一个字符串 e.g. yyyyMMdd HH:mm:ss
- (NSString *)stringWithFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
