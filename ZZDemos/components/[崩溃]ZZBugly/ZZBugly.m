#import "ZZBugly.h"
#include <execinfo.h>

static const NSString *kBuglyLocalSavingName = @"com.zz.buginfo";

@implementation ZZBugly

void UncaughtExceptionHandler(NSException *exception) {
    NSMutableString *crashSymbols = [NSMutableString string];
    [crashSymbols appendFormat:@"> name:\n%@\n", [exception name]];
    [crashSymbols appendFormat:@"> reason:\n%@\n", [exception reason]];
    [crashSymbols appendFormat:@"> callStackSymbols:\n%@\n", [exception callStackSymbols]];
    [crashSymbols appendFormat:@"> userInfo:\n%@\n", [exception userInfo]];
    [crashSymbols appendFormat:@"> callStackReturnAddresses:\n%@\n", [exception callStackReturnAddresses]];
    [ZZBugly saveCrashFileToLocalWithInfo:[crashSymbols copy]];
}

+ (void)setup {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (NSString *)localSavingBugInfo {
    NSDictionary *dict = [self findLocalCrashFile];
    if (!dict) return @"";
    NSMutableString *res = [NSMutableString new];
    for (NSString *key in dict) {
        [res appendFormat:@"key: %@\n", key];
        [res appendFormat:@"value:\n %@ \n", dict[key]];
    }
    return res;
}

+ (NSString *)localFilePath {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CrashLog"];
}

+ (void)uploadCrashInfoToServerWithDict:(NSDictionary *)crashInfo {
    NSLog(@"%@", crashInfo);
}

+ (void)saveCrashFileToLocalWithInfo:(NSString *)crashInfo {
    UIDevice *device = [UIDevice currentDevice];
    NSString *deviceInfo = [NSString stringWithFormat:@"%@,%@%@", device.model, device.systemName, device.systemVersion];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"Crash Time"] = [NSDate.date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    dict[@"Device Info"] = deviceInfo;
    dict[@"Crash Info"] = crashInfo;
    NSString *filePath = [self localFilePath];
    [dict writeToFile:filePath atomically:YES];
}

+ (NSDictionary *)findLocalCrashFile {
    NSString *filePath = [self localFilePath];
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        if ([dict isKindOfClass:[NSDictionary class]]) return dict;
    }
    return nil;
}

+ (void)deleteCrashFileFromLocal {
    NSString *filePath = [self localFilePath];
    if ([NSFileManager.defaultManager fileExistsAtPath:filePath]) {
        NSError *error;
        [NSFileManager.defaultManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"delete file error:%@", error);
        }
    }
}

@end
