//
//  player.m
//  video1.2
//
//  Created by 李雨泽 on 2021/8/9.
//

#import <Foundation/Foundation.h>
#import "player.h"
@interface player()

@end

@implementation player

-(void)init:(NSString *)path
{
    NSURL *url = [[NSURL alloc] initWithString:path];
    self.avPlayer = [[AVPlayer alloc]initWithURL:url ];
    self.avPlayerItem = self.avPlayer.currentItem;
    self.avPlayerViewController.player = self.avPlayer;
}

@end
