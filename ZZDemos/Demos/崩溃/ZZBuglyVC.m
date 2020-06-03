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
    self.textView.text = [ZZBugly localSavingCrashInfo];
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
    [alert addAction:[UIAlertAction actionWithTitle:@"手动抛出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         @throw [NSException exceptionWithName:@"手动抛出异常" reason:@"random exception" userInfo:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"插入空值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *dict = [NSMutableDictionary new];
        [dict setObject:nil forKey:@"a"];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"多线程处理UI" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            tmpView.backgroundColor = UIColor.redColor;
            [self.view addSubview:tmpView];
        });
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"调用不存在的方法" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self performSelector:@selector(unfindSelector)];
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
        _textView.editable = NO;
    }
    return _textView;
}

@end
