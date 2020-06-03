#ifndef ZZMacros_h
#define ZZMacros_h

#define ZZIsNil(obj) (obj == nil || [obj isKindOfClass:[NSNull class]] || \
([obj isKindOfClass:[NSString class]] && [obj isEqualToString:@"NULL"]))

#define ZZIsEmpty(obj) (TLBIsNil(obj) || ([obj isKindOfClass:[NSString class]] && [obj length] < 1))

#define ZZSafeString(str) ([str isKindOfClass:[NSString class]] && [str length] > 0 ? str : @"")

// release环境中屏蔽NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif

// 判断当前设备是否是刘海屏
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

// weak & strong
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif



// MainScreen Height&Width
#define SCREEN_HEIGHT      [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH       [[UIScreen mainScreen] bounds].size.width

// 沙盒路径
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define APP_VERSION         [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]

#endif /* ZZMacros_h */
