//
//  DownloadedViewController+Audio.h
//  ColorPickerTest
//
//  Created by BandarHelal on 06/06/2019.
//  Copyright © 2019 BandarHelal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "FCFileManager.h"
#import "Colours.h"
#import "MaterialActionSheet.h"
#import "DownloadedCell.h"
#import "jodebox.h"
#import "MaterialDialogs.h"
#import "UIDevice+BHUIDevice.h"
#import "UIDeviceHardware.h"

@interface DownloadedViewController_Audio : UIViewController
@property (nonatomic, strong) UITableView *AudioTable;
@property (nonatomic, strong) UIRefreshControl *RefreshControl;
@property (nonatomic, strong) NSMutableArray<NSURL *> *Audiofiles;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MPRemoteCommandCenter *AudioCommandCenter;
@property (nonatomic, strong) UIAlertController *importAlertVC;
@property (nonatomic, strong) NSIndexPath *SelectIndexPath;
@property (nonatomic, strong) NSIndexPath *JODeboxIndexPath;
@property (nonatomic, strong) UIImage *VideoImage;
@property (nonatomic, assign) BOOL isPlayingAudio;
@end
