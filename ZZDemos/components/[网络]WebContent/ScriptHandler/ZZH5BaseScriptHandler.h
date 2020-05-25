#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZH5ContainerController;
@interface ZZH5BaseScriptHandler : NSObject

@property (nonatomic, weak) ZZH5ContainerController *controller;

- (BOOL)checkingHrefEnableWithUrlString:(NSString *)urlString;

// subclass override
- (void)handleScriptWithFunctionName:(NSString *)funcName message:(id)message;

@end

NS_ASSUME_NONNULL_END
