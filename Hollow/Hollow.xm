#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import "RootViewController.h"
#import "MaterialActionSheet.h"
#import "MaterialSnackbar.h"
#import "MaterialActivityIndicator.h"
#import "DownloadViewController.h"
#import "DaiYoutubeParser.h"
#import <substrate.h>
#import <CoreGraphics/CoreGraphics.h>

%config(generator=internal)

@interface YTMainAppControlsOverlayView : UIView
- (void)DownloadWithServer;
@end

@interface YTRightNavigationButtons : UIView
@end

@interface YTQTMButton : UIButton
@end

@interface YTHeaderContentComboViewController : UIViewController
{
    YTRightNavigationButtons *_rightNavigationButtons;
    YTQTMButton *_MDXButton;
}
- (void)openDownloadLibrary;
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay;
- (void)fireBlockAfterDelay:(void (^)(void))block;
@end

@interface YTPageStyleController : NSObject
@property(nonatomic) long long pageStyle;
@end

@interface YTSlimVideoDetailsActionView : UIView
- (NSString *)accessibilityLabel;
- (void)DownloadWithServer;
@end

@interface YTPlayerViewController : UIViewController
@property(readonly, nonatomic) NSString *contentVideoID;
@property(readonly, nonatomic) NSString *currentVideoID;
- (void)performBlock:(void (^)(void))block
          afterDelay:(NSTimeInterval)delay;
- (void)fireBlockAfterDelay:(void (^)(void))block;
@end

NSString *vID;
NSString *audioURL;
UIWindow *appWindow;
UIButton *DownloadButton;
NSString *thumbnailURL;
UINavigationController *DownloadNavigationController;
DownloadViewController *DownloadVC;
BOOL isDownloadingNow;

RootViewController *RootVC;
UINavigationController *RootNavVC;



