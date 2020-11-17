#import "ViewController.h"
#import "ZZH5ContainerController.h"
#import "TLBGuidingVC.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demos";
//    self.datas = @[@"Banner轮播图", @"分享控件", @"WebController", @"崩溃检测", @"自动释放观察者", @"引导图"];
    self.datas = @[@"引导页"];
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = self.datas[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *name = self.datas[indexPath.row];
    UIViewController *vc = nil;
    NSString *className = @"";
    if ([name isEqualToString:@"Banner轮播图"]) {
        className = @"TSBannerVC";
    }
    else if ([name isEqualToString:@"分享控件"]) {
        className = @"TSSharedVC";
    }
    else if ([name isEqualToString:@"WebController"]) {
        vc = [[ZZH5ContainerController alloc] init];
        [((ZZH5ContainerController *)vc) setUrlString:@"http://10.4.17.185/tlboxer/yw/ProjectTL/html/ybt/index.html"];
    }
    else if ([name isEqualToString:@"崩溃检测"]) {
        className = @"ZZBuglyVC";
    }
    else if ([name isEqualToString:@"自动释放观察者"]) {
        className = @"ZZOberVC";
    }
    else if ([name isEqualToString:@"引导页"]) {
        [self openGuiding];
        return;
    }

    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([className length]) {
        UIViewController *classVC = [[NSClassFromString(className) alloc] init];
        [self.navigationController pushViewController:classVC animated:YES];
        return;
    }
}

- (void)openGuiding {
    [TLBGuidingVC openGuidingFrom:self complete:^(BOOL isClickCompleteButton) {
        [UIAlertController showAlertWithMessage:isClickCompleteButton ? @"点击了立即体验" : @"点击了跳过"];
    }];
}


@end
