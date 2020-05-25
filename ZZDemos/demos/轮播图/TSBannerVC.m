#import "TSBannerVC.h"
#import "ZZBannerView.h"

@interface TSBannerVC () <ZZBannerViewDelegate>

@property (nonatomic, weak) ZZBannerView *bannerView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation TSBannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = @[
        @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1720147146,576882765&fm=26&gp=0.jpg",
        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1175179067,2902739431&fm=26&gp=0.jpg",
        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1595128334,82706458&fm=26&gp=0.jpg",
        @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3184788618,602910243&fm=26&gp=0.jpg",
        @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=2932341999,1832469493&fm=26&gp=0.jpg"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.bannerView reloadDatas];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.bannerView.frame = CGRectMake(0, 50, self.view.bounds.size.width, 150);
}

#pragma mark - ZZBannerViewDelegate
- (NSInteger)bannerViewCountOfDatas:(ZZBannerView *)banner {
    return self.datas.count;
}

- (NSURL *)bannerView:(ZZBannerView *)banner urlForIndex:(NSInteger)index {
    return self.datas[index];
}

- (void)bannerView:(ZZBannerView *)banner didClickWithIndex:(NSInteger)index {
    NSLog(@"banner被点击, index:%ld url:%@", index, self.datas[index]);
}

- (ZZBannerView *)bannerView {
    if (!_bannerView) {
        ZZBannerView *view = [[ZZBannerView alloc] init];
        [self.view addSubview:view];
        _bannerView = view;
        _bannerView.autoScrollDuration = 0;
        _bannerView.delegate = self;
    }
    return _bannerView;
}

@end