%hook YTMainAppControlsOverlayView
- (void)didPressAddTo:(id)arg1 {
    if (!(vID.length == 0)) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
            message.text = [[NSString string] localizedStringForKey:@"please_wait_for_loading_video_information"];
            MDCSnackbarMessageAction *action = [[MDCSnackbarMessageAction alloc] init];
            action.title = @"ok";
            message.action = action;
            [MDCSnackbarManager showMessage:message];
            if (isDownloadingNow == true) {
                MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message:[[NSString string] localizedStringForKey:@"sorry_but_you_must_be_download_videos_1_by_1"]];
                MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
                [alert addAction:ok];
                [alert setTitleColor:[UIColor whiteColor]];
                [alert setMessageColor:[UIColor whiteColor]];
                [alert setButtonTitleColor:[UIColor whiteColor]];
                [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:alert animated:true completion:nil];
                });
            } else if (isDownloadingNow == false) {
                [self DownloadWithServer];
            }
            
    } else {
        MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message:[[NSString string] localizedStringForKey:@"please_wait_3_second_before_click_button"]];
        MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
        [alert addAction:ok];
        [alert setTitleColor:[UIColor whiteColor]];
        [alert setMessageColor:[UIColor whiteColor]];
        [alert setButtonTitleColor:[UIColor whiteColor]];
        [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
        [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
    }
}
%new - (void)DownloadWithServer {
    [[NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://kvm.scar-naruto.com/getVideos/Server1.php?id=%@", vID]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (error) {
                NSLog(@"%@", error);
                // present the error
                MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message: error.localizedDescription];
                MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
                [alert addAction:ok];
                [alert setTitleColor:[UIColor whiteColor]];
                [alert setMessageColor:[UIColor whiteColor]];
                [alert setButtonTitleColor:[UIColor whiteColor]];
                [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:alert animated:true completion:nil];
                });
            } else {
                NSArray *JSONInformation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                for (NSDictionary *info in JSONInformation) {

                    
                    // get images
                    NSArray *image = info[@"image"];
                    if (![image valueForKey:@"max_resolution"]) {
                        if ([image valueForKey:@"high_quality"]) {
                            thumbnailURL = [image valueForKey:@"high_quality"];
                        }
                    } else {
                        thumbnailURL = [image valueForKey:@"max_resolution"];
                    }
                    
                    // make list
                    MDCActionSheetController *Sheet = [MDCActionSheetController actionSheetControllerWithTitle:info[@"title"] message:[[NSString string] localizedStringForKey:@"the_video_supports_these_Qualitys"]];

                    NSArray *URLs = info[@"adaptive_formats"];
                    NSArray *URLs2 = info[@"full_formats"];

                    for (NSDictionary *adaptive_formats in URLs) {
                        NSString *quality = adaptive_formats[@"quality_label"];
                        NSString *Audiotype = adaptive_formats[@"type"];

                        // get 1080p form json
                        if ([quality containsString:@"1080p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q1080 = [MDCActionSheetAction actionWithTitle:@"1080p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                    
                                }];
                                [Sheet addAction:q1080];
                            }
                        }

                        // get 720p from json
                        if ([quality containsString:@"720p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q720 = [MDCActionSheetAction actionWithTitle:@"720p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q720];
                            }
                        }

                        // get 480p from json
                        if ([quality containsString:@"480p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q480 = [MDCActionSheetAction actionWithTitle:@"480p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q480];
                            }
                        }

                        // get 360p from json
                        if ([quality containsString:@"360p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q360 = [MDCActionSheetAction actionWithTitle:@"360p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q360];
                            }
                        }

                        // get 240p from json
                        if ([quality containsString:@"240p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q240 = [MDCActionSheetAction actionWithTitle:@"240p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q240];
                            }
                        }

                        // get 144p from json
                        if ([quality containsString:@"144p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q144 = [MDCActionSheetAction actionWithTitle:@"144p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q144];
                            }
                        }

                        // get audios
                        if ([Audiotype containsString:@"audio/mp4"]) {
                            audioURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                            MDCActionSheetAction *qAudio = [MDCActionSheetAction actionWithTitle:@"Audio" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                isDownloadingNow = true;
                                DownloadVC.isNeedMerge = false;
                                DownloadVC.isAudio = true;
                                DownloadVC.isSD = false;
                                DownloadVC.AudioURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                [appWindow addSubview:DownloadButton];
                                [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                            }];
                            [Sheet addAction:qAudio];
                        }
                    }

                    for (NSDictionary *full_formats in URLs2) {
                        NSString *quality = full_formats[@"quality"];
                        
                        
                        if ([quality containsString:@"medium"]) {
                            NSString *type = full_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *qSD = [MDCActionSheetAction actionWithTitle:@"SD (medium)" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = false;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = true;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", full_formats[@"url"]];
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:qSD];
                            }
                        }
                        
                        if ([quality containsString:@"hd720"]) {
                            NSString *type = full_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *qSD = [MDCActionSheetAction actionWithTitle:@"SD (hd720)" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = false;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = true;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", full_formats[@"url"]];
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:qSD];
                            }
                        }
                    }

                    // present the list
                    MDCActionSheetAction *cancel = [MDCActionSheetAction actionWithTitle:@"Cancel" image:nil handler:nil];
                    [Sheet addAction:cancel];
                    Sheet.titleTextColor = [UIColor whiteColor];
                    Sheet.messageTextColor = [UIColor whiteColor];
                    Sheet.inkColor = [UIColor colorWithWhite:0.6 alpha:1];
                    Sheet.actionTextColor = [UIColor whiteColor];
                    Sheet.actionTintColor = [UIColor whiteColor];
                    [Sheet setBackgroundColor:[UIColor colorFromHexString:@"282828"]];

                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:Sheet animated:true completion:nil];
                    });

                }
            }

        }] resume];
}
%end

