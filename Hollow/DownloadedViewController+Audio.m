//
//  DownloadedViewController+Audio.m
//  ColorPickerTest
//
//  Created by BandarHelal on 06/06/2019.
//  Copyright © 2019 BandarHelal. All rights reserved.
//

#import "DownloadedViewController+Audio.h"

@interface DownloadedViewController_Audio () <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@end

@implementation DownloadedViewController_Audio

static NSString *encodeBase64WithData(NSData* theData)
{
    @autoreleasepool {
        const uint8_t *input = (const uint8_t*)[theData bytes];
        NSInteger length = [theData length];
        static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
        uint8_t *output = (uint8_t *)data.mutableBytes;
        NSInteger i;
        for (i=0; i < length; i += 3) {
            NSInteger value = 0;
            NSInteger j;
            for (j = i; j < (i + 3); j++) {
                value <<= 8;
                if (j < length) {
                    value |= (0xFF & input[j]);
                }
            }
            NSInteger theIndex = (i / 3) * 4;
            output[theIndex + 0] =              table[(value >> 18) & 0x3F];
            output[theIndex + 1] =              table[(value >> 12) & 0x3F];
            output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
            output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
        }
        return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isPlayingAudio = false;
    [self SetupViewController];
    [self SetupRemoteTransportControls];
    [self SetupDocumentsDirectoryPath];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMoviePlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:true error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)SetupRemoteTransportControls {
    self.AudioCommandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [self.AudioCommandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self performSelector:@selector(PlayStopButton)];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [self.AudioCommandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self performSelector:@selector(PlayStopButton)];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [self.AudioCommandCenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self audioPlayerDidFinishPlaying:self.audioPlayer successfully:true];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [self.AudioCommandCenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self previousTrack];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [self.AudioCommandCenter.playCommand setEnabled:true];
    [self.AudioCommandCenter.pauseCommand setEnabled:true];
    [self.AudioCommandCenter.nextTrackCommand setEnabled:true];
    [self.AudioCommandCenter.previousTrackCommand setEnabled:true];
    
}

- (void)SetupViewController {
    self.view.backgroundColor = [UIColor clearColor];
    self.RefreshControl = [[UIRefreshControl alloc] init];
    [self.RefreshControl setTintColor:[UIColor whiteColor]];
    [self.RefreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    self.AudioTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.AudioTable setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.AudioTable setBackgroundColor: [UIColor colorFromHexString:@"282828"]];
    [self.AudioTable setOpaque:NO];
    self.AudioTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.AudioTable.delegate = self;
    self.AudioTable.dataSource = self;
    self.AudioTable.refreshControl = self.RefreshControl;
    [self.view addSubview:self.AudioTable];
    [self.AudioTable registerClass:DownloadedCell.class forCellReuseIdentifier:@"Acell"];
    
    [self.AudioTable.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.AudioTable.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.AudioTable.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.AudioTable.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
}

- (void)Refresh {
    [self SetupDocumentsDirectoryPath];
    [self.RefreshControl endRefreshing];
}

- (void)SetupDocumentsDirectoryPath {
    [FCFileManager createDirectoriesForPath:@"BH"];
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
    NSURL *documentsURL = [NSURL fileURLWithPath:documentsDirectoryPath];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    do {
        NSError *error;
        self.Audiofiles = [NSMutableArray arrayWithArray:[NSFileManager.defaultManager contentsOfDirectoryAtURL:[documentsURL URLByAppendingPathComponent:@"BH"] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error]];
        if ([defaults boolForKey:@"sort"]) {
            [self.Audiofiles sortUsingComparator:^NSComparisonResult(NSURL *obj1, NSURL *obj2) {
                
                id da = [[obj1 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil] objectForKey:NSURLCreationDateKey];
                id db = [[obj2 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil] objectForKey:NSURLCreationDateKey];
                return [da compare:db];
            }];
            [self.Audiofiles reverse];
        }
        if (error) {
            NSLog(@"i found some errors:%@", error);
        }
    } while (nil);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.AudioTable reloadData];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.Audiofiles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadedCell *Acell = (DownloadedCell *)[self.AudioTable dequeueReusableCellWithIdentifier:@"Acell"];
    AVAsset *asset = [AVAsset assetWithURL:self.Audiofiles[indexPath.row].absoluteURL];
    NSUInteger durationSeconds = (long)CMTimeGetSeconds(asset.duration);
    NSUInteger hours = floor(durationSeconds / 3600);
    NSUInteger minutes = floor(durationSeconds % 3600 / 60);
    NSUInteger seconds = floor(durationSeconds % 3600 % 60);
    
    Acell.selectionStyle = UITableViewCellSelectionStyleNone;
    [Acell.MoreButton addTarget:self action:@selector(ShowAudioSheet:event:) forControlEvents:UIControlEventTouchUpInside];
    [Acell.TimeLine addTarget:self action:@selector(TimeLineHandler:) forControlEvents:UIControlEventValueChanged];
    [Acell.PlayButton addTarget:self action:@selector(PlayStopButton) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.Audiofiles[indexPath.row].lastPathComponent containsString:@".png"]) {
        
        [self.Audiofiles removeObjectAtIndex:indexPath.row];
        [self.AudioTable reloadData];
        
    } else if ([self.Audiofiles[indexPath.row].lastPathComponent containsString:@".jpg"]) {
        
        [self.Audiofiles removeObjectAtIndex:indexPath.row];
        [self.AudioTable reloadData];
        
    } else if ([self.Audiofiles[indexPath.row].lastPathComponent containsString:@".mp4"]) {
        
        [self.Audiofiles removeObjectAtIndex:indexPath.row];
        [self.AudioTable reloadData];
    } else {
        if (self.Audiofiles[indexPath.row].lastPathComponent) {
            
            if (hours == 0) {
                
                Acell.VideoTitle.text = [self.Audiofiles[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@""];
                Acell.VideoImage.image = [UIImage imageNamed:[self.Audiofiles[indexPath.row].path stringByReplacingOccurrencesOfString:@"m4a" withString:@"png"]];
                // /Library/Application Support/BH/Ressources.bundle/baseline_library_music_white_24pt
                Acell.TypeImage.image = [UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_library_music_white_24pt"];
                Acell.TimeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
            } else {
                
                Acell.VideoTitle.text = [self.Audiofiles[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
                Acell.VideoImage.image = [UIImage imageNamed:[self.Audiofiles[indexPath.row].path stringByReplacingOccurrencesOfString:@"mp4" withString:@"png"]];
                // /Library/Application Support/BH/Ressources.bundle/baseline_video_library_white_24pt
                Acell.TypeImage.image = [UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_video_library_white_24pt"];
                Acell.TimeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
            }
            
        }
    }
    return Acell;
}

- (void)ShowAudioSheet:(id *)sender event:(id)event {
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.AudioTable];
    
    
    NSIndexPath *indexPath = [self.AudioTable indexPathForRowAtPoint:currentTouchPosition];
    self.JODeboxIndexPath = indexPath;
    
    
    MDCActionSheetController *MoreSheet = [MDCActionSheetController actionSheetControllerWithTitle:nil message:nil];
    
    MDCActionSheetAction *importAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"import_to_library"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_folder_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        if ([UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,8"] || [UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,2"] || [UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,4"] || [UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,6"]) {
            
            NSString *base64StringURl = encodeBase64WithData([[self.Audiofiles[indexPath.row] absoluteString] dataUsingEncoding:NSUTF8StringEncoding]);
            base64StringURl = [base64StringURl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
            base64StringURl = [base64StringURl stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
            base64StringURl = [base64StringURl stringByReplacingOccurrencesOfString:@"=" withString:@"."];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"music:///mimport?pathBase=%@", base64StringURl]] options:@{} completionHandler:nil];
            
        } else {
        
        self.importAlertVC = [UIAlertController alertControllerWithTitle:[[NSString string] localizedStringForKey:@"import_song"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        [self.importAlertVC addTextFieldWithConfigurationHandler:nil];
        [self.importAlertVC addTextFieldWithConfigurationHandler:nil];
        [self.importAlertVC addTextFieldWithConfigurationHandler:nil];
        [self.importAlertVC addTextFieldWithConfigurationHandler:nil];
        [self.importAlertVC.textFields[0] setPlaceholder:[[NSString string] localizedStringForKey:@"song_name"]];
        [self.importAlertVC.textFields[0] setText:[self.Audiofiles[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@""]];
        [self.importAlertVC.textFields[1] setPlaceholder:[[NSString string] localizedStringForKey:@"artist_name"]];
        [self.importAlertVC.textFields[2] setPlaceholder:[[NSString string] localizedStringForKey:@"album_name"]];
        [self.importAlertVC.textFields[3] setPlaceholder:[[NSString string] localizedStringForKey:@"genre"]];
        
        UIAlertAction *importAction1 = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"import_with_custom_image"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.navigationItem.title = [[NSString string] localizedStringForKey:@"select_song_image"];
            imagePicker.delegate = self;
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            
            [self presentViewController:imagePicker animated:true completion:nil];
            
        }];
        
        UIAlertAction *importAction2 = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"import_with_video_image"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [JODebox importSongWithTitle:self.importAlertVC.textFields[0].text artist:self.importAlertVC.textFields[1].text image:[UIImage imageNamed:[self.Audiofiles[indexPath.row].path stringByReplacingOccurrencesOfString:@"m4a" withString:@"png"]] albumName:self.importAlertVC.textFields[2].text trackNumber:[NSNumber numberWithInteger:arc4random()] duration:nil year:[NSNumber numberWithInteger:[Data year]] path:self.Audiofiles[indexPath.row].path genre:self.importAlertVC.textFields[3].text];
            
        }];
        
        UIAlertAction *importAction3 = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"import_with_out_image"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [JODebox importSongWithTitle:self.importAlertVC.textFields[0].text artist:self.importAlertVC.textFields[1].text image:nil albumName:self.importAlertVC.textFields[2].text trackNumber:[NSNumber numberWithInteger:arc4random()] duration:nil year:[NSNumber numberWithInteger:[Data year]] path:self.Audiofiles[indexPath.row].path genre:self.importAlertVC.textFields[3].text];
            
//            [SSDown importAudioWithFilePath:self.Audiofiles[indexPath.row] image:nil AudioAsset:[AVAsset assetWithURL:self.Audiofiles[indexPath.row].absoluteURL] AudioTitle:self.importAlertVC.textFields[0].text ArtistName:self.importAlertVC.textFields[1].text AlbumName:self.importAlertVC.textFields[2].text GenreOfAudio:self.importAlertVC.textFields[3].text Year:(int)[Data year] TrackNumber:(int)arc4random() TrackCount:(int)arc4random()];
            
        }];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"cancel"] style:UIAlertActionStyleDefault handler:nil];
        
        [self.importAlertVC addAction:importAction1];
        [self.importAlertVC addAction:importAction2];
        [self.importAlertVC addAction:importAction3];
        [self.importAlertVC addAction:Cancel];
        
        [self presentViewController:self.importAlertVC animated:true completion:nil];
        }
    }];
    
    MDCActionSheetAction *ShareAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"share"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_reply_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        UIActivityViewController *ActivityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.Audiofiles[indexPath.row]] applicationActivities:nil];
        
        [self presentViewController:ActivityVC animated:true completion:nil];
        
    }];
    
    MDCActionSheetAction *RenameAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"rename"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_edit_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[[NSString string] localizedStringForKey:@"write_new_name_to_this_audio"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setText:[self.Audiofiles[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@""]];
        }];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"rename"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [FCFileManager renameItemAtPath:[NSString stringWithFormat:@"BH/%@", self.Audiofiles[indexPath.row].lastPathComponent] withName:[NSString stringWithFormat:@"%@.m4a", alertVC.textFields[0].text]];
            [FCFileManager renameItemAtPath:[NSString stringWithFormat:@"BH/%@", [self.Audiofiles[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@".png"]] withName:[NSString stringWithFormat:@"%@.png", alertVC.textFields[0].text]];
            [self SetupDocumentsDirectoryPath];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"cancel"] style:UIAlertActionStyleCancel handler:nil];
        
        [alertVC addAction:OKAction];
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:true completion:nil];
        
    }];
    
    MDCActionSheetAction *RemoveAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"remove"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_delete_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        [[NSFileManager defaultManager] removeItemAtURL:self.Audiofiles[indexPath.row].absoluteURL error:nil];
        [self.Audiofiles removeObjectAtIndex:indexPath.row];
        [self.AudioTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    MDCActionSheetAction *Cancel = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"cancel"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_clear_white_24pt"] handler:nil];
    
    [MoreSheet addAction:importAction];
    [MoreSheet addAction:ShareAction];
    [MoreSheet addAction:RenameAction];
    [MoreSheet addAction:RemoveAction];
    [MoreSheet addAction:Cancel];
    MoreSheet.inkColor = [UIColor colorWithWhite:0.6 alpha:1];
    MoreSheet.actionTextColor = [UIColor whiteColor];
    MoreSheet.actionTintColor = [UIColor whiteColor];
    [MoreSheet setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
    
    [self presentViewController:MoreSheet animated:true completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadedCell *cell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:indexPath];
    
    if (self.isPlayingAudio == false) {
        self.SelectIndexPath = indexPath;
        self.audioPlayer = nil;
        AVAsset *asset = [AVAsset assetWithURL:self.Audiofiles[indexPath.row].absoluteURL];
        NSUInteger durationSeconds = (long)CMTimeGetSeconds(asset.duration);
        NSUInteger hours = floor(durationSeconds / 3600);
        NSUInteger minutes = floor(durationSeconds % 3600 / 60);
        NSUInteger seconds = floor(durationSeconds % 3600 % 60);
        
        [cell.TypeImage setHidden:true];
        [cell.TimeView setHidden:true];
        [cell.PlayButton setHidden:false];
        [cell.TimeLine setHidden:false];
        [cell.TimeLabelOfTimeLine setHidden:false];
        [cell.TimeLineLabel setHidden:false];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.Audiofiles[indexPath.row] error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        self.isPlayingAudio = true;
        self.AudioTable.scrollEnabled = false;
        [self SetupRemoteTransportControls];
        
        [cell.TimeLine setMaximumValue:(CGFloat)self.audioPlayer.duration];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
            if (hours == 0) {
                [cell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                cell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
                cell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)((int)(cell.TimeLine.value)) / 60, (int)((int)(cell.TimeLine.value)) % 60];
            } else {
                [cell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                cell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
                cell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)((int)(cell.TimeLine.value / 3600)),
                                           (int)((int)(cell.TimeLine.value)) / 60, (int)((int)(cell.TimeLine.value)) % 60];
            }
        }];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                                                                    
                                                                    MPMediaItemPropertyTitle: [self.Audiofiles[self.SelectIndexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@""],
                                                                    
                                                                    MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithInteger:durationSeconds]
                                                                    }];
        
    } else {
        if (self.SelectIndexPath == indexPath) {
            self.isPlayingAudio = false;
            self.audioPlayer = nil;
            self.AudioTable.scrollEnabled = true;
            [cell.TypeImage setHidden:false];
            [cell.TimeView setHidden:false];
            [cell.PlayButton setHidden:true];
            [cell.TimeLine setHidden:true];
            [cell.TimeLabelOfTimeLine setHidden:true];
            [cell.TimeLineLabel setHidden:true];
        } else {
            DownloadedCell *allCell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:self.SelectIndexPath];
            [allCell.TypeImage setHidden:false];
            [allCell.TimeView setHidden:false];
            [allCell.PlayButton setHidden:true];
            [allCell.TimeLine setHidden:true];
            [allCell.TimeLabelOfTimeLine setHidden:true];
            [allCell.TimeLineLabel setHidden:true];
            
            self.SelectIndexPath = indexPath;
            AVAsset *asset = [AVAsset assetWithURL:self.Audiofiles[indexPath.row].absoluteURL];
            NSUInteger durationSeconds = (long)CMTimeGetSeconds(asset.duration);
            NSUInteger hours = floor(durationSeconds / 3600);
            NSUInteger minutes = floor(durationSeconds % 3600 / 60);
            NSUInteger seconds = floor(durationSeconds % 3600 % 60);
            
            [cell.TypeImage setHidden:true];
            [cell.TimeView setHidden:true];
            [cell.PlayButton setHidden:false];
            [cell.TimeLine setHidden:false];
            [cell.TimeLabelOfTimeLine setHidden:false];
            [cell.TimeLineLabel setHidden:false];
            
            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.Audiofiles[indexPath.row] error:nil];
            self.audioPlayer.delegate = self;
            [self.audioPlayer prepareToPlay];
            [self.audioPlayer play];
            self.isPlayingAudio = true;
            self.AudioTable.scrollEnabled = false;
            [self SetupRemoteTransportControls];
            
            [cell.TimeLine setMaximumValue:(CGFloat)self.audioPlayer.duration];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
                if (hours == 0) {
                    [cell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                    cell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
                    cell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)((int)(cell.TimeLine.value)) / 60, (int)((int)(cell.TimeLine.value)) % 60];
                } else {
                    [cell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                    cell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
                    cell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)((int)(cell.TimeLine.value / 3600)),
                                               (int)((int)(cell.TimeLine.value)) / 60, (int)((int)(cell.TimeLine.value)) % 60];
                }
            }];
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 290;
}

