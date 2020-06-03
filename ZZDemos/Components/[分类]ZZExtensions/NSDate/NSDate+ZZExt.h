#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (ZZExt)

/// 传入整型日期值 返回NSDate
+ (instancetype)dateWithInteger:(NSInteger)intDate;

/// 传入日期字符串和相应的格式 返回NSDate
+ (instancetype)dateFromString:(NSString *)string format:(NSString *)format;

/// 当前Date的星期(中文)
- (NSString *)weekdayInCHN;

/// 当前Date的日
- (NSString *)dayString;

/// 得到几天后的时间
- (NSDate *)dateByAddingWithDays:(NSInteger)days;

/// 返回带格式的日期字符串
- (NSString *)stringWithFormat:(NSString *)format;


/// 获取当月第一天
- (NSDate *)firstDayOfMonth;

/// 获取当月最后一天
- (NSDate *)lastDayOfMonth;

/// 计算当月有多少天
- (NSInteger)daysCountOfMonth;

/// 获取某个日期所在年份的天数
- (NSInteger)daysInYear;

/// 获取当前年份剩余的天数
- (NSInteger)daysLeftInYear;

/// 获取integer整型格式的日期 yyyyMMdd
- (NSInteger)integerValue;

@end

NS_ASSUME_NONNULL_END