%hook YTSlimVideoDetailsActionView
- (void)didTapButton:(id)arg1 {
    
    if ([self.accessibilityLabel isEqualToString:@"Save"] || [self.accessibilityLabel isEqualToString:@"حفظ"] || [self.accessibilityLabel isEqualToString:@"enregistrer"] || [self.accessibilityLabel isEqualToString:@"Enregistrer"] || [self.accessibilityLabel isEqualToString:@"Guardar"]) {
        if (!(vID.length == 0)) {
                MDCSnackbarMessage *message = [[MDCSnackbarMessage alloc] init];
                message.text = [[NSString string] localizedStringForKey:@"please_wait_for_loading_video_information"];
                MDCSnackbarMessageAction *action = [[MDCSnackbarMessageAction alloc] init];
                action.title = @"ok";
                message.action = action;
                [MDCSnackbarManager showMessage:message];
                if (isDownloadingNow == true) {
                    MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message:[[NSString string] localizedStringForKey:@"sorry_but_you_must_be_download_videos_1_by_1"]];
                    MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
                    [alert addAction:ok];
                    [alert setTitleColor:[UIColor whiteColor]];
                    [alert setMessageColor:[UIColor whiteColor]];
                    [alert setButtonTitleColor:[UIColor whiteColor]];
                    [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                    [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:alert animated:true completion:nil];
                    });
                } else if (isDownloadingNow == false) {
                    [self DownloadWithServer];
                }
            
        } else {
            MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message:[[NSString string] localizedStringForKey:@"please_wait_3_second_before_click_button"]];
            MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
            [alert addAction:ok];
            [alert setTitleColor:[UIColor whiteColor]];
            [alert setMessageColor:[UIColor whiteColor]];
            [alert setButtonTitleColor:[UIColor whiteColor]];
            [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
            [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:true completion:nil];
        }
    } else {
        %orig;
    }
}
%new - (void)DownloadWithServer {
    [[NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://kvm.scar-naruto.com/getVideos/Server1.php?id=%@", vID]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (error) {
                NSLog(@"%@", error);
                // present the error
                MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message: error.localizedDescription];
                MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
                [alert addAction:ok];
                [alert setTitleColor:[UIColor whiteColor]];
                [alert setMessageColor:[UIColor whiteColor]];
                [alert setButtonTitleColor:[UIColor whiteColor]];
                [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:alert animated:true completion:nil];
                });
            } else {
                NSArray *JSONInformation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                for (NSDictionary *info in JSONInformation) {

                    
                    // get images
                    NSArray *image = info[@"image"];
                    if (![image valueForKey:@"max_resolution"]) {
                        if ([image valueForKey:@"high_quality"]) {
                            thumbnailURL = [image valueForKey:@"high_quality"];
                        }
                    } else {
                        thumbnailURL = [image valueForKey:@"max_resolution"];
                    }
                    
                    // make list
                    MDCActionSheetController *Sheet = [MDCActionSheetController actionSheetControllerWithTitle:info[@"title"] message:[[NSString string] localizedStringForKey:@"the_video_supports_these_Qualitys"]];

                    NSArray *URLs = info[@"adaptive_formats"];
                    NSArray *URLs2 = info[@"full_formats"];

                    for (NSDictionary *adaptive_formats in URLs) {
                        NSString *quality = adaptive_formats[@"quality_label"];
                        NSString *Audiotype = adaptive_formats[@"type"];

                        // get 1080p form json
                        if ([quality containsString:@"1080p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q1080 = [MDCActionSheetAction actionWithTitle:@"1080p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                    
                                }];
                                [Sheet addAction:q1080];
                            }
                        }

                        // get 720p from json
                        if ([quality containsString:@"720p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q720 = [MDCActionSheetAction actionWithTitle:@"720p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q720];
                            }
                        }

                        // get 480p from json
                        if ([quality containsString:@"480p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q480 = [MDCActionSheetAction actionWithTitle:@"480p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q480];
                            }
                        }

                        // get 360p from json
                        if ([quality containsString:@"360p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q360 = [MDCActionSheetAction actionWithTitle:@"360p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q360];
                            }
                        }

                        // get 240p from json
                        if ([quality containsString:@"240p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q240 = [MDCActionSheetAction actionWithTitle:@"240p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q240];
                            }
                        }

                        // get 144p from json
                        if ([quality containsString:@"144p"]) {
                            NSString *type = adaptive_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *q144 = [MDCActionSheetAction actionWithTitle:@"144p" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = true;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = false;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                    DownloadVC.AudioURL = audioURL;
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:q144];
                            }
                        }

                        // get audios
                        if ([Audiotype containsString:@"audio/mp4"]) {
                            audioURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                            MDCActionSheetAction *qAudio = [MDCActionSheetAction actionWithTitle:@"Audio" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                isDownloadingNow = true;
                                DownloadVC.isNeedMerge = false;
                                DownloadVC.isAudio = true;
                                DownloadVC.isSD = false;
                                DownloadVC.AudioURL = [NSString stringWithFormat:@"%@", adaptive_formats[@"url"]];
                                DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                [appWindow addSubview:DownloadButton];
                                [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                            }];
                            [Sheet addAction:qAudio];
                        }
                    }

                    for (NSDictionary *full_formats in URLs2) {
                        NSString *quality = full_formats[@"quality"];
                        
                        
                        if ([quality containsString:@"medium"]) {
                            NSString *type = full_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *qSD = [MDCActionSheetAction actionWithTitle:@"SD (medium)" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = false;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = true;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", full_formats[@"url"]];
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:qSD];
                            }
                        }
                        
                        if ([quality containsString:@"hd720"]) {
                            NSString *type = full_formats[@"type"];
                            if ([type containsString:@"video/mp4"]) {
                                MDCActionSheetAction *qSD = [MDCActionSheetAction actionWithTitle:@"SD (hd720)" image:nil handler:^(MDCActionSheetAction * _Nonnull action) {
                                    [BHDownloadManager DownloadThumbnailWithURL:[NSURL URLWithString:thumbnailURL] WithFileName:[NSString stringWithFormat:@"%@", info[@"title"]] inFolderName:@"BH"];
                                    isDownloadingNow = true;
                                    DownloadVC.isNeedMerge = false;
                                    DownloadVC.isAudio = false;
                                    DownloadVC.isSD = true;
                                    DownloadVC.VideoURL = [NSString stringWithFormat:@"%@", full_formats[@"url"]];
                                    DownloadVC.VideoTitle = [NSString stringWithFormat:@"%@", info[@"title"]];
                                    [appWindow addSubview:DownloadButton];
                                    [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
                                }];
                                [Sheet addAction:qSD];
                            }
                        }
                    }

                    // present the list
                    MDCActionSheetAction *cancel = [MDCActionSheetAction actionWithTitle:@"Cancel" image:nil handler:nil];
                    [Sheet addAction:cancel];
                    Sheet.titleTextColor = [UIColor whiteColor];
                    Sheet.messageTextColor = [UIColor whiteColor];
                    Sheet.inkColor = [UIColor colorWithWhite:0.6 alpha:1];
                    Sheet.actionTextColor = [UIColor whiteColor];
                    Sheet.actionTintColor = [UIColor whiteColor];
                    [Sheet setBackgroundColor:[UIColor colorFromHexString:@"282828"]];

                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [[UIApplication.sharedApplication keyWindow].rootViewController presentViewController:Sheet animated:true completion:nil];
                    });

                }
            }

        }] resume];
}
%end


