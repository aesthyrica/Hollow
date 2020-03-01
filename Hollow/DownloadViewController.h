//
//  DownloadViewController.h
//  objTests
//
//  Created by BandarHelal on 13/04/1441 AH.
//  Copyright © 1441 BandarHelal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadCell.h"
#import "BHDownloadManager.h"
#import "Colours.h"
#import <UserNotifications/UserNotifications.h>
#import "MDCAlertController.h"
#import "DownloadedCell.h"

@interface DownloadViewController : UIViewController
@property (nonatomic, strong) UITableView *DownloadTableView;
@property (nonatomic, strong) NSString *VideoTitle;
@property (nonatomic, strong) NSString *VideoURL;
@property (nonatomic, strong) NSString *AudioURL;
@property (nonatomic, strong) NSMutableArray *content;
@property (nonatomic, assign) BOOL isNeedMerge;
@property (nonatomic, assign) BOOL isSD;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) BOOL isAudio;
@end
