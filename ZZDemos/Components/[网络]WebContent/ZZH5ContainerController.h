#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WKWebView, ZZH5BaseScriptHandler;
@interface ZZH5ContainerController : UIViewController

@property (nonatomic, weak, readonly) WKWebView *webView;

@property (nonatomic, copy) NSString *urlString;

/// H5交互类
@property (nonatomic, strong) ZZH5BaseScriptHandler *scriptHandler;

- (void)loadRequestWithUrlString:(NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