- (void)TimeLineHandler:(MDCSlider *)sender {
    
    if (!self.audioPlayer.isPlaying) {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = (NSTimeInterval)sender.value;
    } else {
        [self.audioPlayer stop];
        self.audioPlayer.currentTime = (NSTimeInterval)sender.value;
        [self.audioPlayer play];
    }
}

- (void)PlayStopButton {
    DownloadedCell *Cell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:self.SelectIndexPath];
    if (self.isPlayingAudio == true) {
        [Cell.PlayButton setImage:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_play_arrow_white_48pt"] forState:UIControlStateNormal];
        self.isPlayingAudio = false;
        [self.audioPlayer stop];
    } else if (self.isPlayingAudio == false) {
        [Cell.PlayButton setImage:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_pause_white_48pt"] forState:UIControlStateNormal];
        self.isPlayingAudio = true;
        [self.audioPlayer play];
    }
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    DownloadedCell *cell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:self.SelectIndexPath];
    self.isPlayingAudio = false;
    self.audioPlayer = nil;
    self.AudioTable.scrollEnabled = true;
    [cell.TypeImage setHidden:false];
    [cell.TimeView setHidden:false];
    [cell.PlayButton setHidden:true];
    [cell.TimeLine setHidden:true];
    [cell.TimeLabelOfTimeLine setHidden:true];
    [cell.TimeLineLabel setHidden:true];
    
    if (!(self.SelectIndexPath.row == self.AudioTable.indexPathsForVisibleRows.lastObject.row)) {
        self.SelectIndexPath = [NSIndexPath indexPathForRow:self.SelectIndexPath.row + 1 inSection:0];
        [self.AudioTable scrollToRowAtIndexPath:self.SelectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
        self.AudioTable.scrollEnabled = false;
        DownloadedCell *NextCell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:self.SelectIndexPath];
        AVAsset *asset = [AVAsset assetWithURL:self.Audiofiles[self.SelectIndexPath.row].absoluteURL];
        NSUInteger durationSeconds = (long)CMTimeGetSeconds(asset.duration);
        NSUInteger hours = floor(durationSeconds / 3600);
        NSUInteger minutes = floor(durationSeconds % 3600 / 60);
        NSUInteger seconds = floor(durationSeconds % 3600 % 60);
        
        [NextCell.TypeImage setHidden:true];
        [NextCell.TimeView setHidden:true];
        [NextCell.PlayButton setHidden:false];
        [NextCell.TimeLine setHidden:false];
        [NextCell.TimeLabelOfTimeLine setHidden:false];
        [NextCell.TimeLineLabel setHidden:false];
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.Audiofiles[self.SelectIndexPath.row] error:nil];
        self.audioPlayer.delegate = self;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
        self.isPlayingAudio = true;
        
        [NextCell.TimeLine setMaximumValue:(CGFloat)self.audioPlayer.duration];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
            if (hours == 0) {
                [NextCell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                NextCell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
                NextCell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)((int)(NextCell.TimeLine.value)) / 60, (int)((int)(NextCell.TimeLine.value)) % 60];
            } else {
                [NextCell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                NextCell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
                NextCell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)((int)(NextCell.TimeLine.value / 3600)),
                                               (int)((int)(NextCell.TimeLine.value)) / 60, (int)((int)(NextCell.TimeLine.value)) % 60];
            }
        }];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                                                                    
                                                                    MPMediaItemPropertyTitle: [self.Audiofiles[self.SelectIndexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@""],
                                                                    
                                                                    MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithInteger:durationSeconds]
                                                                    }];
    }
}