%hook YTPlayerViewController
- (void)viewDidLoad {
    %orig;
    // /Library/Application Support/BH/Ressources.bundl
    // setup the view controllers
    isDownloadingNow = false;
    appWindow = [[[UIApplication sharedApplication] delegate] window];
    DownloadVC = [[DownloadViewController alloc] init];
    DownloadNavigationController = [[UINavigationController alloc] initWithRootViewController:DownloadVC];
    
    // setup the move button
    DownloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [DownloadButton setImage:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/Download_arrow"] forState:UIControlStateNormal];
    long long page = [[objc_getClass("YTPageStyleController") alloc] pageStyle];
    NSNumber *num = [NSNumber numberWithLongLong:page];
    if (num == [NSNumber numberWithInteger:1]) {
        [DownloadButton setTintColor:[UIColor whiteColor]];
    } else {
        [DownloadButton setTintColor:[UIColor colorFromHexString:@"666666"]];
    }
    [DownloadButton setFrame:CGRectMake(150, 150, 80, 80)];
    [DownloadButton handleControlEvents:UIControlEventTouchUpInside withBlock:^(id weakSender) {
        [appWindow.rootViewController presentViewController:DownloadNavigationController animated:true completion:nil];
    }];
    UIPanGestureRecognizer *MoveButton = [[UIPanGestureRecognizer alloc] initWithBlock:^(UIPanGestureRecognizer *recognizer) {
        if ([recognizer state] == UIGestureRecognizerStateChanged) {
            CGPoint translation = [recognizer translationInView:appWindow];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
            [recognizer setTranslation:CGPointMake(0, 0) inView:appWindow];
        }
    }];
    [DownloadButton addGestureRecognizer:MoveButton];
}

- (void)viewDidAppear:(_Bool)arg1 {
    %orig;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"HideButton" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *messageDictionary = note.userInfo;
        NSString *message = [messageDictionary valueForKey:@"message"];
        if (message != nil) {
            NSLog(@"reset");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DownloadButton removeFromSuperview];
                    DownloadVC = [[DownloadViewController alloc] init];
                    DownloadNavigationController = [[UINavigationController alloc] initWithRootViewController:DownloadVC];
                    MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message:@"Download complete"];
                    MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
                    [alert addAction:ok];
                    [alert setTitleColor:[UIColor whiteColor]];
                    [alert setMessageColor:[UIColor whiteColor]];
                    [alert setButtonTitleColor:[UIColor whiteColor]];
                    [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                    [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                    [appWindow.rootViewController presentViewController:alert animated:true completion:nil];
                });
            });
            isDownloadingNow = false;
        }
    }];
    
    [self performBlock:^{
        vID = self.currentVideoID;
    } afterDelay:3];
}
%new - (void)performBlock:(void (^)(void))block
afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

