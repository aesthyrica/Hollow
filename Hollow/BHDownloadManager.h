//
//  BHDownloadManager.h
//  ColorPickerTest
//
//  Created by BandarHelal on 29/05/2019.
//  Copyright © 2019 BandarHelal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "FCFileManager.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "MaterialDialogs.h"


@interface BHDownloadManager : NSObject
+ (void)Server1DownloadVideo:(NSURL *)vURL WithMergeAudio:(NSURL *)aURL WithFileName:(NSString *)filename progressVideo:(void (^)(NSProgress *downloadProgress)) VideodownloadProgressBlock progressAudio:(void (^)(NSProgress *downloadProgress)) AudiodownloadProgressBlock CompletionHandler:(void (^)(void))handler;

+ (void)Server1DownloadAudio:(NSURL *)url WithFileName:(NSString *)title progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock CompletionHandler:(void (^)(void))handler;

+ (void)DownloadThumbnailWithURL:(NSURL *)url WithFileName:(NSString *)filename inFolderName:(NSString *)folder;

+ (void)DownloadVideo:(NSURL *)vURL WithMergeAudio:(NSURL *)aURL WithFileName:(NSString *)filename inFolderName:(NSString *)folder progressVideo:(void (^)(NSProgress *downloadProgress)) VideodownloadProgressBlock progressAudio:(void (^)(NSProgress *downloadProgress)) AudiodownloadProgressBlock CompletionHandler:(void (^)(void))handler;

+ (void)DownloadVideoWithURL:(NSURL *)url WithFileName:(NSString *)filename inFolderName:(NSString *)folder progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock CompletionHandler:(void (^)(void))handler;

+ (void)DownloadAudioFromVideoURL:(NSURL *)url WithFileName:(NSString *)filename inFolderName:(NSString *)folder progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock CompletionHandler:(void (^)(void))handler;
@end
