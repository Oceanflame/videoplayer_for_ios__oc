//
//  ViewController.m
//  video1.2
//
//  Created by 哈 on 2021/8/7.
//

#import "ViewController.h"
static NSString * const kDemoTableViewCellReuseIdentifier = @"MyDemoCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property NSInteger *number;
@property NSArray<NSString *> *paths;
@property NSArray<NSString *> *nameList;//存放文件地址

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//获取文件夹路径？？？
    NSString *path =[self.paths objectAtIndex:0];//documnets文件夹路径
    NSFileManager *filemanager = [NSFileManager defaultManager];//创建一个文件管理器对象
    _nameList = [filemanager contentsOfDirectoryAtPath:path error:nil];//文件管理器的这个方法，可以返回对应文件夹里的文件名存入一个字符串数组中
    
    self.videoTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];//初始化videoTableView
    self.view.backgroundColor = UIColor.grayColor;//背景色灰色
    self.videoTableView.delegate = self;//规定委托
    self.videoTableView.dataSource = self;//规定数据源
    self.videoTableView.separatorInset = UIEdgeInsetsZero; // 分割线的左右间距
    self.videoTableView.separatorColor = UIColor.blueColor; // 分割线的颜色
    self.videoTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;// 分割线的样式
    self.videoTableView.tableFooterView = [[UIView alloc] init]; // 隐藏无数据的分割线
    
    [self.view addSubview:self.videoTableView];//将videoTableView加入到主视图view中
    
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDemoTableViewCellReuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDemoTableViewCellReuseIdentifier];
    }
    cell.textLabel.text = self.nameList[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
