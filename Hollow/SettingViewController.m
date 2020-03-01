//
//  SettingViewController.m
//  Hollow
//
//  Created by BandarHelal on 06/08/2019.
//

#import "SettingViewController.h"


@interface SettingViewController ()
@end


@implementation SettingViewController

- (void)loadSettingPrefsOnViewController:(UIViewController *)viewController {
    
    //    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    NSURL *profileimage = [[NSURL alloc] initWithString:@"https://twitter.com/BandarHL/profile_image?size=bigger"];
    
    FRPSection *HeaderSection = [FRPSection sectionWithTitle:[[NSString string] localizedStringForKey:@""] footer:nil];
    
    FRPSwitchCell *Sort = [FRPSwitchCell cellWithTitle:[[NSString string] localizedStringForKey:@"sort_library_by_recently_added"] setting:[FRPSettings settingsWithKey:@"sort" defaultValue:@YES] postNotification:nil changeBlock:nil];
    
    FRPLinkCell *removelib = [FRPLinkCell cellWithTitle:@"Remove all library" selectedBlock:^(UITableViewCell *sender) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"hi" message:@"are you sure you want delete all videos and audios!?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"Delete all library!" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [FCFileManager removeItemsInDirectoryAtPath:@"BH"];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertVC addAction:delete];
        [alertVC addAction:cancel];
        [viewController presentViewController:alertVC animated:true completion:nil];
    }];
    
    FRPLinkCell *backupCell = [FRPLinkCell cellWithTitle:@"Backup files" selectedBlock:^(UITableViewCell *sender) {
        
        if ([FCFileManager existsItemAtPath:@"BH.zip"]) {
            
            JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            HUD.textLabel.text = @"Loading";
            [HUD showInView:viewController.view];
            
            NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
            
            NSURL *filePath = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"BH.zip"];
            
            UIActivityViewController *ActivityVC = [[UIActivityViewController alloc] initWithActivityItems:@[filePath] applicationActivities:nil];
            
            [viewController presentViewController:ActivityVC animated:true completion:^{
                [HUD dismiss];
            }];
            
        } else {
            JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
            HUD.textLabel.text = @"Loading";
            [HUD showInView:viewController.view];
            
            NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
            
            BOOL success = [SSZipArchive createZipFileAtPath:[self tempZipPath] withContentsOfDirectory:[documentsDirectoryPath stringByAppendingPathComponent:@"BH"]];
            
            if (success) {
                [HUD dismiss];
                
                NSURL *filePath = [[NSURL fileURLWithPath:documentsDirectoryPath] URLByAppendingPathComponent:@"BH.zip"];
                
                UIActivityViewController *ActivityVC = [[UIActivityViewController alloc] initWithActivityItems:@[filePath] applicationActivities:nil];
                
                [viewController presentViewController:ActivityVC animated:true completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"hi" message:@"error" delegate:viewController cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        
    }];
    
    FRPLinkCell *restoreBackup = [FRPLinkCell cellWithTitle:@"Restore backup" selectedBlock:^(UITableViewCell *sender) {
        
        MDCActionSheetController *alertSheet = [MDCActionSheetController actionSheetControllerWithTitle:@"select your way to add backup files"];
        
        MDCActionSheetAction *down = [MDCActionSheetAction actionWithTitle:@"from download direct url" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"enter the direct url" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                NSLog(@"%@", textField);
            }];
            
            UIAlertAction *download = [UIAlertAction actionWithTitle:@"Download" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                HUD.textLabel.text = @"Loading";
                [HUD showInView:viewController.view];
                
                [self DownloadFilesToDocumets:[NSURL URLWithString:[NSString stringWithFormat:@"%@", alert.textFields[0]]] progress:^(NSProgress *downloadProgress) {
                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                    if (error) {
                        
                    } else {
                        [HUD dismiss];
                        NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0];
                        [SSZipArchive unzipFileAtPath:[self tempZipPath] toDestination:[documentsDirectoryPath stringByAppendingPathComponent:@"BH"]];
                    }
                }];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:download];
            [alert addAction:cancel];
            
            [viewController presentViewController:alert animated:true completion:nil];
        }];
        [alertSheet addAction:down];
        
        [viewController presentViewController:alertSheet animated:true completion:nil];
    }];
    
    FRPSection *DevSection = [FRPSection sectionWithTitle:[[NSString string] localizedStringForKey:@"contact_me"] footer:nil];
    
    
    
    FRPDeveloperCell *BandarHL = [FRPDeveloperCell cellWithTitle:@"BandarHelal" detail:@"BandarHL" image:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:profileimage]] url:@"https://twitter.com/BandarHL"];
    
    FRPValueCell *version = [FRPValueCell cellWithTitle:@"Version" detail:@"2.5"];
    
    //    [listCell setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
    //    [listCell.textLabel setTextColor:[UIColor whiteColor]];
    [removelib setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
    [removelib.textLabel setTextColor:[UIColor whiteColor]];
    [Sort setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
    [Sort.textLabel setTextColor:[UIColor whiteColor]];
    [backupCell setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
    [backupCell.textLabel setTextColor:[UIColor whiteColor]];
    [BandarHL setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
    [BandarHL.textLabel setTextColor:[UIColor whiteColor]];
    [version setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
    [version.textLabel setTextColor:[UIColor whiteColor]];
    
    [DevSection addCell:BandarHL];
    [DevSection addCell:version];
    //    [HeaderSection addCell:listCell];
    [HeaderSection addCell:Sort];
    [HeaderSection addCell:removelib];
    [HeaderSection addCell:backupCell];
    [HeaderSection addCell:restoreBackup];
    
    FRPreferences *table = [FRPreferences tableWithSections:@[HeaderSection,DevSection] title:nil tintColor:nil];
    [table.tableView  setSeparatorStyle:0];
    [table.tableView setBackgroundColor:[UIColor blackColor]];
    [viewController.navigationController pushViewController:table animated:YES];
    [table.navigationController.navigationBar setBarTintColor:[UIColor colorFromHexString:@"282828"]];
    table.navigationItem.title = [[NSString string] localizedStringForKey:@"settings"];
    table.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [table.navigationController.navigationBar setTranslucent:false];
    
}

- (NSString *)tempZipPath {
    NSString *path = [NSString stringWithFormat:@"%@/BH.zip",
                      NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]];
    return path;
}


- (void)DownloadFilesToDocumets:(NSURL *)url progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler {
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[NSUUID UUID].UUIDString];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:downloadProgressBlock destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:completionHandler];
    [downloadTask resume];
    
}

- (void)incrementHUD:(JGProgressHUD *)HUD progress:(int)progress {
    progress += 1;
    
    [HUD setProgress:progress/100.0f animated:NO];
    HUD.detailTextLabel.text = [NSString stringWithFormat:@"%i%% Complete", progress];
    
    if (progress == 100) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.1 animations:^{
                HUD.textLabel.text = @"Success";
                HUD.detailTextLabel.text = nil;
                HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
            }];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD dismiss];
        });
    }
    else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self incrementHUD:HUD progress:progress];
        });
    }
}

@end
