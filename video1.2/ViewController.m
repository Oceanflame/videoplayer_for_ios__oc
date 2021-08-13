//
//  ViewController.m
//  video1.2
//
//  Created by 李雨泽 on 2021/8/7.
//

#import "ViewController.h"
#import "player.h"

static NSString * const kDemoTableViewCellReuseIdentifier = @"MyDemoCell";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,AVPlayerViewControllerDelegate>

@property NSInteger *number;
@property NSString *docpath;
@property NSArray<NSString *> *paths;
@property NSArray<NSString *> *nameList;//存放文件地址
@property AVPlayerViewController *playerViewController;
@property AVPlayerLayer *playerlayer;//渲染层
@property AVPlayer *player;
@property UIButton *back;
@property UIView *backview;
@property (nonatomic, strong) UIControl *closeControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);//获取文件夹路径？？？
    NSString *path =[self.paths objectAtIndex:0];//documnets文件夹路径
    _docpath = path;
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
#pragma mark - AVPlayerViewControllerDelegate


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
    _docpath =[self.paths objectAtIndex:0];
    NSString *filepath =[_docpath stringByAppendingString:@"/"];
    filepath = [filepath stringByAppendingString:self.nameList[indexPath.row]];
    NSLog(@"%@",filepath);
    //NSString *newpath =[filepath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc]initFileURLWithPath:filepath isDirectory:YES];
    NSLog(@"%@",url);

    if (_playerViewController) {
            _playerViewController = nil;
        }
        _playerViewController = [[AVPlayerViewController alloc]  init];// 配置媒体播放控制器
        _playerViewController.delegate = self;//打开默认组件
        _playerViewController.showsPlaybackControls = YES;// 设置是否显示媒体播放组件
    _playerViewController.allowsPictureInPicturePlayback = NO;//无画中画
        _playerViewController.player = [AVPlayer playerWithURL:url];// 设置媒体源数据
        self.playerlayer =[AVPlayerLayer playerLayerWithPlayer:_playerViewController.player];
        [self.view.layer addSublayer:self.playerlayer];
        _playerViewController.videoGravity = AVLayerVideoGravityResizeAspect;// 设置拉伸模式
        [_playerViewController.player play];// 播放视频
        _playerViewController.view.bounds = UIScreen.mainScreen.bounds;//CGRectMake(0, 100, 320, 400); // 设置媒体播放器视图大小(全屏)
        _playerViewController.view.center = self.view.center;// 推送至媒体播放器进行播放
//      [self presentViewController:_playerViewController animated:YES completion:nil];
//      直接在本视图控制器播放
        _back = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//        _back = [UIButton buttonWithType:UIButtonTypeCustom];//设置返回按钮
        [_back setBackgroundColor:UIColor.blueColor];//设置按钮颜色
        [_back addTarget:self action:@selector(closeControl) forControlEvents:UIControlEventTouchUpInside];// 点击事件
//        [_backview addSubview:_back];//加入到播放层
        [self addChildViewController:_playerViewController];
        [self.view addSubview:_playerViewController.view];
        [self.view addSubview:_back];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(back) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    
}

-(UIControl *)closeControl
{
    if(_back)
    {
        [_playerViewController.view removeFromSuperview];
    }
    return _back;
}


//- (UIControl *)closeControl
//{
//    if (!_closeControl) {
//        _closeControl = [[UIControl alloc] init];
//        [_closeControl addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        _closeControl.backgroundColor = [UIColor colorWithRed:0.14 green:0.14 blue:0.14 alpha:0.8];
//        _closeControl.tintColor = [UIColor colorWithWhite:1 alpha:0.55];
//        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
//        UIImage *normalImage = [UIImage imageNamed:@"closeAV.png" inBundle:bundle compatibleWithTraitCollection:nil];
//        [_closeControl.layer setContents:(id)normalImage.CGImage];
//        _closeControl.layer.contentsGravity = kCAGravityCenter;
//        _closeControl.layer.cornerRadius = 17;
//        _closeControl.layer.masksToBounds = YES;
//    }
//    return _closeControl;
//    
//}
@end
