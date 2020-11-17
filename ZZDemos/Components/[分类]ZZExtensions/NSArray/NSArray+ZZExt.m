#import "NSArray+ZZExt.h"

@implementation NSArray (ZZExt)

+ (NSArray *)arrayWithOriginArray:(NSArray<id> *)oriArray sortRefer:(NSArray<NSString *> *)sortRefer sortKeyPath:(NSString *)keyPath; {
    NSArray *allKeys = [oriArray valueForKeyPath:keyPath];
    NSDictionary *allDicts = [NSDictionary dictionaryWithObjects:oriArray forKeys:allKeys];
    NSMutableArray *sortedArray = [[NSMutableArray alloc] initWithCapacity:sortRefer.count];
    for (NSString *refer in sortRefer) {
        [sortedArray addObject:[allDicts objectForKey:refer]];
    }
    return [sortedArray copy];
}

@end
