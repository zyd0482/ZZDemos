#import "ZZBugly.h"

static const NSString *kBuglyLocalSavingName = @"buginfo";

@implementation ZZBugly

void UncaughtExceptionHandler(NSException *exception) {
    NSArray *callStackSymbols = [exception callStackSymbols];
    NSArray *callStackReturnAddresses = [exception callStackReturnAddresses];
    NSString *name = [exception name];
    NSString *reason = [exception reason];
    NSDictionary *userInfo = [exception userInfo];
    
    NSMutableString *crashSymbols = [NSMutableString string];
    [crashSymbols appendString:@"=====callStackSymbols=====\n"];
    [crashSymbols appendFormat:@"%@\n", callStackSymbols];
    [crashSymbols appendString:@"=====callStackReturnAddresses======\n"];
    [crashSymbols appendFormat:@"%@\n", callStackReturnAddresses];
    [crashSymbols appendString:@"=====name======\n"];
    [crashSymbols appendFormat:@"%@\n", name];
    [crashSymbols appendString:@"=====reason======\n"];
    [crashSymbols appendFormat:@"%@\n", reason];
    [crashSymbols appendString:@"=====userInfo======\n"];
    [crashSymbols appendFormat:@"%@\n", userInfo];
    
    //    UIDevice *device = [UIDevice currentDevice];
    //    [crashSymbols appendString:@"=====deviceInfo======\n"];
    //    [crashSymbols appendFormat:@"%@,%@%@\n", device.model, device.systemName, device.systemVersion];
    [ZZBugly saveCrashFileToLocalWithInfo:[crashSymbols copy]];
}

+ (void)setup {
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    
    // check and upload
    NSDictionary *dict = [self findLocalCrashFile];
    if (dict) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [ZZBugly uploadCrashInfoToServerWithDict:dict];
        });
    }
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
    dict[@"crashInfo"] = crashInfo;
    dict[@"time"] = [NSDate.date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    dict[@"sys"] = deviceInfo;
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
