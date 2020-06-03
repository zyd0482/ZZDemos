#import "NSDate+ZZExt.h"

@interface NSCalendar (UTCCalender)

+ (NSCalendar *)UTCCalendar;

@end

@implementation NSCalendar (UTCCalender)

+ (NSCalendar *)UTCCalendar {
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return calendar;
}

@end


@implementation NSDate (ZZExt)

+ (instancetype)dateWithInteger:(NSInteger)intDate {
    NSString *string = [NSString stringWithFormat:@"%ld", intDate];
    return [self dateFromString:string format:@"yyyyMMdd"];
}

+ (instancetype)dateFromString:(NSString *)string format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.calendar = [NSCalendar UTCCalendar];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    return [formatter dateFromString:string];
}

- (NSString *)weekdayInCHN {
    NSCalendar *calendar = [NSCalendar UTCCalendar];
    NSInteger weekDay = [calendar component:NSCalendarUnitWeekday fromDate:self];
    if (weekDay <= 7) {
        NSDictionary *tmp = @{@1:@"周日",@2:@"周一",@3:@"周二",@4:@"周三",@5:@"周四",@6:@"周五",@7:@"周六"};
        return tmp[@(weekDay)];
    } else {
        return [NSString stringWithFormat:@"%ld", weekDay];
    }
}

- (NSString *)dayString {
    NSCalendar *calendar = [NSCalendar UTCCalendar];
    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:self];
    return [NSString stringWithFormat:@"%02ld", day];
}

- (NSDate *)dateByAddingWithDays:(NSInteger)days {
    NSCalendar *calendar = [NSCalendar UTCCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:days toDate:self options:NSCalendarMatchStrictly];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

- (NSDate *)firstDayOfMonth {
    return [[self firstDayAndLastOfMonth] firstObject];
}

- (NSDate *)lastDayOfMonth {
    return [[self firstDayAndLastOfMonth] lastObject];
}

- (NSInteger)daysCountOfMonth {
    return [[self.lastDayOfMonth stringWithFormat:@"dd"] integerValue];
}

- (nullable NSArray<NSDate *> *)firstDayAndLastOfMonth {
    double interval = 0;
    NSDate *firstDate = nil;
    NSDate *lastDate = nil;
    NSCalendar *calendar = [NSCalendar UTCCalendar];
    BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDate interval:&interval forDate:self];
    if (!OK) return nil;
    lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
    return @[firstDate, lastDate];
}

- (NSInteger)daysInYear {
    return [NSCalendar.UTCCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:self].length;
}

- (NSInteger)daysLeftInYear {
    NSCalendar *calendar = [NSCalendar UTCCalendar];
    calendar.firstWeekday = 2;
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:self];
    NSString *year = [self stringWithFormat:@"yyyy"];
    NSDate *endDate = [NSDate dateFromString:[year stringByAppendingString:@"1231"] format:@"yyyyMMdd"];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return dayComponents.day;
}

- (NSInteger)integerValue {
    return [[self stringWithFormat:@"yyyyMMdd"] integerValue];
}

@end
