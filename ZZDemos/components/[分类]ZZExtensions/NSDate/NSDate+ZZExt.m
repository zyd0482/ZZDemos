#import "NSDate+ZZExt.h"

@implementation NSDate (ZZExt)

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [formatter setDateFormat:format];
    NSString *timeStr = [formatter stringFromDate:self];
    return timeStr;
}

@end
