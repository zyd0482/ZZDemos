#import "TSSharedVC.h"
#import "ZZSharedManager.h"

@interface TSSharedVC ()

@property (nonatomic, strong) UIButton *sharedButton;

@end

@implementation TSSharedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sharedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:self.sharedButton];
    [self.sharedButton setTitle:@"点击分享" forState:UIControlStateNormal];
    [self.sharedButton addTarget:self action:@selector(sharedClick) forControlEvents:UIControlEventTouchUpInside];
    self.sharedButton.frame = CGRectMake(50, 100, 100, 80);
}

- (void)sharedClick {
    ZZSharedInfo *info = [[ZZSharedInfo alloc] init];
    info.panelTitle = @"aaa";
    info.panelSubTitle = @"bbb";
    info.title = @"aaaaaaaaaaa";
    info.message = @"bbbbbbbbbb";
    info.url = @"https://baidu.com";
    [ZZSharedManager openSharedWithOption:0 info:info complete:^{
        NSLog(@"1111111");
    }];
}


@end
