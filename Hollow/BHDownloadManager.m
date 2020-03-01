//
//  BHDownloadManager.m
//  ColorPickerTest
//
//  Created by BandarHelal on 29/05/2019.
//  Copyright © 2019 BandarHelal. All rights reserved.
//

#import "BHDownloadManager.h"

@implementation BHDownloadManager

+ (void)DownloadAudioFromVideoURL:(NSURL *)url WithFileName:(NSString *)filename inFolderName:(NSString *)folder progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock CompletionHandler:(void (^)(void))handler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [[documentsDirectoryURL URLByAppendingPathComponent:folder] URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error1) {
        //        NSString *str = [NSString stringWithFormat:@"%@/%@",folder,filePath.lastPathComponent];
        //        [FCFileManager renameItemAtPath:str withName:[NSString stringWithFormat:@"%@.mp4",filename]];
        //        NSLog(@"Done");
        
        if (error1) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
            MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error1 localizedDescription]]];
            MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
            
            [alert addAction:ok];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        } else {
            NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
            
            AVMutableComposition *newAudioAsset = [AVMutableComposition composition];
            AVMutableCompositionTrack *dstCompositionTrack;
            dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            
            AVAsset *srcAsset = [AVURLAsset URLAssetWithURL:filePath.absoluteURL options:nil];
            AVAssetTrack *srcTrack = [[srcAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            
            
            CMTimeRange timeRange = srcTrack.timeRange;
            
            NSError *error;
            
            if (NO == [dstCompositionTrack insertTimeRange:timeRange ofTrack:srcTrack atTime:kCMTimeZero error:&error]) {
                NSLog(@"track insert failed: %@\n", error);
                return;
            }
            
            
            AVAssetExportSession *exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
            
            exportSesh.outputFileType = AVFileTypeAppleM4A;
            exportSesh.outputURL = [[[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:folder] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a",filename]];
            
            
            [exportSesh exportAsynchronouslyWithCompletionHandler:^{
                AVAssetExportSessionStatus  status = exportSesh.status;
                NSLog(@"export: %ld", (long)status);
                
                if (AVAssetExportSessionStatusFailed == status) {
                    NSLog(@"FAILURE: %@\n", exportSesh.error);
                } else if (AVAssetExportSessionStatusCompleted == status) {
                    NSLog(@"SUCCESS!\n");
                    [[NSFileManager defaultManager] removeItemAtURL:filePath.absoluteURL error:nil];
                    handler();
                }
            }];
        }
    }];
    [downloadTask resume];
}

+ (void)DownloadVideoWithURL:(NSURL *)url WithFileName:(NSString *)filename inFolderName:(NSString *)folder progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock CompletionHandler:(void (^)(void))handler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [[documentsDirectoryURL URLByAppendingPathComponent:folder] URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
            MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
            MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
            
            [alert addAction:ok];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        } else {
            NSString *str = [NSString stringWithFormat:@"%@/%@",folder,filePath.lastPathComponent];
            [FCFileManager renameItemAtPath:str withName:[NSString stringWithFormat:@"%@.mp4",filename]];
            handler();
            NSLog(@"Done");
        }
    }];
    [downloadTask resume];
    
}

+ (void)Server1DownloadVideo:(NSURL *)vURL WithMergeAudio:(NSURL *)aURL WithFileName:(NSString *)filename progressVideo:(void (^)(NSProgress *downloadProgress)) VideodownloadProgressBlock progressAudio:(void (^)(NSProgress *downloadProgress)) AudiodownloadProgressBlock CompletionHandler:(void (^)(void))handler {
    
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *Video = [NSURLRequest requestWithURL:vURL];
    NSURLRequest *Audio = [NSURLRequest requestWithURL:aURL];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:Video progress:VideodownloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable VideoFilePath, NSError * _Nullable error) {
        
        if (error) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
            MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
            MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
            
            [alert addAction:ok];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        } else {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURLSessionDownloadTask *downtask = [manager downloadTaskWithRequest:Audio progress:AudiodownloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable AudioFilePath, NSError * _Nullable error) {
                
                if (error) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object:nil userInfo:dict];
                    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
                    MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
                    MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
                    
                    [alert addAction:ok];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
                } else {
                    
                    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:VideoFilePath options:nil];
                    
                    //create exportSession and exportVideo Quality
                    
                    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
                    
                    exportSession.outputURL = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"FILETRIMED.mp4"];
                    
                    exportSession.shouldOptimizeForNetworkUse = YES;
                    
                    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
                    
                    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, CMTimeMake(asset.duration.value /2, asset.duration.timescale));
                    
                    exportSession.timeRange = range;
                    
                    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
                        AVAssetExportSessionStatus  status = exportSession.status;
                        NSLog(@"export: %ld", (long)status);
                        
                        if (AVAssetExportSessionStatusFailed == status) {
                            NSLog(@"FAILURE: %@\n", exportSession.error);
                        } else if (AVAssetExportSessionStatusCompleted == status) {
                            
                            AVMutableComposition *newAudioAsset = [AVMutableComposition composition];
                            AVMutableCompositionTrack *dstCompositionTrack;
                            dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
                            
                            
                            AVAsset *srcAsset = [AVURLAsset URLAssetWithURL:AudioFilePath options:nil];
                            AVAssetTrack *srcTrack = [[srcAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
                            
                            CMTime stopTime = CMTimeMake(srcTrack.timeRange.duration.value /2, srcTrack.timeRange.duration.timescale);
                            CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(srcTrack.timeRange.start, stopTime);
                            NSError *error;
                            
                            if (NO == [dstCompositionTrack insertTimeRange:exportTimeRange ofTrack:srcTrack atTime:kCMTimeZero error:&error]) {
                                NSLog(@"track insert failed: %@\n", error);
                                return;
                            }
                            
                            AVAssetExportSession *exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
                            
                            exportSesh.outputFileType = AVFileTypeQuickTimeMovie;
                            exportSesh.outputURL = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"AUDIOCONVERTED.m4a"];
                            
                            
                            [exportSesh exportAsynchronouslyWithCompletionHandler:^{
                                AVAssetExportSessionStatus  status = exportSesh.status;
                                NSLog(@"export: %ld", (long)status);
                                
                                if (AVAssetExportSessionStatusFailed == status) {
                                    NSLog(@"FAILURE: %@\n", exportSesh.error);
                                } else if (AVAssetExportSessionStatusCompleted == status) {
                                    NSLog(@"SUCCESS!\n");
                                    handler();
                                    [self MarageVideo:exportSession.outputURL withAudio:exportSesh.outputURL WithFileTitle:filename];
                                }
                            }];
                            
                        }
                    }];
                    
                }
            }];
            [downtask resume];
        }
    }];
    [downloadtask resume];
}


