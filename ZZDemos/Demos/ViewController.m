#import "ViewController.h"
#import "ZZH5ContainerController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datas = @[@"Banner轮播图", @"分享控件", @"WebController", @"崩溃检测", @"自动释放观察者"];
    
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
    UIViewController *vc = nil;
    NSString *className = @"";
    switch (indexPath.row) {
        case 0:
            className = @"TSBannerVC";
            break;
        case 1:
            className = @"TSSharedVC";
            break;
        case 2:
            vc = [[ZZH5ContainerController alloc] init];
            [((ZZH5ContainerController *)vc) setUrlString:@"http://10.4.17.185/tlboxer/yw/ProjectTL/html/ybt/index.html"];
            break;
        case 3:
            className = @"ZZBuglyVC";
            break;
        case 4:
            className = @"ZZOberVC";
            break;
        default:
            break;
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


@end