%new - (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

%end

%hook YTHeaderContentComboViewController

- (void)viewDidLoad {
    %orig;
    RootVC = [[RootViewController alloc] init];
    RootNavVC = [[UINavigationController alloc] initWithRootViewController:RootVC];
    [RootNavVC.navigationBar setTranslucent:false];
    [RootNavVC.navigationBar setShadowImage:[[UIImage alloc] init]];
    [RootNavVC.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

%new - (void)performBlock:(void (^)(void))block
afterDelay:(NSTimeInterval)delay
{
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

%new - (void)fireBlockAfterDelay:(void (^)(void))block {
    block();
}

- (void)viewDidAppear:(_Bool)arg1 {
    %orig;
    YTRightNavigationButtons *rightNavigationButtons = MSHookIvar<YTRightNavigationButtons *>(self, "_rightNavigationButtons");
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(openDownloadLibrary) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"/Library/Application Support/BH/Ressources.bundle/baseline_folder_white_24pt"] forState:UIControlStateNormal];
    long long page = [[objc_getClass("YTPageStyleController") alloc] pageStyle];
    NSNumber *num = [NSNumber numberWithLongLong:page];
    if (num == [NSNumber numberWithInteger:1]) {
        [button setTintColor:[UIColor whiteColor]];
    } else {
        [button setTintColor:[UIColor colorFromHexString:@"666666"]];
    }
    [button setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.view addSubview:button];
    [button.centerYAnchor constraintEqualToAnchor:rightNavigationButtons.centerYAnchor].active = true;
    [button.topAnchor constraintEqualToAnchor:rightNavigationButtons.topAnchor].active = true;
    [button.leadingAnchor constraintEqualToAnchor:rightNavigationButtons.leadingAnchor constant:-35].active = true;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"HideButton" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSDictionary *messageDictionary = note.userInfo;
        NSString *message = [messageDictionary valueForKey:@"message"];
        if (message != nil) {
            NSLog(@"reset");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [DownloadButton removeFromSuperview];
                    DownloadVC = [[DownloadViewController alloc] init];
                    DownloadNavigationController = [[UINavigationController alloc] initWithRootViewController:DownloadVC];
                    MDCAlertController *alert = [MDCAlertController alertControllerWithTitle:@"Hi" message:@"Download complete"];
                    MDCAlertAction *ok = [MDCAlertAction actionWithTitle:@"ok" handler:nil];
                    [alert addAction:ok];
                    [alert setTitleColor:[UIColor whiteColor]];
                    [alert setMessageColor:[UIColor whiteColor]];
                    [alert setButtonTitleColor:[UIColor whiteColor]];
                    [alert setButtonInkColor:[UIColor colorWithWhite:0.7 alpha:1]];
                    [alert setBackgroundColor:[UIColor colorFromHexString:@"282828"]];
                    [appWindow.rootViewController presentViewController:alert animated:true completion:nil];
                });
            });
            isDownloadingNow = false;
        }
    }];
}
%new - (void)openDownloadLibrary {
    
    [self presentViewController:RootNavVC animated:true completion:nil];
}

