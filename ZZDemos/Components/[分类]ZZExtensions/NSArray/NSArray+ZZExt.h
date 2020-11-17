#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (ZZExt)

/// 根据已有数组,对目标数组进行排序
/// oriArray: 原始数组
/// sortRefer: 需要排序的排序参照数组
/// keyPath:原始数组中的排序keypath
+ (NSArray *)arrayWithOriginArray:(NSArray<id> *)oriArray sortRefer:(NSArray<NSString *> *)sortRefer sortKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
