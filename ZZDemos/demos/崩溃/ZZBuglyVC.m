#import "ZZBuglyVC.h"
#import "ZZBugly.h"

@interface ZZBuglyVC ()

@property (nonatomic, weak) UIButton *bugButton;

@property (nonatomic, weak) UITextView *textView;

@end

@implementation ZZBuglyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"bugly";
    [ZZBugly setup];
    self.textView.text = [ZZBugly localSavingBugInfo];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.bugButton.width = self.view.width;
    self.bugButton.height = 50;
    self.textView.top = self.bugButton.bottom;
    [self.textView flex];
}

- (void)makeBug {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择一个崩溃方案" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"数组越界" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *arr = @[@"1"];
        NSString *str = arr[1];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (UIButton *)bugButton {
    if (!_bugButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.view addSubview:button];
        _bugButton = button;
        [_bugButton setTitle:@"创建一个bug" forState:UIControlStateNormal];
        [_bugButton addTarget:self action:@selector(makeBug) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bugButton;
}

- (UITextView *)textView {
    if (!_textView) {
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        _textView = textView;
        _textView.font = UIFontSize(14);
        _textView.textColor = UIColor.blackColor;
    }
    return _textView;
}

@end
