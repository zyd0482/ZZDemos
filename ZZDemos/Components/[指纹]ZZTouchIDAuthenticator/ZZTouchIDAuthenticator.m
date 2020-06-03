#import "ZZTouchIDAuthenticator.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation ZZTouchIDAuthenticator

+ (BOOL)isTouchIDAvailable {
    LAContext *context = [[LAContext alloc] init];
    return [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
}

@end
