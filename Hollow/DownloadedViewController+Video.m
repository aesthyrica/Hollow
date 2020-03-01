//
//  DownloadedViewController+Video.m
//  ColorPickerTest
//
//  Created by BandarHelal on 06/06/2019.
//  Copyright © 2019 BandarHelal. All rights reserved.
//

#import "DownloadedViewController+Video.h"


@interface DownloadedViewController_Video () <UITableViewDelegate, UITableViewDataSource>
@end


@implementation DownloadedViewController_Video

static NSString *encodeBase64WithData(NSData* theData)
{
    @autoreleasepool {
        const uint8_t *input = (const uint8_t *)[theData bytes];
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
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorFromHexString:@"282828"]];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    
                                                                    NSForegroundColorAttributeName: [UIColor whiteColor]
                                                                    
                                                                    };
    [self SetupViewController];
    [self SetupDocumentsDirectoryPath];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setMode:AVAudioSessionModeMoviePlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:true error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)SetupViewController {
    
    self.view.backgroundColor = [UIColor clearColor];
    self.RefreshControl = [[UIRefreshControl alloc] init];
    [self.RefreshControl setTintColor:[UIColor whiteColor]];
    [self.RefreshControl addTarget:self action:@selector(Refresh) forControlEvents:UIControlEventValueChanged];
    self.table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.table setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.table setBackgroundColor: [UIColor colorFromHexString:@"282828"]];
    [self.table setOpaque:NO];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.refreshControl = self.RefreshControl;
    [self.view addSubview:self.table];
    [self.view sendSubviewToBack:self.table];
    [self.table registerClass:DownloadedCell.class forCellReuseIdentifier:@"Vcell"];
    
    [self.table.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = true;
    [self.table.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.table.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
    [self.table.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    
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
        self.files = [NSMutableArray arrayWithArray:[NSFileManager.defaultManager contentsOfDirectoryAtURL:[documentsURL URLByAppendingPathComponent:@"BH"] includingPropertiesForKeys:@[] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error]];
        if ([defaults boolForKey:@"sort"]) {
            [self.files sortUsingComparator:^NSComparisonResult(NSURL *obj1, NSURL *obj2) {
                
                id da = [[obj1 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil] objectForKey:NSURLCreationDateKey];
                id db = [[obj2 resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:nil] objectForKey:NSURLCreationDateKey];
                return [da compare:db];
            }];
            [self.files reverse];
        }
        
        if (error) {
            NSLog(@"i found some errors:%@", error);
        }
    } while (nil);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.table reloadData];
    });
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadedCell *cell = (DownloadedCell *)[self.table dequeueReusableCellWithIdentifier:@"Vcell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.MoreButton addTarget:self action:@selector(ShowSheet:event:) forControlEvents:UIControlEventTouchUpInside];
    
    
    AVAsset *asset = [AVAsset assetWithURL:self.files[indexPath.row].absoluteURL];
    NSUInteger durationSeconds = (long)CMTimeGetSeconds(asset.duration);
    NSUInteger hours = floor(durationSeconds / 3600);
    NSUInteger minutes = floor(durationSeconds % 3600 / 60);
    NSUInteger seconds = floor(durationSeconds % 3600 % 60);
    
    
    if ([self.files[indexPath.row].lastPathComponent containsString:@".png"]) {
        
        [self.files removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
        
    } else if ([self.files[indexPath.row].lastPathComponent containsString:@".jpg"]) {
        
        [self.files removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
        
    } else if ([self.files[indexPath.row].lastPathComponent containsString:@".m4a"]) {
        
        [self.files removeObjectAtIndex:indexPath.row];
        [self.table reloadData];
        
    } else {
        
        if (self.files[indexPath.row].lastPathComponent) {
            
            if (hours == 0) {
                cell.VideoTitle.text = [self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
                cell.VideoImage.image = [UIImage imageNamed:[self.files[indexPath.row].path stringByReplacingOccurrencesOfString:@"mp4" withString:@"png"]];
                cell.TypeImage.image = [UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_video_library_white_24pt"];
                //cell.ChannelImage.image = [UIImage imageNamed:[self.files[indexPath.row].path stringByReplacingOccurrencesOfString:@".mp4" withString:@"C.png"]];
                cell.TimeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu",(unsigned long)minutes,(unsigned long)seconds];
            } else {
                cell.VideoTitle.text = [self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@""];
                cell.VideoImage.image = [UIImage imageNamed:[self.files[indexPath.row].path stringByReplacingOccurrencesOfString:@"mp4" withString:@"png"]];
                cell.TypeImage.image = [UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_video_library_white_24pt"];
                //cell.ChannelImage.image = [UIImage imageNamed:[self.files[indexPath.row].path stringByReplacingOccurrencesOfString:@".mp4" withString:@"C.png"]];
                cell.TimeLabel.text = [NSString stringWithFormat:@"%02lu:%02lu:%02lu",(unsigned long)hours,(unsigned long)minutes,(unsigned long)seconds];
            }
            
            return cell;
        }
    }
    return UITableViewCell.new;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AVPlayerItem *video = [AVPlayerItem playerItemWithURL:self.files[indexPath.row].absoluteURL];
    self.VideoPlayer = [AVPlayer playerWithPlayerItem:video];
    AVPlayerViewController *videoViewController = [[AVPlayerViewController alloc] init];
    videoViewController.player = self.VideoPlayer;
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController presentViewController:videoViewController animated:true completion:^{
        [self.VideoPlayer play];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 290;
}


- (void)ShowSheet:(id *)sender event:(id)event {
    
    
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:self.table];
    
    NSIndexPath *indexPath = [self.table indexPathForRowAtPoint: currentTouchPosition];
    
    MDCActionSheetController *actionSheet = [MDCActionSheetController actionSheetControllerWithTitle:nil
                                                                                             message:nil];
    
    // /Library/Application Support/BH/Ressources.bundle/baseline_folder_white_24pt
    MDCActionSheetAction *importAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"import_to_library"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_folder_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        MDCActionSheetController *actionSheet2 = [MDCActionSheetController actionSheetControllerWithTitle:nil
                                                                                                 message:nil];
        // Apple Music
        MDCActionSheetAction *AppleMusic = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"apple_music"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_folder_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
            
            if ([UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,8"] || [UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,2"] || [UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,4"] || [UIDeviceHardware platformString] == [UIDeviceHardware platformStringForType:@"iPhone11,6"]) {
                
                NSString *base64StringURl = encodeBase64WithData([[self.files[indexPath.row] absoluteString] dataUsingEncoding:NSUTF8StringEncoding]);
                base64StringURl = [base64StringURl stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
                base64StringURl = [base64StringURl stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
                base64StringURl = [base64StringURl stringByReplacingOccurrencesOfString:@"=" withString:@"."];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"music:///mimport?pathBase=%@", base64StringURl]] options:@{} completionHandler:nil];
                
            } else {
            
            // import video to music
            self.alertVC = [UIAlertController alertControllerWithTitle:[[NSString string] localizedStringForKey:@"import_video_to_music"] message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            // Song name
            [self.alertVC addTextFieldWithConfigurationHandler:nil];
            [self.alertVC addTextFieldWithConfigurationHandler:nil];
            [self.alertVC addTextFieldWithConfigurationHandler:nil];
            
            // setup text fields @"Video name"
            [self.alertVC.textFields[0] setPlaceholder:[[NSString string] localizedStringForKey:@"video_name"]];
            [self.alertVC.textFields[0] setText:[self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@""]];
            [self.alertVC.textFields[1] setPlaceholder:[[NSString string] localizedStringForKey:@"artist_name"]];
            [self.alertVC.textFields[2] setPlaceholder:[[NSString string] localizedStringForKey:@"genre"]];
            
            UIAlertAction *importAction = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"import"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [JODebox importMusicVideoWithTitle:self.alertVC.textFields[0].text artist:self.alertVC.textFields[1].text image:nil duration:nil year:[NSNumber numberWithInteger:[Data year]] path:self.files[indexPath.row].path genre:self.alertVC.textFields[2].text];
                
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"cancel"] style:UIAlertActionStyleDefault handler:nil];
            
            [self.alertVC addAction:importAction];
            [self.alertVC addAction:cancel];
            
            [self presentViewController:self.alertVC animated:true completion:nil];
            }
        }];
        
        MDCActionSheetAction *CameraRoll = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"camera_roll"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_folder_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
            
            __block PHObjectPlaceholder *placeholder;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:self.files[indexPath.row].absoluteURL];
                placeholder = [createAssetRequest placeholderForCreatedAsset];
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
                if (error != nil) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MDCAlertController *alertController = [MDCAlertController alertControllerWithTitle:@"hi" message:[[NSString string] localizedStringForKey:@"error_save_video"]];
                        
                        MDCAlertAction *alertAction = [MDCAlertAction actionWithTitle:@"OK" handler:nil];
                        [alertController setTitleColor:[UIColor whiteColor]];
                        [alertController setMessageColor:[UIColor whiteColor]];
                        [alertController setButtonTitleColor:[UIColor whiteColor]];
                        [alertController setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                        [alertController setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                        [alertController addAction:alertAction];
                        
                        [self presentViewController:alertController animated:true completion:nil];
                    });
                } else {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MDCAlertController *alertController = [MDCAlertController alertControllerWithTitle:@"hi" message:[[NSString string] localizedStringForKey:@"success_save_video"]];
                        
                        MDCAlertAction *alertAction = [MDCAlertAction actionWithTitle:@"OK" handler:nil];
                        [alertController setTitleColor:[UIColor whiteColor]];
                        [alertController setMessageColor:[UIColor whiteColor]];
                        [alertController setButtonTitleColor:[UIColor whiteColor]];
                        [alertController setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                        [alertController setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                        [alertController addAction:alertAction];
                        
                        [self presentViewController:alertController animated:true completion:nil];
                    });
                }
            }];
        }];
        
        [actionSheet2 addAction:AppleMusic];
        [actionSheet2 addAction:CameraRoll];
        actionSheet2.inkColor = [UIColor colorWithWhite:0.6 alpha:1];
        actionSheet2.actionTextColor = [UIColor whiteColor];
        actionSheet2.actionTintColor = [UIColor whiteColor];
        [actionSheet2 setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
        
        [self presentViewController:actionSheet2 animated:true completion:nil];
        
        
    }];
    
    MDCActionSheetAction *MakeThumbnail = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"make_new_thumbnail"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_tab_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        [self MakeThumbnailFromVideoPath:self.files[indexPath.row].absoluteURL imageName:[self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@""] SaveToPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]];
        [self SetupDocumentsDirectoryPath];
    }];
    
    // /Library/Application Support/BH/Ressources.bundle/baseline_reply_white_24pt
    MDCActionSheetAction *ShareAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"share"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_reply_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        UIActivityViewController *ActivityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.files[indexPath.row]] applicationActivities:nil];
        
        [self presentViewController:ActivityVC animated:true completion:nil];
    }];
    
    // /Library/Application Support/BH/Ressources.bundle/baseline_delete_white_24pt
    MDCActionSheetAction *RemoveAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"remove"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_delete_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        [[NSFileManager defaultManager] removeItemAtURL:self.files[indexPath.row].absoluteURL error:nil];
        [self.files removeObjectAtIndex:indexPath.row];
        [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }];
    
    MDCActionSheetAction *renameAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"rename"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_edit_white_24pt"] handler:^(MDCActionSheetAction * _Nonnull action) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:[[NSString string] localizedStringForKey:@"write_new_name_to_this_video"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            [textField setText:[self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@""]];
        }];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"rename"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [FCFileManager renameItemAtPath:[NSString stringWithFormat:@"BH/%@", self.files[indexPath.row].lastPathComponent] withName:[NSString stringWithFormat:@"%@.mp4", alertVC.textFields[0].text]];
            [FCFileManager renameItemAtPath:[NSString stringWithFormat:@"BH/%@", [self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@".mp4" withString:@".png"]] withName:[NSString stringWithFormat:@"%@.png", alertVC.textFields[0].text]];
            [self SetupDocumentsDirectoryPath];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:[[NSString string] localizedStringForKey:@"cancel"] style:UIAlertActionStyleCancel handler:nil];
        
        [alertVC addAction:OKAction];
        [alertVC addAction:cancel];
        
        [self presentViewController:alertVC animated:true completion:nil];
    }];
    
    MDCActionSheetAction *ConvertAction = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"convert_to_audio"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_audiotrack_white_24pt.png"] handler:^(MDCActionSheetAction * _Nonnull action) {
        NSString *FinalTitle = [NSString stringWithFormat:@"%@", [self.files[indexPath.row].lastPathComponent stringByReplacingOccurrencesOfString:@"mp4" withString:@"m4a"]];
        [[BHUtilities new] ConvertVideoToAudio:self.files[indexPath.row] VideoTitle:FinalTitle];
    }];
    
    
    // /Library/Application Support/BH/Ressources.bundle/baseline_clear_white_24pt
    MDCActionSheetAction *Cancel = [MDCActionSheetAction actionWithTitle:[[NSString string] localizedStringForKey:@"cancel"] image:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_clear_white_24pt"] handler:nil];
    
    
    [actionSheet addAction:importAction];
    [actionSheet addAction:MakeThumbnail];
    [actionSheet addAction:ShareAction];
    [actionSheet addAction:renameAction];
    [actionSheet addAction:RemoveAction];
    [actionSheet addAction:ConvertAction];
    [actionSheet addAction:Cancel];
    actionSheet.inkColor = [UIColor colorWithWhite:0.6 alpha:1];
    actionSheet.actionTextColor = [UIColor whiteColor];
    actionSheet.actionTintColor = [UIColor whiteColor];
    [actionSheet setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
    
    [self presentViewController:actionSheet animated:true completion:nil];
}

- (void)MakeThumbnailFromVideoPath:(NSURL *)url imageName:(NSString *)imagename SaveToPath:(NSString *)documentsDirectory  {
    
    AVURLAsset *asset1 = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset1];
    generator.appliesPreferredTrackTransform = YES;
    
    CGSize maxSize = CGSizeMake(1280, 720);
    generator.maximumSize = maxSize;
    NSError *error;
    CGImageRef imgRef = [generator copyCGImageAtTime:CMTimeMake(asset1.duration.value/2, asset1.duration.timescale) actualTime:NULL error:&error];
    if (error) {
        MDCAlertController *alertController = [MDCAlertController alertControllerWithTitle:@"ERROR" message:[NSString stringWithFormat:@"%@", error]];
        
        MDCAlertAction *alertAction = [MDCAlertAction actionWithTitle:@"OK" handler:nil];
        [alertController setTitleColor:[UIColor whiteColor]];
        [alertController setMessageColor:[UIColor whiteColor]];
        [alertController setButtonTitleColor:[UIColor whiteColor]];
        [alertController setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
        [alertController setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
        [alertController addAction:alertAction];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
    UIImage *thumbnail = [[UIImage alloc] initWithCGImage:imgRef];
    
    NSData *imageData = UIImagePNGRepresentation(thumbnail);
    [imageData writeToFile:[[documentsDirectory stringByAppendingPathComponent:@"BH"] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", imagename]] atomically:true];
}

@end