- (void)previousTrack {
    DownloadedCell *cell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:self.SelectIndexPath];
    self.isPlayingAudio = false;
    self.audioPlayer = nil;
    self.AudioTable.scrollEnabled = true;
    [cell.TypeImage setHidden:false];
    [cell.TimeView setHidden:false];
    [cell.PlayButton setHidden:true];
    [cell.TimeLine setHidden:true];
    [cell.TimeLabelOfTimeLine setHidden:true];
    [cell.TimeLineLabel setHidden:true];
    
    if (!(self.SelectIndexPath.row == self.AudioTable.indexPathsForVisibleRows.firstObject.row)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.SelectIndexPath = [NSIndexPath indexPathForRow:self.SelectIndexPath.row - 1 inSection:0];
                [self.AudioTable scrollToRowAtIndexPath:self.SelectIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
                self.AudioTable.scrollEnabled = false;
                DownloadedCell *NextCell = (DownloadedCell *)[self.AudioTable cellForRowAtIndexPath:self.SelectIndexPath];
                AVAsset *asset = [AVAsset assetWithURL:self.Audiofiles[self.SelectIndexPath.row].absoluteURL];
                NSUInteger durationSeconds = (long)CMTimeGetSeconds(asset.duration);
                NSUInteger hours = floor(durationSeconds / 3600);
                NSUInteger minutes = floor(durationSeconds % 3600 / 60);
                NSUInteger seconds = floor(durationSeconds % 3600 % 60);
                
                [NextCell.TypeImage setHidden:true];
                [NextCell.TimeView setHidden:true];
                [NextCell.PlayButton setHidden:false];
                [NextCell.TimeLine setHidden:false];
                [NextCell.TimeLabelOfTimeLine setHidden:false];
                [NextCell.TimeLineLabel setHidden:false];
                
                self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.Audiofiles[self.SelectIndexPath.row] error:nil];
                self.audioPlayer.delegate = self;
                [self.audioPlayer prepareToPlay];
                [self.audioPlayer play];
                self.isPlayingAudio = true;
                
                [NextCell.TimeLine setMaximumValue:(CGFloat)self.audioPlayer.duration];
                self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:true block:^(NSTimer * _Nonnull timer) {
                    if (hours == 0) {
                        [NextCell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                        NextCell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
                        NextCell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)((int)(NextCell.TimeLine.value)) / 60, (int)((int)(NextCell.TimeLine.value)) % 60];
                    } else {
                        [NextCell.TimeLine setValue:(CGFloat)self.audioPlayer.currentTime animated:true];
                        NextCell.TimeLabelOfTimeLine.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
                        NextCell.TimeLineLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", (int)((int)(NextCell.TimeLine.value / 3600)),
                                                       (int)((int)(NextCell.TimeLine.value)) / 60, (int)((int)(NextCell.TimeLine.value)) % 60];
                    }
                }];
                [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:@{
                                                                            
                                                                            MPMediaItemPropertyTitle: [self.Audiofiles[self.SelectIndexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".m4a" withString:@""],
                                                                            
                                                                            MPMediaItemPropertyPlaybackDuration: [NSNumber numberWithInteger:durationSeconds]
                                                                            }];
            });
        });
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:true completion:nil];
    
    UIImage *Songimage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [JODebox importSongWithTitle:self.importAlertVC.textFields[0].text artist:self.importAlertVC.textFields[1].text image:Songimage albumName:self.importAlertVC.textFields[2].text trackNumber:[NSNumber numberWithInteger:arc4random()] duration:nil year:[NSNumber numberWithInteger:[Data year]] path:self.Audiofiles[self.SelectIndexPath.row].path genre:self.importAlertVC.textFields[3].text];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

@end
