#import "ZZDevicePermissionChecker.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <Contacts/Contacts.h>

@implementation ZZDevicePermissionChecker

+ (void)checkVideoEnable:(void (^)(BOOL enable))complete {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized: {
            complete(YES);
            break;
        }
        case AVAuthorizationStatusDenied: {
            [self callDeniedAlertWithIdent:@"相机" complete:complete];
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            BOOL auth = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
            if (!auth) {
                [self callErrorAlertWithIdent:@"相机" complete:complete];
                break;
            };
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        complete(YES);
                    } else {
                        [self callDeniedAlertWithIdent:@"相机" complete:complete];
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusRestricted: {
            [self callRestrictedAlertWithIdent:@"相机" complete:complete];
            break;
        }
        default: {
            [self callErrorAlertWithIdent:@"相机" complete:complete];
            break;
        }
    }
}
+ (void)checkAudioEnable:(void (^)(BOOL enable))complete {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusAuthorized: {
            complete(YES);
            break;
        }
        case AVAuthorizationStatusDenied: {
            [self callDeniedAlertWithIdent:@"麦克风" complete:complete];
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        complete(YES);
                    } else {
                        [self callDeniedAlertWithIdent:@"麦克风" complete:complete];
                    }
                });
            }];
            break;
        }
        case AVAuthorizationStatusRestricted: {
            [self callRestrictedAlertWithIdent:@"麦克风" complete:complete];
            break;
        }
        default: {
            [self callErrorAlertWithIdent:@"麦克风" complete:complete];
            break;
        }
    }
}
+ (void)checkPhotoEnable:(void (^)(BOOL enable))complete {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined: {
            BOOL auth = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
            if (!auth) {
                [self callErrorAlertWithIdent:@"相册" complete:complete];
                break;
            };
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        complete(YES);
                    } else {
                        [self callDeniedAlertWithIdent:@"相册" complete:complete];
                    }
                });
            }];
            break;
        }
        case PHAuthorizationStatusRestricted: {
            [self callRestrictedAlertWithIdent:@"相册" complete:complete];
            break;
        }
        case PHAuthorizationStatusDenied: {
            [self callDeniedAlertWithIdent:@"相册" complete:complete];
            break;
        }
        case PHAuthorizationStatusAuthorized: {
            complete(YES);
            break;
        }
        default: {
            [self callErrorAlertWithIdent:@"相册" complete:complete];
            break;
        }
    }
}
+ (void)checkContactsEnable:(void (^)(BOOL enable))complete {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (status) {
        case CNAuthorizationStatusNotDetermined: {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (granted) {
                        complete(YES);
                    } else {
                        [self callDeniedAlertWithIdent:@"通讯录" complete:complete];
                    }
                });
            }];
            break;
        }
        case CNAuthorizationStatusRestricted: {
            [self callRestrictedAlertWithIdent:@"通讯录" complete:complete];
            break;
        }
        case CNAuthorizationStatusDenied: {
            [self callDeniedAlertWithIdent:@"通讯录" complete:complete];
            break;
        }
        case CNAuthorizationStatusAuthorized: {
            complete(YES);
            break;
        }
        default: {
            [self callErrorAlertWithIdent:@"通讯录" complete:complete];
            break;
        }
    }
}

#pragma mark - call alert
+ (void)callDeniedAlertWithIdent:(NSString *)ident complete:(void (^)(BOOL enable))complete {
    NSString *message = [NSString stringWithFormat:@"请前往: [设置 - 隐私] 打开%@权限", ident];
    [UIAlertController showAlertWithMessage:message okHandler:^(UIAlertAction * _Nonnull action) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        complete(NO);
    } cancelHandler:^(UIAlertAction * _Nonnull action) {
        complete(NO);
    }];
}

+ (void)callRestrictedAlertWithIdent:(NSString *)ident complete:(void (^)(BOOL enable))complete {
    [UIAlertController showAlertWithMessage:[NSString stringWithFormat:@"由于系统原因, 无法访问%@", ident] okHandler:^(UIAlertAction * _Nonnull action) {
        complete(NO);
    }];
}

+ (void)callErrorAlertWithIdent:(NSString *)ident complete:(void (^)(BOOL enable))complete {
    [UIAlertController showAlertWithMessage:[NSString stringWithFormat:@"无法访问%@", ident] okHandler:^(UIAlertAction * _Nonnull action) {
        complete(NO);
    }];
}

@end
