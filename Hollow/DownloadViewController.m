//
//  DownloadViewController.m
//  objTests
//
//  Created by BandarHelal on 13/04/1441 AH.
//  Copyright © 1441 BandarHelal. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)setupTableView {
    NSLog(@"hi");
    // add table view and constraint
    self.DownloadTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.DownloadTableView.delegate = self;
    self.DownloadTableView.dataSource = self;
    self.DownloadTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.DownloadTableView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.DownloadTableView];
    [self.DownloadTableView registerClass:DownloadCell.class forCellReuseIdentifier:@"dCell"];
    
    // setup the array
    if (self.isNeedMerge == true) {
        self.content = [[NSMutableArray alloc] initWithArray:[[NSArray alloc] initWithObjects:self.VideoURL, self.AudioURL, nil]];
    } else if (self.isAudio == true) {
        self.content = [[NSMutableArray alloc] initWithArray:[[NSArray alloc] initWithObjects:self.AudioURL, nil]];
    } else if (self.isSD == true) {
        self.content = [[NSMutableArray alloc] initWithArray:[[NSArray alloc] initWithObjects:self.VideoURL, nil]];
    }
    
    // change nav bar color and style
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorFromHexString:@"282828"]];
    [self.navigationController.navigationBar setTranslucent:false];
    self.navigationItem.title = [[NSString string] localizedStringForKey:@"downloading"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[[NSString string] localizedStringForKey:@"close_button"] style:UIBarButtonItemStylePlain target:self action:@selector(close)];
}

- (void)close {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isNeedMerge == true) {
        return self.content.count-1;
    } else if (self.isAudio == true) {
//        NSLog(@"%lu %@", (unsigned long)self.content.count, self.content);
        return self.content.count;
    } else if (self.isSD == true) {
//        NSLog(@"%lu %@", (unsigned long)self.content.count, self.content);
        return self.content.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadCell *dCell = (DownloadCell *)[self.DownloadTableView dequeueReusableCellWithIdentifier:@"dCell"];
    
    dCell.VideoTitle.text = self.VideoTitle;
    dCell.VideoImage.image = [UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/Videoimage"];
    
    if (self.isNeedMerge == true) {
        self.isDownloading = true;
        [BHDownloadManager Server1DownloadVideo:[NSURL URLWithString:self.VideoURL] WithMergeAudio:[NSURL URLWithString:self.AudioURL] WithFileName:self.VideoTitle progressVideo:^(NSProgress *downloadProgress) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
                    NSNumber *number = [NSNumber numberWithFloat:(float)downloadProgress.fractionCompleted];
                    NSLog(@"%@", [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:number]]);
                    dCell.DownloadedPersent.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:number]];
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"downloading_video...."];
                });
            });
            
        } progressAudio:^(NSProgress *downloadProgress) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
                    NSNumber *number = [NSNumber numberWithFloat:(float)downloadProgress.fractionCompleted];
                    
                    NSLog(@"%@", [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:number]]);
                    dCell.DownloadedPersent.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:number]];
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"downloading_audio...."];
                });
            });
            
        } CompletionHandler:^{
            [self.content removeAllObjects];
            self.VideoURL = nil;
            self.AudioURL = nil;
            self.isDownloading = false;
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"done"];
                    [self dismissViewControllerAnimated:true completion:nil];
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                        content.title = @"Hollow";
                        content.body = [NSString stringWithFormat:@"%@ %@", [[NSString string] localizedStringForKey:@"notification_content"], self.VideoTitle];
                        
                        content.sound = [UNNotificationSound defaultSound];
                        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:content trigger:nil];
                        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                        [center addNotificationRequest:request withCompletionHandler:nil];
                    }
                });
            });
        }];
    }
    if (self.isSD == true) {
        self.isDownloading = true;
        [BHDownloadManager DownloadVideoWithURL:[NSURL URLWithString:self.VideoURL] WithFileName:self.VideoTitle inFolderName:@"BH" progress:^(NSProgress *downloadProgress) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
                    NSNumber *number = [NSNumber numberWithFloat:(float)downloadProgress.fractionCompleted];
                    
                    dCell.DownloadedPersent.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:number]];
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"downloading_video...."];
                });
            });
            
        } CompletionHandler:^{
            [self.content removeAllObjects];
            self.VideoURL = nil;
            self.AudioURL = nil;
            self.isDownloading = false;
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"done"];
                    [self dismissViewControllerAnimated:true completion:nil];
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                        content.title = @"Hollow";
                        content.body = [NSString stringWithFormat:@"%@ %@", [[NSString string] localizedStringForKey:@"notification_content"], self.VideoTitle];
                        content.sound = [UNNotificationSound defaultSound];
                        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:content trigger:nil];
                        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                        [center addNotificationRequest:request withCompletionHandler:nil];
                    }
                });
            });
        }];
    }
    
    if (self.isAudio == true) {
        self.isDownloading = true;
        dCell.VideoImage.image = [UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/Audioimage.png"];
        [BHDownloadManager Server1DownloadAudio:[NSURL URLWithString:self.AudioURL] WithFileName:self.VideoTitle progress:^(NSProgress *downloadProgress) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                    [numberFormatter setNumberStyle:NSNumberFormatterPercentStyle];
                    NSNumber *number = [NSNumber numberWithFloat:(float)downloadProgress.fractionCompleted];
                    
                    dCell.DownloadedPersent.text = [NSString stringWithFormat:@"%@", [numberFormatter stringFromNumber:number]];
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"downloading_audio...."];
                });
            });
            
        } CompletionHandler:^{
            [self.content removeAllObjects];
            self.VideoURL = nil;
            self.AudioURL = nil;
            self.isDownloading = false;
            NSDictionary *dict = [NSDictionary dictionaryWithObject:@"Download_Finsh" forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HideButton" object:nil userInfo:dict];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    dCell.DownloadStatus.text = [[NSString string] localizedStringForKey:@"done"];
                    [self dismissViewControllerAnimated:true completion:nil];
                    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
                        content.title = @"Hollow";
                        content.body = [NSString stringWithFormat:@"%@ %@", [[NSString string] localizedStringForKey:@"notification_content"], self.VideoTitle];
                        
                        content.sound = [UNNotificationSound defaultSound];
                        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:[NSUUID UUID].UUIDString content:content trigger:nil];
                        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                        [center addNotificationRequest:request withCompletionHandler:nil];
                    }
                });
            });
        }];
    }
    
    return dCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

//void print(NSString *format, ...) {
//    NSLog(format)
//}

@end
