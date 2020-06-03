#import "ZZH5ContainerController.h"
#import <WebKit/WebKit.h>
#import "ZZH5ProgressView.h"
#import "ZZH5ContainerDefine.h"
#import "ZZH5BaseScriptHandler.h"

#pragma mark ---------- NSString Conv ----------
@implementation NSString (Conv)

- (NSString *)safeUrlString {
    if (![self isKindOfClass:[NSString class]]) return @"";
    if (![self length]) return @"";
    return [self stringByRemovingPercentEncoding];
}

@end


#pragma mark ---------- UIBarButtonItem Conv ----------
@implementation UIBarButtonItem (Conv)

+ (UIBarButtonItem *)backItemWithTarget:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:target action:action];
}

+ (UIBarButtonItem *)closeItemWithTarget:(id)target action:(SEL)action {
    return [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:target action:action];
}

@end


#pragma mark ---------- Main ----------
@interface ZZH5ContainerController () <
WKScriptMessageHandler,
WKUIDelegate,
WKNavigationDelegate>

@property (nonatomic, weak) ZZH5ProgressView *progressView;

@end

@implementation ZZH5ContainerController {
    NSArray *_kvoKeys;
}

@synthesize webView = _webView;

#pragma mark - life cycle
- (void)dealloc {
    NSLog(@"%s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.scriptHandler) {
        ZZH5BaseScriptHandler *handler = [[ZZH5BaseScriptHandler alloc] init];
        handler.controller = self;
        self.scriptHandler = handler;
    }
    [self loadRequestWithUrlString:self.urlString];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupKVO];
    [self setupNavigation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeKVO];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.webView.frame = self.view.bounds;
    self.progressView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 2);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        NSLog(@"KVO catch isloading:%d", self.webView.isLoading);
        self.progressView.shown = self.webView.isLoading;
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"KVO catch estimatedProgress:%f", self.webView.estimatedProgress);
        self.progressView.progress = self.webView.estimatedProgress;
    } else if ([keyPath isEqualToString:@"title"]) {
        NSLog(@"KVO catch title:%@", self.webView.title);
        self.title = self.webView.title;
    } else if ([keyPath isEqualToString:@"canGoBack"]) {
        NSLog(@"KVO catch canGoBack");
        UIBarButtonItem *backItem = [UIBarButtonItem backItemWithTarget:self action:@selector(doGoBack)];
        if (self.webView.canGoBack) {
            UIBarButtonItem *closeItem = [UIBarButtonItem closeItemWithTarget:self action:@selector(doClose)];
            self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
        } else {
            self.navigationItem.leftBarButtonItems = @[backItem];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - setup
- (void)setupNavigation {
    self.navigationController.navigationBar.tintColor = UIColor.blackColor;
}

- (void)setupKVO {
    _kvoKeys = @[@"loading", @"canGoBack", @"estimatedProgress", @"title"];
    for (NSString *key in _kvoKeys) {
        [self.webView addObserver:self forKeyPath:key options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) context:nil];
    }
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:kH5NativeActionName];
}

- (void)removeKVO {
    for (NSString *key in _kvoKeys) {
        [self.webView removeObserver:self forKeyPath:key];
    }
    _kvoKeys = nil;
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:kH5NativeActionName];
}

#pragma mark - action
- (void)doGoBack {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self doClose];
    }
}

- (void)doClose {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private
- (void)scriptHandlerWithFunctionName:(NSString *)functionName messages:(id)messages {
    NSLog(@"scriptHandler name:%@ message:%@", functionName, messages);
//    [ZZH5OldScriptHandler handleScriptWithFunctionName:functionName message:messages controller:self];
}

#pragma mark - public
- (void)loadRequestWithUrlString:(NSString *)urlString {
    NSString *safeString = [urlString safeUrlString];
    if ([safeString length]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:safeString]]];
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}
//
//- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
//    NSLog(@"call confirm: %@", message);
//    completionHandler();
//}
//
//- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
//    NSLog(@"call input: %@", message);
//    completionHandler();
//}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"\nname:%@\nmessage.type:%@\nmessage:%@\n", message.name, NSStringFromClass([message class]), message);
    NSLog(@"name:%@\ninfo:%@\ninfo.type:%@", message.name, message.body, NSStringFromClass([message.body class]));
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *requestUrlString = navigationAction.request.URL.absoluteString;
    BOOL enable = [self.scriptHandler checkingHrefEnableWithUrlString:requestUrlString];
    decisionHandler(enable ? WKNavigationActionPolicyAllow : WKNavigationActionPolicyCancel);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    if (error.code == NSURLErrorCancelled) return;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}


#pragma mark - getter
- (ZZH5ProgressView *)progressView {
    if (!_progressView) {
        ZZH5ProgressView *view = [[ZZH5ProgressView alloc] init];
        [self.view addSubview:view];
        _progressView = view;
    }
    return _progressView;
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configure = [[WKWebViewConfiguration alloc] init];
        configure.preferences.javaScriptEnabled = YES;
        configure.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        WKUserContentController *userContent = [[WKUserContentController alloc] init];
        configure.userContentController = userContent;
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configure];
        [self.view addSubview:webView];
        _webView = webView;
        _webView.customUserAgent = kH5CustomUserAgent;
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
    }
    return _webView;
}

@end
