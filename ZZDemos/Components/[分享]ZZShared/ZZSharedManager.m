#import "ZZSharedManager.h"
#import "ZZSharedConfig.h"
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
#import "ZZSharedView.h"

#pragma mark ---------- Info ----------
@implementation ZZSharedInfo

@end


#pragma mark ---------- Main ----------
@implementation ZZSharedManager

+ (void)setup {
#ifdef DEBUG
    [UMConfigure setLogEnabled:YES];
#endif
    [UMConfigure setEncryptEnabled:YES];
    [UMConfigure initWithAppkey:kUmengShareAppKey channel:@"App Store"];
    [self configUShareSettings];
    [self configUSharePlatforms];
}

+ (void)configUShareSettings {
    //配置微信平台的Universal Links
    //微信和QQ完整版会校验合法的universalLink，不设置会在初始化平台失败
//   [UMSocialGlobal shareInstance].universalLinkDic = @{
//       @(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
//       @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139"};
}

+ (void)configUSharePlatforms {
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kUmengShareAppKey appSecret:kUmengShareSecretWechat redirectURL:kUmengShareRedirectURL];
    /*设置小程序回调app的回调*/
//    [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse, NSError *error) {
//    NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
//    }];
    /* 设置分享到QQ互联的appID */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kUmengShareIDQQ  appSecret:nil redirectURL:kUmengShareRedirectURL];
}

+ (BOOL)handleOpenUrl:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"OpenUrl: %@\n sourceApplication: %@\n, annotation: %@", url.absoluteURL, sourceApplication, annotation);
    return [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
}


+ (void)openSharedWithOption:(ZZSharedOption)option info:(ZZSharedInfo *)info complete:(ZZSharedCompleteHandler)complete {
    ZZSharedView *sharedView = [[ZZSharedView alloc] init];
    if (option == 0) {
        option = ZZShareOptionWechat | ZZShareOptionQQ | ZZShareOptionSms;
    }
    sharedView.title = info.panelTitle;
    sharedView.subTitle = info.panelSubTitle;
    sharedView.wechatEnable = (option & ZZShareOptionWechat) && [UMSocialManager.defaultManager isInstall:UMSocialPlatformType_WechatSession];
    sharedView.qqEnable = (option & ZZShareOptionQQ) && [UMSocialManager.defaultManager isInstall:UMSocialPlatformType_QQ];
    sharedView.smsEnable = (option & ZZShareOptionSms) && [UMSocialManager.defaultManager isInstall:UMSocialPlatformType_Sms];
    [sharedView showWithClickHandler:^(NSString * _Nonnull identify) {
        if ([identify isEqualToString:@"wechat"]) {
            [self startSharedWithInfo:info platform:UMSocialPlatformType_WechatSession complete:complete];
        } else if ([identify isEqualToString:@"qq"]) {
            [self startSharedWithInfo:info platform:UMSocialPlatformType_QQ complete:complete];
        } else if ([identify isEqualToString:@"sms"]) {
            [self startSharedWithInfo:info platform:UMSocialPlatformType_Sms complete:complete];
        }
        [sharedView dismiss];
    }];
}

+ (void)startSharedWithInfo:(ZZSharedInfo *)info platform:(UMSocialPlatformType)platform complete:(ZZSharedCompleteHandler)complete {
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UIImage *image = nil;
    if (info.iconName) {
        image = [UIImage imageNamed:info.iconName];
    }
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:info.title descr:info.message thumImage:image];
    shareObject.webpageUrl = info.url;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:(id)info.currentVC completion:^(id data, NSError *error) {
        if (!error) {
            NSLog(@"response data is %@",data);
            complete();
        } else {
            NSLog(@"************Share fail with error %@*********",error);
        }
    }];
}

@end