+ (void)Server1DownloadAudio:(NSURL *)url WithFileName:(NSString *)title progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock CompletionHandler:(void (^)(void))handler {
    
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
            MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
            MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
            
            [alert addAction:ok];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        } else {
            AVMutableComposition *newAudioAsset = [AVMutableComposition composition];
            AVMutableCompositionTrack *dstCompositionTrack;
            dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            
            AVAsset *srcAsset = [AVURLAsset URLAssetWithURL:filePath options:nil];
            AVAssetTrack *srcTrack = [[srcAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
            
            CMTime stopTime = CMTimeMake(srcTrack.timeRange.duration.value /2, srcTrack.timeRange.duration.timescale);
            CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(srcTrack.timeRange.start, stopTime);
            NSError *error;
            
            if (NO == [dstCompositionTrack insertTimeRange:exportTimeRange ofTrack:srcTrack atTime:kCMTimeZero error:&error]) {
                NSLog(@"track insert failed: %@\n", error);
                return;
            }
            
            AVAssetExportSession *exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
            
            exportSesh.outputFileType = AVFileTypeAppleM4A;
            exportSesh.outputURL = [[[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"BH"] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4a", title]];
            
            
            [exportSesh exportAsynchronouslyWithCompletionHandler:^{
                AVAssetExportSessionStatus  status = exportSesh.status;
                NSLog(@"export: %ld", (long)status);
                
                if (AVAssetExportSessionStatusFailed == status) {
                    NSLog(@"FAILURE: %@\n", exportSesh.error);
                } else if (AVAssetExportSessionStatusCompleted == status) {
                    NSLog(@"SUCCESS!\n");
                    [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
                    handler();
                }
            }];
        }
        
        
    }];
    [downloadTask resume];
    
    
}


+ (void)DownloadVideo:(NSURL *)vURL WithMergeAudio:(NSURL *)aURL WithFileName:(NSString *)filename inFolderName:(NSString *)folder progressVideo:(void (^)(NSProgress *downloadProgress)) VideodownloadProgressBlock progressAudio:(void (^)(NSProgress *downloadProgress)) AudiodownloadProgressBlock CompletionHandler:(void (^)(void))handler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *Video = [NSURLRequest requestWithURL:vURL];
    NSURLRequest *Audio = [NSURLRequest requestWithURL:aURL];
    
    NSURLSessionDownloadTask *downloadtask = [manager downloadTaskWithRequest:Video progress:VideodownloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable VideoFilePath, NSError * _Nullable error) {
        
        if (error) {
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
            MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
            MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
            
            [alert addAction:ok];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        } else {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURLSessionDownloadTask *downtask = [manager downloadTaskWithRequest:Audio progress:AudiodownloadProgressBlock destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable AudioFilePath, NSError * _Nullable error) {
                
                if (error) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationMessageEvent" object:nil userInfo:dict];
                    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:true completion:nil];
                    MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Sorry" message:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
                    MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok 😪" handler:nil];
                    
                    [alert addAction:ok];
                    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
                } else {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            handler();
                            [self GetAudioFromVideoWithURL:AudioFilePath video:VideoFilePath videoTitle:filename];
                        });
                    });
                }
            }];
            [downtask resume];
        }
    }];
    [downloadtask resume];
    
}

