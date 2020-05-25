# ZZShare 分享控件使用手册

## 集成方案
####  Podfile中加入以下库
pod 'UMCCommon'
pod 'UMCSecurityPlugins'
pod 'UMCShare/Social/ReducedWeChat'
pod 'UMCShare/Social/ReducedQQ'
pod 'UMCShare/Social/SMS'

#### plist中添加以下信息(配置SSO白名单)
```
<key>LSApplicationQueriesSchemes</key>
<array>
    <!-- 微信 URL Scheme 白名单-->
    <string>wechat</string>
    <string>weixin</string>
    <string>weixinULAPI</string>
    <!-- QQ、Qzone URL Scheme 白名单-->
    <string>mqqopensdklaunchminiapp</string>
    <string>mqqopensdkminiapp</string>
    <string>mqqapi</string>
    <string>mqq</string>
    <string>mqqOpensdkSSoLogin</string>
    <string>mqqconnect</string>
    <string>mqqopensdkdataline</string>
    <string>mqqopensdkgrouptribeshare</string>
    <string>mqqopensdkfriend</string>
    <string>mqqopensdkapi</string>
    <string>mqqopensdkapiV2</string>
    <string>mqqopensdkapiV3</string>
    <string>mqqopensdkapiV4</string>
    <string>mqzoneopensdk</string>
    <string>wtloginmqq</string>
    <string>wtloginmqq2</string>
    <string>mqqwpa</string>
    <string>mqzone</string>
    <string>mqzonev2</string>
    <string>mqzoneshare</string>
    <string>wtloginqzone</string>
    <string>mqzonewx</string>
    <string>mqzoneopensdkapiV2</string>
    <string>mqzoneopensdkapi19</string>
    <string>mqzoneopensdkapi</string>
    <string>mqqbrowser</string>
    <string>mttbrowser</string>
    <string>tim</string>
    <string>timapi</string>
    <string>timopensdkfriend</string>
    <string>timwpa</string>
    <string>timgamebindinggroup</string>
    <string>timapiwallet</string>
    <string>timOpensdkSSoLogin</string>
    <string>wtlogintim</string>
    <string>timopensdkgrouptribeshare</string>
    <string>timopensdkapiV4</string>
    <string>timgamebindinggroup</string>
    <string>timopensdkdataline</string>
    <string>wtlogintimV1</string>
    <string>timapiV1</string>
</array>
```

####  配置以下URL Typem(目的是在跳转第三方平台后可以回跳)
 平台 |  格式 | 举例 | 备注
- | - | -
微信 | 微信AppKey | wxdc1e388c3822c80b | 无
QQ | "tencent"+腾讯QQ互联应用appID | appID:100424468 -> tencent100424468 | 无
QQ |  “QQ”+腾讯QQ互联应用appID转换成十六进制（不足8位前面补0)  | appID:100424468 -> QQ05fc5b14 | 无

#### 代码部分
1.导入代码
2.在appdelegate中加入下述代码
```
#import "ZZSharedManager.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    ...
    
    [ZZSharedManager setup];
    
    ...
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL result = [ZZSharedManager handleOpenUrl:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
         // 其他如支付等SDK的回调
    }
    return result;
}
```


#### 备注:
目前微信和qq分享都只支持
文本/图片/Web链接/音乐链接/视频链接
以上几种的分享形式.

