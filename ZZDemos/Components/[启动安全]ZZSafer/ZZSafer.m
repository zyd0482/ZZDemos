#import "ZZSafer.h"
#include <sys/stat.h>
#include <dlfcn.h>
#import <UIKit/UIKit.h>
#import "ZZSaferDefine.h"

@implementation ZZSafer

- (BOOL)isJailBroken {
    // 检测层级依次增强
    NSString *cydiaPath = @"/Applications/Cydia.app";
    if ([NSFileManager.defaultManager fileExistsAtPath:cydiaPath]) return YES;
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([NSFileManager.defaultManager fileExistsAtPath:aptPath]) return YES;
    
    // 可能存在hook了NSFileManager方法，此处用底层C stat去检测
    struct stat stat_info;
    if (0 == stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &stat_info)) return YES;
    if (0 == stat("/Applications/Cydia.app", &stat_info)) return YES;
    if (0 == stat("/var/lib/cydia/", &stat_info)) return YES;
    if (0 == stat("/var/cache/apt", &stat_info)) return YES;
    /**
     /Library/MobileSubstrate/MobileSubstrate.dylib 最重要的越狱文件，几乎所有的越狱机都会安装MobileSubstrate
     /Applications/Cydia.app/ /var/lib/cydia/绝大多数越狱机都会安装
     /var/cache/apt /var/lib/apt /etc/apt
     /bin/bash /bin/sh
     /usr/sbin/sshd /usr/libexec/ssh-keysign /etc/ssh/sshd_config
     */
    
    // 可能存在stat也被hook了，可以看stat是不是出自系统库，有没有被攻击者换掉
    // 这种情况出现的可能性很小
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *,struct stat *) = stat;
    if ((ret = dladdr(func_stat, &dylib_info))) {
        // NSLog(@"lib:%s",dylib_info.dli_fname);
        // 如果不是系统库(不相等)，肯定被攻击了，相等为0
        if (strcmp(dylib_info.dli_fname, "/usr/lib/system/libsystem_kernel.dylib")) return YES;
    }
    
    // 如果攻击者给MobileSubstrate改名, 但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库
    // 那么可以,检测当前程序运行的环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if (env != NULL) return YES;
    return NO;
}


- (BOOL)isAppChanged {
    // 1.检查Info.plist 是否存在 SignerIdentity这个键名(Key)
    // 未破解的程序是不会有这个键名的
    if ([[NSBundle.mainBundle infoDictionary] objectForKey: @"SignerIdentity"] != nil) return YES;
    
    // 2.检查3个文件是否存在
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/_CodeSignature", bundlePath]];
    if (!fileExists) return YES;
    BOOL fileExists2 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/CodeResources", bundlePath]];
    if (!fileExists2) return YES;
    BOOL fileExists3 = [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/ResourceRules.plist", bundlePath]];
    if (!fileExists3) return YES;
    
    // 3.对比文件修改时间是否一致, 看看你的程序是不是被二进制编辑器修改过了
    NSString *bundlePath2 = [[NSBundle mainBundle] bundlePath];
    NSString *path = [NSString stringWithFormat:@"%@/Info.plist", bundlePath2];
    NSString *path2 = [NSString stringWithFormat:@"%@/%@", bundlePath2, kSafeAppName];
    NSError *error = nil;
    NSDate *infoModifiedDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error] fileModificationDate];
    error = nil;
    NSDate *infoModifiedDate2 = [[[NSFileManager defaultManager] attributesOfItemAtPath:path2 error:&error] fileModificationDate];
    error = nil;
    NSDate *pkgInfoModifiedDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PkgInfo"] error:&error] fileModificationDate];
    if ([infoModifiedDate timeIntervalSinceReferenceDate] > [pkgInfoModifiedDate timeIntervalSinceReferenceDate])
        return YES;
    if ([infoModifiedDate2 timeIntervalSinceReferenceDate] > [pkgInfoModifiedDate timeIntervalSinceReferenceDate])
        return YES;
    return NO;
}

/// 检测用户截屏
- (void)userTakeScreenshot:(void(^)(NSNotification * _Nonnull note))handler {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:handler];
}

@end