+ (void)DownloadThumbnailWithURL:(NSURL *)url WithFileName:(NSString *)filename inFolderName:(NSString *)folder {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        //        NSString *str = [NSString stringWithFormat:@"%@/%@",folder,filePath.lastPathComponent];
        if ([FCFileManager existsItemAtPath:[NSString stringWithFormat:@"BH/%@.png", filename]]) {
            [[NSFileManager defaultManager] removeItemAtURL:filePath error:nil];
        } else {
            [FCFileManager renameItemAtPath:filePath.lastPathComponent withName:[NSString stringWithFormat:@"%@.png",filename]];
            [FCFileManager moveItemAtPath:[NSString stringWithFormat:@"%@.png", filename] toPath:[NSString stringWithFormat:@"BH/%@.png", filename]];
            NSLog(@"Done");
        }
    }];
    [downloadTask resume];
    
}

+ (void)GetAudioFromVideoWithURL:(NSURL *)FilePath video:(NSURL *)vURL videoTitle:(NSString *)title {
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    
    AVMutableComposition *newAudioAsset = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *dstCompositionTrack;
    dstCompositionTrack = [newAudioAsset addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    
    AVAsset *srcAsset = [AVURLAsset URLAssetWithURL:FilePath options:nil];
    AVAssetTrack *srcTrack = [[srcAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    
    CMTimeRange timeRange = srcTrack.timeRange;
    
    NSError *error;
    
    if (NO == [dstCompositionTrack insertTimeRange:timeRange ofTrack:srcTrack atTime:kCMTimeZero error:&error]) {
        NSLog(@"track insert failed: %@\n", error);
        return;
    }
    
    
    AVAssetExportSession *exportSesh = [[AVAssetExportSession alloc] initWithAsset:newAudioAsset presetName:AVAssetExportPresetPassthrough];
    
    exportSesh.outputFileType = AVFileTypeAppleM4A;
    exportSesh.outputURL = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"AUDIOCONVERTED.m4a"];
    
    
    [exportSesh exportAsynchronouslyWithCompletionHandler:^{
        AVAssetExportSessionStatus  status = exportSesh.status;
        NSLog(@"export: %ld", (long)status);
        
        if (AVAssetExportSessionStatusFailed == status) {
            NSLog(@"FAILURE: %@\n", exportSesh.error);
        } else if (AVAssetExportSessionStatusCompleted == status) {
            NSLog(@"SUCCESS!\n: %@", exportSesh.outputURL);
            [self trimVideo:vURL VideoTitle:title];
        }
    }];
}

+ (void)trimVideo:(NSURL *)originalURL VideoTitle:(NSString *)title {
    
    //create asset of the video
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    
    NSURL *VideoPath = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"FILETRIMED.mp4"];
    NSURL *AudioPath = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"AUDIOCONVERTED.m4a"];
    
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:originalURL options:nil];
    
    //create exportSession and exportVideo Quality
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
    
    exportSession.outputURL = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"FILETRIMED.mp4"];
    
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, CMTimeMake(asset.duration.value /2, asset.duration.timescale));
    
    exportSession.timeRange = range;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        switch (exportSession.status)
            
        {
            case
            AVAssetExportSessionStatusCompleted:
                NSLog(@"Trim is Done");
                [FCFileManager removeItemAtPath:@"videoplayback.m4a"];
                [FCFileManager removeItemAtPath:@"videoplayback.mp4"];
                [self MarageVideo:VideoPath withAudio:AudioPath WithFileTitle:title];
                break;
            case AVAssetExportSessionStatusFailed:
                NSLog(@"Trim failed with error ===>>> %@",exportSession.error);
                break;
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Canceled:%@",exportSession.error);
                break;
            default:
                break;
        }
        
    }];
    
}

+ (void)MarageVideo:(NSURL *)vURL withAudio:(NSURL *)Aurl WithFileTitle:(NSString *)title {
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    
    AVURLAsset *audioAsset = [[AVURLAsset alloc]initWithURL:Aurl options:nil];
    AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:vURL options:nil];
    
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    AVMutableCompositionTrack *compositionCommentaryTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionCommentaryTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                        ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                                         atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                   preferredTrackID:kCMPersistentTrackID_Invalid];
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)
                                   ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                                    atTime:kCMTimeZero error:nil];
    
    AVAssetExportSession *_assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetPassthrough];
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = [[[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"BH"] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",title]];
    _assetExport.shouldOptimizeForNetworkUse = YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:
     ^(void ) {
        NSLog(@"fileSaved !");
        [FCFileManager removeItemAtPath:@"AUDIOCONVERTED.m4a"];
        [FCFileManager removeItemAtPath:@"FILETRIMED.mp4"];
        [FCFileManager removeItemAtPath:@"videoplayback.mp4"];
        [FCFileManager removeItemAtPath:@"videoplayback.m4a"];
        [FCFileManager removeItemAtPath:@"videoplayback.txt"];
    }
     ];
}
@end