%end


%hook YTAppDelegate

- (_Bool)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)arg2 {
    %orig;
    [FCFileManager removeItemAtPath:@"AUDIOCONVERTED.m4a"];
    [FCFileManager removeItemAtPath:@"FILETRIMED.mp4"];
    [FCFileManager removeItemAtPath:@"videoplayback.mp4"];
    [FCFileManager removeItemAtPath:@"videoplayback.m4a"];
    [FCFileManager removeItemAtPath:@"videoplayback.txt"];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        //sort
        [FCFileManager createDirectoriesForPath:@"BH"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"sort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return true;
}
%end

%hook YTSingleVideoController
- (_Bool)isCurrentlyBackgroundable {
    return YES;
}
%end

%hook YTVASTAd
- (_Bool)isSkippable {
    return YES;
}

- (_Bool)_skippable {
    return YES;
}

-(bool)isForecastingAd {
    return NO;
}

%end

%hook YTVideoQualitySwitchController

- (_Bool)canSelectFormat:(id)arg1 {
    return YES;
}

- (_Bool)_qualitySwitchAvailable {
    return YES;
}
- (_Bool)_qualitySwitchEnabled {
    return YES;
}

%end

%hook YTIPlayabilityStatus
- (bool)isPlayableInBackground {
    return true;
}
%end

%hook YTIPlayerResponse
- (bool)isMonetized {
    return false;
}
- (_Bool)adsAllowReuse {
    return NO;
}
%end

%hook YTPromotedVideoCellController
- (bool)shouldShowPromotedItems {
    return false;
}
%end

%hook YTIPlayabilityStatus
- (bool)isAgeCheckRequired {
    return false;
}
%end

%hook YTIPlayabilityStatus
- (bool)isPlayable {
    return true;
}
%end

%hook YTPlayerRequestFactory
- (bool)adultContentConfirmed {
    return true;
}
%end

%hook YTSettings
- (bool)enableMDXAutoCasting {
    return false;
}
%end

%hook YTSingleVideoMediaData
- (bool)isPlayableInBackground {
    return true;
}
%end

%hook YTReachability
- (BOOL)isOnWiFi {
    return true;
}
%end

%hook YTSettings
- (void)setStreamHDOnWiFiOnly:(BOOL)arg1 {
    arg1 = false;
    %orig;
}
%end

%hook YTSettings
- (BOOL)streamHDOnWiFiOnly {
    return false;
}
%end

%hook YTSettingsViewController
- (BOOL)onStreamHDOnWiFiOnly:(BOOL)arg1 {
    arg1 = false;
    return false;
    return %orig;
}
%end

%hook YTUserDefaults
- (BOOL)streamHDOnWiFiOnly {
    return false;
}
%end
