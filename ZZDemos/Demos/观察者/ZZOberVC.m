#import "ZZOberVC.h"

@interface ZZOberVC ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) int count;

@end

@implementation ZZOberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自动释放的观察者";
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, 40)];
    [self.view addSubview:self.label];
    self.label.font = UIFontSize(15);
    self.label.text = @"0";
    self.label.textColor = UIColor.blackColor;
    self.label.textAlignment = NSTextAlignmentCenter;
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 200, 80)];
    [self.view addSubview:self.button];
    [self.button setTitle:@"点击一下,自动加1" forState:UIControlStateNormal];
    [self.button setTitleColor:UIColor.blueColor forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.count = 0;
    [self sj_addObserver:self forKeyPath:@"count"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"count"]) {
        NSLog(@"KVO info");
        self.label.text = [NSString stringWithFormat:@"%d", self.count];
    }
}

- (void)addClick {
    self.count += 1;
}

@end
