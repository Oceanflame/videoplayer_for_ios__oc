//
//  player.h
//  video1.2
//
//  Created by 李雨泽 on 2021/8/9.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
@interface player:NSObject

@property (nonatomic,strong) AVPlayer      *avPlayer;
@property (nonatomic,strong) AVPlayerItem  *avPlayerItem;
@property (nonatomic,strong) AVPlayerViewController *avPlayerViewController;

-(void)init:(NSString *)path;
@end
