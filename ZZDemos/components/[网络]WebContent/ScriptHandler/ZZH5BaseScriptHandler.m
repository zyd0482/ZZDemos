#import "ZZH5BaseScriptHandler.h"
#import "ZZH5ContainerController.h"
#import "ZZH5ContainerDefine.h"

#pragma mark ---------- NSArray Conv ----------
@implementation NSArray (Conv)

+ (NSArray *)safeArrayWithObject:(id)obj {
    if (!obj) return @[];
    if (![obj isKindOfClass:[NSArray class]]) return @[];
    return obj;
}

@end

#pragma mark ---------- Main ----------
@implementation ZZH5BaseScriptHandler

- (BOOL)checkingHrefEnableWithUrlString:(NSString *)urlString {
    NSLog(@"requestURL: %@", urlString);
    if ([urlString hasPrefix:kH5BradgeKey]) {
        NSArray *handleArr = [urlString componentsSeparatedByString:kH5BradgeSeparatedKey];
        if ([handleArr count] < 2) return NO;
        NSString *funcName = [handleArr objectAtIndex:1];
        NSArray *message = @[];
        if ([handleArr count] > 2) {
            message = [handleArr subarrayWithRange:NSMakeRange(2, handleArr.count - 2)];
        }
        [self handleScriptWithFunctionName:funcName message:message];
        return NO;
    }
    return YES;
}

- (void)handleScriptWithFunctionName:(NSString *)funcName message:(id)message {
    if ([funcName isEqualToString:@"setTitle"]) {
        [self setTitleWithMessage:message];
    }
    else if ([funcName isEqualToString:@"htmlShowLoading"]) {
        [self showLoading];
    }
}


#pragma mark - functions
- (void)setTitleWithMessage:(id)message {
    NSLog(@"Action ---------- 设置Title");
    if (!self.controller) return;
    NSArray *params = [NSArray safeArrayWithObject:message];
    if (params.count < 2) return;
    self.controller.title = params[1];
}

- (void)showLoading {
    NSLog(@"Action ---------- 加载Loading");
}

- (void)hideLoading {
   NSLog(@"Action ---------- 隐藏Loading");
}

@end
