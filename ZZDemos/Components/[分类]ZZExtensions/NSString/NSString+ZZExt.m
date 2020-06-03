#import "NSString+ZZExt.h"

@implementation NSString (ZZExt)

- (nullable id)convertFromJsonFormat {
    if (![self isKindOfClass:[NSString class]]) return nil;
    NSString *originString = [self stringByRemovingPercentEncoding];
    NSData *infoData = [originString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id info = [NSJSONSerialization JSONObjectWithData:infoData options:NSJSONReadingAllowFragments error:&err];
    if (err) {
        NSLog(@"%@", err);
        return nil;
    }
    return info;
}

@end
