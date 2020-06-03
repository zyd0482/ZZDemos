#import "ZZRootViewController.h"

@interface ZZRootViewController () <UIGestureRecognizerDelegate>

@end

@implementation ZZRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDefaultProps];
}

- (void)setupDefaultProps {
    _hideNavigationBar = NO;
    if (self.navigationController && self.navigationController.viewControllers.count > 1) {
        _hideNagigationBackButton = NO;
    } else {
        _hideNagigationBackButton = YES;
    }
    _disablePopGesture = NO;
    self.navigationItem.hidesBackButton = YES;
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 导航栏左边的返回按钮
    if (!_hideNagigationBackButton) {
        UIImage *backIcon = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backIcon style:UIBarButtonItemStylePlain target:self action:@selector(doGoBack)];
    }
    [self setupNavigationBar];
    [self.navigationController setNavigationBarHidden:_hideNavigationBar animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - setup
- (void)setupNavigationBar {
    self.navigationController.navigationBar.tintColor = UIColor.whiteColor;
//    self.navigationController.navigationBar.barTintColor = UIColorHex(@"#ff6619");
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    NSDictionary *titleAttr = @{NSFontAttributeName: [UIFont systemFontOfSize:19],
                                NSForegroundColorAttributeName: UIColor.whiteColor};
    self.navigationController.navigationBar.titleTextAttributes = titleAttr;
}

#pragma mark - click action
- (void)doGoBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.childViewControllers.count < 2) return NO;
    return !_disablePopGesture;
}

@end
