//
//  SettingViewController.h
//  Hollow
//
//  Created by BandarHelal on 06/08/2019.
//

#import <UIKit/UIKit.h>
#import "FRPrefs.h"
#import "MDCAlertController.h"
#import "MaterialActionSheet.h"
#import "Colours.h"
#import "DownloadedCell.h"
#import "FCFileManager.h"
#import "SSZipArchive.h"
#import "JGProgressHUD.h"
#import "AFNetworking.h"

@interface SettingViewController : UIViewController
- (void)loadSettingPrefsOnViewController:(UIViewController *)viewController;
@end
