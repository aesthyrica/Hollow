#line 1 "/Users/bandarhelal/Desktop/Tweaks/Hollow/JB/Hollow/Hollow.xm"
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

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
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

- (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
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




#include <objc/message.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

__attribute__((unused)) static void _logos_register_hook$(Class _class, SEL _cmd, IMP _new, IMP *_old) {
unsigned int _count, _i;
Class _searchedClass = _class;
Method *_methods;
while (_searchedClass) {
_methods = class_copyMethodList(_searchedClass, &_count);
for (_i = 0; _i < _count; _i++) {
if (method_getName(_methods[_i]) == _cmd) {
if (_class == _searchedClass) {
*_old = method_getImplementation(_methods[_i]);
*_old = method_setImplementation(_methods[_i], _new);
} else {
class_addMethod(_class, _cmd, _new, method_getTypeEncoding(_methods[_i]));
}
free(_methods);
return;
}
}
free(_methods);
_searchedClass = class_getSuperclass(_searchedClass);
}
}
@class YTPlayerRequestFactory; @class YTSingleVideoMediaData; @class YTSettingsViewController; @class YTVASTAd; @class YTUserDefaults; @class YTReachability; @class YTSingleVideoController; @class YTHeaderContentComboViewController; @class YTPlayerViewController; @class YTSettings; @class YTAppDelegate; @class YTSlimVideoDetailsActionView; @class YTMainAppControlsOverlayView; @class YTIPlayabilityStatus; @class YTVideoQualitySwitchController; @class YTIPlayerResponse; @class YTPromotedVideoCellController; 
static Class _logos_superclass$_ungrouped$YTMainAppControlsOverlayView; static void (*_logos_orig$_ungrouped$YTMainAppControlsOverlayView$didPressAddTo$)(_LOGOS_SELF_TYPE_NORMAL YTMainAppControlsOverlayView* _LOGOS_SELF_CONST, SEL, id);static Class _logos_superclass$_ungrouped$YTSlimVideoDetailsActionView; static void (*_logos_orig$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$)(_LOGOS_SELF_TYPE_NORMAL YTSlimVideoDetailsActionView* _LOGOS_SELF_CONST, SEL, id);static Class _logos_superclass$_ungrouped$YTPlayerViewController; static void (*_logos_orig$_ungrouped$YTPlayerViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL);static void (*_logos_orig$_ungrouped$YTPlayerViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST, SEL, _Bool);static Class _logos_superclass$_ungrouped$YTHeaderContentComboViewController; static void (*_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidLoad)(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST, SEL);static void (*_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$)(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST, SEL, _Bool);static Class _logos_superclass$_ungrouped$YTAppDelegate; static _Bool (*_logos_orig$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$)(_LOGOS_SELF_TYPE_NORMAL YTAppDelegate* _LOGOS_SELF_CONST, SEL, UIApplication *, id);static Class _logos_superclass$_ungrouped$YTSingleVideoController; static _Bool (*_logos_orig$_ungrouped$YTSingleVideoController$isCurrentlyBackgroundable)(_LOGOS_SELF_TYPE_NORMAL YTSingleVideoController* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTVASTAd; static _Bool (*_logos_orig$_ungrouped$YTVASTAd$isSkippable)(_LOGOS_SELF_TYPE_NORMAL YTVASTAd* _LOGOS_SELF_CONST, SEL);static _Bool (*_logos_orig$_ungrouped$YTVASTAd$_skippable)(_LOGOS_SELF_TYPE_NORMAL YTVASTAd* _LOGOS_SELF_CONST, SEL);static bool (*_logos_orig$_ungrouped$YTVASTAd$isForecastingAd)(_LOGOS_SELF_TYPE_NORMAL YTVASTAd* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTVideoQualitySwitchController; static _Bool (*_logos_orig$_ungrouped$YTVideoQualitySwitchController$canSelectFormat$)(_LOGOS_SELF_TYPE_NORMAL YTVideoQualitySwitchController* _LOGOS_SELF_CONST, SEL, id);static _Bool (*_logos_orig$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchAvailable)(_LOGOS_SELF_TYPE_NORMAL YTVideoQualitySwitchController* _LOGOS_SELF_CONST, SEL);static _Bool (*_logos_orig$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchEnabled)(_LOGOS_SELF_TYPE_NORMAL YTVideoQualitySwitchController* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTIPlayabilityStatus; static bool (*_logos_orig$_ungrouped$YTIPlayabilityStatus$isPlayableInBackground)(_LOGOS_SELF_TYPE_NORMAL YTIPlayabilityStatus* _LOGOS_SELF_CONST, SEL);static bool (*_logos_orig$_ungrouped$YTIPlayabilityStatus$isAgeCheckRequired)(_LOGOS_SELF_TYPE_NORMAL YTIPlayabilityStatus* _LOGOS_SELF_CONST, SEL);static bool (*_logos_orig$_ungrouped$YTIPlayabilityStatus$isPlayable)(_LOGOS_SELF_TYPE_NORMAL YTIPlayabilityStatus* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTIPlayerResponse; static bool (*_logos_orig$_ungrouped$YTIPlayerResponse$isMonetized)(_LOGOS_SELF_TYPE_NORMAL YTIPlayerResponse* _LOGOS_SELF_CONST, SEL);static _Bool (*_logos_orig$_ungrouped$YTIPlayerResponse$adsAllowReuse)(_LOGOS_SELF_TYPE_NORMAL YTIPlayerResponse* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTPromotedVideoCellController; static bool (*_logos_orig$_ungrouped$YTPromotedVideoCellController$shouldShowPromotedItems)(_LOGOS_SELF_TYPE_NORMAL YTPromotedVideoCellController* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTPlayerRequestFactory; static bool (*_logos_orig$_ungrouped$YTPlayerRequestFactory$adultContentConfirmed)(_LOGOS_SELF_TYPE_NORMAL YTPlayerRequestFactory* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTSettings; static bool (*_logos_orig$_ungrouped$YTSettings$enableMDXAutoCasting)(_LOGOS_SELF_TYPE_NORMAL YTSettings* _LOGOS_SELF_CONST, SEL);static void (*_logos_orig$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$)(_LOGOS_SELF_TYPE_NORMAL YTSettings* _LOGOS_SELF_CONST, SEL, BOOL);static BOOL (*_logos_orig$_ungrouped$YTSettings$streamHDOnWiFiOnly)(_LOGOS_SELF_TYPE_NORMAL YTSettings* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTSingleVideoMediaData; static bool (*_logos_orig$_ungrouped$YTSingleVideoMediaData$isPlayableInBackground)(_LOGOS_SELF_TYPE_NORMAL YTSingleVideoMediaData* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTReachability; static BOOL (*_logos_orig$_ungrouped$YTReachability$isOnWiFi)(_LOGOS_SELF_TYPE_NORMAL YTReachability* _LOGOS_SELF_CONST, SEL);static Class _logos_superclass$_ungrouped$YTSettingsViewController; static BOOL (*_logos_orig$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$)(_LOGOS_SELF_TYPE_NORMAL YTSettingsViewController* _LOGOS_SELF_CONST, SEL, BOOL);static Class _logos_superclass$_ungrouped$YTUserDefaults; static BOOL (*_logos_orig$_ungrouped$YTUserDefaults$streamHDOnWiFiOnly)(_LOGOS_SELF_TYPE_NORMAL YTUserDefaults* _LOGOS_SELF_CONST, SEL);

#line 66 "/Users/bandarhelal/Desktop/Tweaks/Hollow/JB/Hollow/Hollow.xm"

static void _logos_method$_ungrouped$YTMainAppControlsOverlayView$didPressAddTo$(_LOGOS_SELF_TYPE_NORMAL YTMainAppControlsOverlayView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
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
 static void _logos_method$_ungrouped$YTMainAppControlsOverlayView$DownloadWithServer(_LOGOS_SELF_TYPE_NORMAL YTMainAppControlsOverlayView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [[NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://kvm.scar-naruto.com/getVideos/Server1.php?id=%@", vID]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (error) {
                NSLog(@"%@", error);
                
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

                    
                    
                    NSArray *image = info[@"image"];
                    if (![image valueForKey:@"max_resolution"]) {
                        if ([image valueForKey:@"high_quality"]) {
                            thumbnailURL = [image valueForKey:@"high_quality"];
                        }
                    } else {
                        thumbnailURL = [image valueForKey:@"max_resolution"];
                    }
                    
                    
                    MDCActionSheetController *Sheet = [MDCActionSheetController actionSheetControllerWithTitle:info[@"title"] message:[[NSString string] localizedStringForKey:@"the_video_supports_these_Qualitys"]];

                    NSArray *URLs = info[@"adaptive_formats"];
                    NSArray *URLs2 = info[@"full_formats"];

                    for (NSDictionary *adaptive_formats in URLs) {
                        NSString *quality = adaptive_formats[@"quality_label"];
                        NSString *Audiotype = adaptive_formats[@"type"];

                        
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



static void _logos_method$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$(_LOGOS_SELF_TYPE_NORMAL YTSlimVideoDetailsActionView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    
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
        (_logos_orig$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$ ? _logos_orig$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$ : (__typeof__(_logos_orig$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$))class_getMethodImplementation(_logos_superclass$_ungrouped$YTSlimVideoDetailsActionView, @selector(didTapButton:)))(self, _cmd, arg1);
    }
}
 static void _logos_method$_ungrouped$YTSlimVideoDetailsActionView$DownloadWithServer(_LOGOS_SELF_TYPE_NORMAL YTSlimVideoDetailsActionView* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    [[NSURLSession.sharedSession dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://kvm.scar-naruto.com/getVideos/Server1.php?id=%@", vID]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

            if (error) {
                NSLog(@"%@", error);
                
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

                    
                    
                    NSArray *image = info[@"image"];
                    if (![image valueForKey:@"max_resolution"]) {
                        if ([image valueForKey:@"high_quality"]) {
                            thumbnailURL = [image valueForKey:@"high_quality"];
                        }
                    } else {
                        thumbnailURL = [image valueForKey:@"max_resolution"];
                    }
                    
                    
                    MDCActionSheetController *Sheet = [MDCActionSheetController actionSheetControllerWithTitle:info[@"title"] message:[[NSString string] localizedStringForKey:@"the_video_supports_these_Qualitys"]];

                    NSArray *URLs = info[@"adaptive_formats"];
                    NSArray *URLs2 = info[@"full_formats"];

                    for (NSDictionary *adaptive_formats in URLs) {
                        NSString *quality = adaptive_formats[@"quality_label"];
                        NSString *Audiotype = adaptive_formats[@"type"];

                        
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




static void _logos_method$_ungrouped$YTPlayerViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    (_logos_orig$_ungrouped$YTPlayerViewController$viewDidLoad ? _logos_orig$_ungrouped$YTPlayerViewController$viewDidLoad : (__typeof__(_logos_orig$_ungrouped$YTPlayerViewController$viewDidLoad))class_getMethodImplementation(_logos_superclass$_ungrouped$YTPlayerViewController, @selector(viewDidLoad)))(self, _cmd);
    
    
    isDownloadingNow = false;
    appWindow = [[[UIApplication sharedApplication] delegate] window];
    DownloadVC = [[DownloadViewController alloc] init];
    DownloadNavigationController = [[UINavigationController alloc] initWithRootViewController:DownloadVC];
    
    
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

static void _logos_method$_ungrouped$YTPlayerViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1) {
    (_logos_orig$_ungrouped$YTPlayerViewController$viewDidAppear$ ? _logos_orig$_ungrouped$YTPlayerViewController$viewDidAppear$ : (__typeof__(_logos_orig$_ungrouped$YTPlayerViewController$viewDidAppear$))class_getMethodImplementation(_logos_superclass$_ungrouped$YTPlayerViewController, @selector(viewDidAppear:)))(self, _cmd, arg1);
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


 static void _logos_method$_ungrouped$YTPlayerViewController$performBlock$afterDelay$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void (^block)(void), NSTimeInterval delay) {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

 static void _logos_method$_ungrouped$YTPlayerViewController$fireBlockAfterDelay$(_LOGOS_SELF_TYPE_NORMAL YTPlayerViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void (^block)(void)) {
    block();
}





static void _logos_method$_ungrouped$YTHeaderContentComboViewController$viewDidLoad(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    (_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidLoad ? _logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidLoad : (__typeof__(_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidLoad))class_getMethodImplementation(_logos_superclass$_ungrouped$YTHeaderContentComboViewController, @selector(viewDidLoad)))(self, _cmd);
    RootVC = [[RootViewController alloc] init];
    RootNavVC = [[UINavigationController alloc] initWithRootViewController:RootVC];
    [RootNavVC.navigationBar setTranslucent:false];
    [RootNavVC.navigationBar setShadowImage:[[UIImage alloc] init]];
    [RootNavVC.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}



 static void _logos_method$_ungrouped$YTHeaderContentComboViewController$performBlock$afterDelay$(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void (^block)(void), NSTimeInterval delay) {
    block = [block copy];
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

 static void _logos_method$_ungrouped$YTHeaderContentComboViewController$fireBlockAfterDelay$(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, void (^block)(void)) {
    block();
}

static void _logos_method$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, _Bool arg1) {
    (_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$ ? _logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$ : (__typeof__(_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$))class_getMethodImplementation(_logos_superclass$_ungrouped$YTHeaderContentComboViewController, @selector(viewDidAppear:)))(self, _cmd, arg1);
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
 static void _logos_method$_ungrouped$YTHeaderContentComboViewController$openDownloadLibrary(_LOGOS_SELF_TYPE_NORMAL YTHeaderContentComboViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    
    [self presentViewController:RootNavVC animated:true completion:nil];
}






static _Bool _logos_method$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$(_LOGOS_SELF_TYPE_NORMAL YTAppDelegate* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, UIApplication * application, id arg2) {
    (_logos_orig$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$ ? _logos_orig$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$ : (__typeof__(_logos_orig$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$))class_getMethodImplementation(_logos_superclass$_ungrouped$YTAppDelegate, @selector(application:didFinishLaunchingWithOptions:)))(self, _cmd, application, arg2);
    [FCFileManager removeItemAtPath:@"AUDIOCONVERTED.m4a"];
    [FCFileManager removeItemAtPath:@"FILETRIMED.mp4"];
    [FCFileManager removeItemAtPath:@"videoplayback.mp4"];
    [FCFileManager removeItemAtPath:@"videoplayback.m4a"];
    [FCFileManager removeItemAtPath:@"videoplayback.txt"];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        
        [FCFileManager createDirectoriesForPath:@"BH"];
        [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"sort"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return true;
}



static _Bool _logos_method$_ungrouped$YTSingleVideoController$isCurrentlyBackgroundable(_LOGOS_SELF_TYPE_NORMAL YTSingleVideoController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}



static _Bool _logos_method$_ungrouped$YTVASTAd$isSkippable(_LOGOS_SELF_TYPE_NORMAL YTVASTAd* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}

static _Bool _logos_method$_ungrouped$YTVASTAd$_skippable(_LOGOS_SELF_TYPE_NORMAL YTVASTAd* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}

static bool _logos_method$_ungrouped$YTVASTAd$isForecastingAd(_LOGOS_SELF_TYPE_NORMAL YTVASTAd* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return NO;
}





static _Bool _logos_method$_ungrouped$YTVideoQualitySwitchController$canSelectFormat$(_LOGOS_SELF_TYPE_NORMAL YTVideoQualitySwitchController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, id arg1) {
    return YES;
}

static _Bool _logos_method$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchAvailable(_LOGOS_SELF_TYPE_NORMAL YTVideoQualitySwitchController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}
static _Bool _logos_method$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchEnabled(_LOGOS_SELF_TYPE_NORMAL YTVideoQualitySwitchController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return YES;
}




static bool _logos_method$_ungrouped$YTIPlayabilityStatus$isPlayableInBackground(_LOGOS_SELF_TYPE_NORMAL YTIPlayabilityStatus* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return true;
}



static bool _logos_method$_ungrouped$YTIPlayerResponse$isMonetized(_LOGOS_SELF_TYPE_NORMAL YTIPlayerResponse* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return false;
}
static _Bool _logos_method$_ungrouped$YTIPlayerResponse$adsAllowReuse(_LOGOS_SELF_TYPE_NORMAL YTIPlayerResponse* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return NO;
}



static bool _logos_method$_ungrouped$YTPromotedVideoCellController$shouldShowPromotedItems(_LOGOS_SELF_TYPE_NORMAL YTPromotedVideoCellController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return false;
}



static bool _logos_method$_ungrouped$YTIPlayabilityStatus$isAgeCheckRequired(_LOGOS_SELF_TYPE_NORMAL YTIPlayabilityStatus* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return false;
}



static bool _logos_method$_ungrouped$YTIPlayabilityStatus$isPlayable(_LOGOS_SELF_TYPE_NORMAL YTIPlayabilityStatus* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return true;
}



static bool _logos_method$_ungrouped$YTPlayerRequestFactory$adultContentConfirmed(_LOGOS_SELF_TYPE_NORMAL YTPlayerRequestFactory* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return true;
}



static bool _logos_method$_ungrouped$YTSettings$enableMDXAutoCasting(_LOGOS_SELF_TYPE_NORMAL YTSettings* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return false;
}



static bool _logos_method$_ungrouped$YTSingleVideoMediaData$isPlayableInBackground(_LOGOS_SELF_TYPE_NORMAL YTSingleVideoMediaData* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return true;
}



static BOOL _logos_method$_ungrouped$YTReachability$isOnWiFi(_LOGOS_SELF_TYPE_NORMAL YTReachability* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return true;
}



static void _logos_method$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$(_LOGOS_SELF_TYPE_NORMAL YTSettings* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
    arg1 = false;
    (_logos_orig$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$ ? _logos_orig$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$ : (__typeof__(_logos_orig$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$))class_getMethodImplementation(_logos_superclass$_ungrouped$YTSettings, @selector(setStreamHDOnWiFiOnly:)))(self, _cmd, arg1);
}



static BOOL _logos_method$_ungrouped$YTSettings$streamHDOnWiFiOnly(_LOGOS_SELF_TYPE_NORMAL YTSettings* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return false;
}



static BOOL _logos_method$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$(_LOGOS_SELF_TYPE_NORMAL YTSettingsViewController* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, BOOL arg1) {
    arg1 = false;
    return false;
    return (_logos_orig$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$ ? _logos_orig$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$ : (__typeof__(_logos_orig$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$))class_getMethodImplementation(_logos_superclass$_ungrouped$YTSettingsViewController, @selector(onStreamHDOnWiFiOnly:)))(self, _cmd, arg1);
}



static BOOL _logos_method$_ungrouped$YTUserDefaults$streamHDOnWiFiOnly(_LOGOS_SELF_TYPE_NORMAL YTUserDefaults* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd) {
    return false;
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$YTMainAppControlsOverlayView = objc_getClass("YTMainAppControlsOverlayView"); _logos_superclass$_ungrouped$YTMainAppControlsOverlayView = class_getSuperclass(_logos_class$_ungrouped$YTMainAppControlsOverlayView); { _logos_register_hook$(_logos_class$_ungrouped$YTMainAppControlsOverlayView, @selector(didPressAddTo:), (IMP)&_logos_method$_ungrouped$YTMainAppControlsOverlayView$didPressAddTo$, (IMP *)&_logos_orig$_ungrouped$YTMainAppControlsOverlayView$didPressAddTo$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTMainAppControlsOverlayView, @selector(DownloadWithServer), (IMP)&_logos_method$_ungrouped$YTMainAppControlsOverlayView$DownloadWithServer, _typeEncoding); }Class _logos_class$_ungrouped$YTSlimVideoDetailsActionView = objc_getClass("YTSlimVideoDetailsActionView"); _logos_superclass$_ungrouped$YTSlimVideoDetailsActionView = class_getSuperclass(_logos_class$_ungrouped$YTSlimVideoDetailsActionView); { _logos_register_hook$(_logos_class$_ungrouped$YTSlimVideoDetailsActionView, @selector(didTapButton:), (IMP)&_logos_method$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$, (IMP *)&_logos_orig$_ungrouped$YTSlimVideoDetailsActionView$didTapButton$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTSlimVideoDetailsActionView, @selector(DownloadWithServer), (IMP)&_logos_method$_ungrouped$YTSlimVideoDetailsActionView$DownloadWithServer, _typeEncoding); }Class _logos_class$_ungrouped$YTPlayerViewController = objc_getClass("YTPlayerViewController"); _logos_superclass$_ungrouped$YTPlayerViewController = class_getSuperclass(_logos_class$_ungrouped$YTPlayerViewController); { _logos_register_hook$(_logos_class$_ungrouped$YTPlayerViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$viewDidLoad, (IMP *)&_logos_orig$_ungrouped$YTPlayerViewController$viewDidLoad);}{ _logos_register_hook$(_logos_class$_ungrouped$YTPlayerViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$viewDidAppear$, (IMP *)&_logos_orig$_ungrouped$YTPlayerViewController$viewDidAppear$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(void (^)(void)), strlen(@encode(void (^)(void)))); i += strlen(@encode(void (^)(void))); memcpy(_typeEncoding + i, @encode(NSTimeInterval), strlen(@encode(NSTimeInterval))); i += strlen(@encode(NSTimeInterval)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTPlayerViewController, @selector(performBlock:afterDelay:), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$performBlock$afterDelay$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(void (^)(void)), strlen(@encode(void (^)(void)))); i += strlen(@encode(void (^)(void))); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTPlayerViewController, @selector(fireBlockAfterDelay:), (IMP)&_logos_method$_ungrouped$YTPlayerViewController$fireBlockAfterDelay$, _typeEncoding); }Class _logos_class$_ungrouped$YTHeaderContentComboViewController = objc_getClass("YTHeaderContentComboViewController"); _logos_superclass$_ungrouped$YTHeaderContentComboViewController = class_getSuperclass(_logos_class$_ungrouped$YTHeaderContentComboViewController); { _logos_register_hook$(_logos_class$_ungrouped$YTHeaderContentComboViewController, @selector(viewDidLoad), (IMP)&_logos_method$_ungrouped$YTHeaderContentComboViewController$viewDidLoad, (IMP *)&_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidLoad);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(void (^)(void)), strlen(@encode(void (^)(void)))); i += strlen(@encode(void (^)(void))); memcpy(_typeEncoding + i, @encode(NSTimeInterval), strlen(@encode(NSTimeInterval))); i += strlen(@encode(NSTimeInterval)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTHeaderContentComboViewController, @selector(performBlock:afterDelay:), (IMP)&_logos_method$_ungrouped$YTHeaderContentComboViewController$performBlock$afterDelay$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(void (^)(void)), strlen(@encode(void (^)(void)))); i += strlen(@encode(void (^)(void))); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTHeaderContentComboViewController, @selector(fireBlockAfterDelay:), (IMP)&_logos_method$_ungrouped$YTHeaderContentComboViewController$fireBlockAfterDelay$, _typeEncoding); }{ _logos_register_hook$(_logos_class$_ungrouped$YTHeaderContentComboViewController, @selector(viewDidAppear:), (IMP)&_logos_method$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$, (IMP *)&_logos_orig$_ungrouped$YTHeaderContentComboViewController$viewDidAppear$);}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$YTHeaderContentComboViewController, @selector(openDownloadLibrary), (IMP)&_logos_method$_ungrouped$YTHeaderContentComboViewController$openDownloadLibrary, _typeEncoding); }Class _logos_class$_ungrouped$YTAppDelegate = objc_getClass("YTAppDelegate"); _logos_superclass$_ungrouped$YTAppDelegate = class_getSuperclass(_logos_class$_ungrouped$YTAppDelegate); { _logos_register_hook$(_logos_class$_ungrouped$YTAppDelegate, @selector(application:didFinishLaunchingWithOptions:), (IMP)&_logos_method$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$, (IMP *)&_logos_orig$_ungrouped$YTAppDelegate$application$didFinishLaunchingWithOptions$);}Class _logos_class$_ungrouped$YTSingleVideoController = objc_getClass("YTSingleVideoController"); _logos_superclass$_ungrouped$YTSingleVideoController = class_getSuperclass(_logos_class$_ungrouped$YTSingleVideoController); { _logos_register_hook$(_logos_class$_ungrouped$YTSingleVideoController, @selector(isCurrentlyBackgroundable), (IMP)&_logos_method$_ungrouped$YTSingleVideoController$isCurrentlyBackgroundable, (IMP *)&_logos_orig$_ungrouped$YTSingleVideoController$isCurrentlyBackgroundable);}Class _logos_class$_ungrouped$YTVASTAd = objc_getClass("YTVASTAd"); _logos_superclass$_ungrouped$YTVASTAd = class_getSuperclass(_logos_class$_ungrouped$YTVASTAd); { _logos_register_hook$(_logos_class$_ungrouped$YTVASTAd, @selector(isSkippable), (IMP)&_logos_method$_ungrouped$YTVASTAd$isSkippable, (IMP *)&_logos_orig$_ungrouped$YTVASTAd$isSkippable);}{ _logos_register_hook$(_logos_class$_ungrouped$YTVASTAd, @selector(_skippable), (IMP)&_logos_method$_ungrouped$YTVASTAd$_skippable, (IMP *)&_logos_orig$_ungrouped$YTVASTAd$_skippable);}{ _logos_register_hook$(_logos_class$_ungrouped$YTVASTAd, @selector(isForecastingAd), (IMP)&_logos_method$_ungrouped$YTVASTAd$isForecastingAd, (IMP *)&_logos_orig$_ungrouped$YTVASTAd$isForecastingAd);}Class _logos_class$_ungrouped$YTVideoQualitySwitchController = objc_getClass("YTVideoQualitySwitchController"); _logos_superclass$_ungrouped$YTVideoQualitySwitchController = class_getSuperclass(_logos_class$_ungrouped$YTVideoQualitySwitchController); { _logos_register_hook$(_logos_class$_ungrouped$YTVideoQualitySwitchController, @selector(canSelectFormat:), (IMP)&_logos_method$_ungrouped$YTVideoQualitySwitchController$canSelectFormat$, (IMP *)&_logos_orig$_ungrouped$YTVideoQualitySwitchController$canSelectFormat$);}{ _logos_register_hook$(_logos_class$_ungrouped$YTVideoQualitySwitchController, @selector(_qualitySwitchAvailable), (IMP)&_logos_method$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchAvailable, (IMP *)&_logos_orig$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchAvailable);}{ _logos_register_hook$(_logos_class$_ungrouped$YTVideoQualitySwitchController, @selector(_qualitySwitchEnabled), (IMP)&_logos_method$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchEnabled, (IMP *)&_logos_orig$_ungrouped$YTVideoQualitySwitchController$_qualitySwitchEnabled);}Class _logos_class$_ungrouped$YTIPlayabilityStatus = objc_getClass("YTIPlayabilityStatus"); _logos_superclass$_ungrouped$YTIPlayabilityStatus = class_getSuperclass(_logos_class$_ungrouped$YTIPlayabilityStatus); { _logos_register_hook$(_logos_class$_ungrouped$YTIPlayabilityStatus, @selector(isPlayableInBackground), (IMP)&_logos_method$_ungrouped$YTIPlayabilityStatus$isPlayableInBackground, (IMP *)&_logos_orig$_ungrouped$YTIPlayabilityStatus$isPlayableInBackground);}{ _logos_register_hook$(_logos_class$_ungrouped$YTIPlayabilityStatus, @selector(isAgeCheckRequired), (IMP)&_logos_method$_ungrouped$YTIPlayabilityStatus$isAgeCheckRequired, (IMP *)&_logos_orig$_ungrouped$YTIPlayabilityStatus$isAgeCheckRequired);}{ _logos_register_hook$(_logos_class$_ungrouped$YTIPlayabilityStatus, @selector(isPlayable), (IMP)&_logos_method$_ungrouped$YTIPlayabilityStatus$isPlayable, (IMP *)&_logos_orig$_ungrouped$YTIPlayabilityStatus$isPlayable);}Class _logos_class$_ungrouped$YTIPlayerResponse = objc_getClass("YTIPlayerResponse"); _logos_superclass$_ungrouped$YTIPlayerResponse = class_getSuperclass(_logos_class$_ungrouped$YTIPlayerResponse); { _logos_register_hook$(_logos_class$_ungrouped$YTIPlayerResponse, @selector(isMonetized), (IMP)&_logos_method$_ungrouped$YTIPlayerResponse$isMonetized, (IMP *)&_logos_orig$_ungrouped$YTIPlayerResponse$isMonetized);}{ _logos_register_hook$(_logos_class$_ungrouped$YTIPlayerResponse, @selector(adsAllowReuse), (IMP)&_logos_method$_ungrouped$YTIPlayerResponse$adsAllowReuse, (IMP *)&_logos_orig$_ungrouped$YTIPlayerResponse$adsAllowReuse);}Class _logos_class$_ungrouped$YTPromotedVideoCellController = objc_getClass("YTPromotedVideoCellController"); _logos_superclass$_ungrouped$YTPromotedVideoCellController = class_getSuperclass(_logos_class$_ungrouped$YTPromotedVideoCellController); { _logos_register_hook$(_logos_class$_ungrouped$YTPromotedVideoCellController, @selector(shouldShowPromotedItems), (IMP)&_logos_method$_ungrouped$YTPromotedVideoCellController$shouldShowPromotedItems, (IMP *)&_logos_orig$_ungrouped$YTPromotedVideoCellController$shouldShowPromotedItems);}Class _logos_class$_ungrouped$YTPlayerRequestFactory = objc_getClass("YTPlayerRequestFactory"); _logos_superclass$_ungrouped$YTPlayerRequestFactory = class_getSuperclass(_logos_class$_ungrouped$YTPlayerRequestFactory); { _logos_register_hook$(_logos_class$_ungrouped$YTPlayerRequestFactory, @selector(adultContentConfirmed), (IMP)&_logos_method$_ungrouped$YTPlayerRequestFactory$adultContentConfirmed, (IMP *)&_logos_orig$_ungrouped$YTPlayerRequestFactory$adultContentConfirmed);}Class _logos_class$_ungrouped$YTSettings = objc_getClass("YTSettings"); _logos_superclass$_ungrouped$YTSettings = class_getSuperclass(_logos_class$_ungrouped$YTSettings); { _logos_register_hook$(_logos_class$_ungrouped$YTSettings, @selector(enableMDXAutoCasting), (IMP)&_logos_method$_ungrouped$YTSettings$enableMDXAutoCasting, (IMP *)&_logos_orig$_ungrouped$YTSettings$enableMDXAutoCasting);}{ _logos_register_hook$(_logos_class$_ungrouped$YTSettings, @selector(setStreamHDOnWiFiOnly:), (IMP)&_logos_method$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$, (IMP *)&_logos_orig$_ungrouped$YTSettings$setStreamHDOnWiFiOnly$);}{ _logos_register_hook$(_logos_class$_ungrouped$YTSettings, @selector(streamHDOnWiFiOnly), (IMP)&_logos_method$_ungrouped$YTSettings$streamHDOnWiFiOnly, (IMP *)&_logos_orig$_ungrouped$YTSettings$streamHDOnWiFiOnly);}Class _logos_class$_ungrouped$YTSingleVideoMediaData = objc_getClass("YTSingleVideoMediaData"); _logos_superclass$_ungrouped$YTSingleVideoMediaData = class_getSuperclass(_logos_class$_ungrouped$YTSingleVideoMediaData); { _logos_register_hook$(_logos_class$_ungrouped$YTSingleVideoMediaData, @selector(isPlayableInBackground), (IMP)&_logos_method$_ungrouped$YTSingleVideoMediaData$isPlayableInBackground, (IMP *)&_logos_orig$_ungrouped$YTSingleVideoMediaData$isPlayableInBackground);}Class _logos_class$_ungrouped$YTReachability = objc_getClass("YTReachability"); _logos_superclass$_ungrouped$YTReachability = class_getSuperclass(_logos_class$_ungrouped$YTReachability); { _logos_register_hook$(_logos_class$_ungrouped$YTReachability, @selector(isOnWiFi), (IMP)&_logos_method$_ungrouped$YTReachability$isOnWiFi, (IMP *)&_logos_orig$_ungrouped$YTReachability$isOnWiFi);}Class _logos_class$_ungrouped$YTSettingsViewController = objc_getClass("YTSettingsViewController"); _logos_superclass$_ungrouped$YTSettingsViewController = class_getSuperclass(_logos_class$_ungrouped$YTSettingsViewController); { _logos_register_hook$(_logos_class$_ungrouped$YTSettingsViewController, @selector(onStreamHDOnWiFiOnly:), (IMP)&_logos_method$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$, (IMP *)&_logos_orig$_ungrouped$YTSettingsViewController$onStreamHDOnWiFiOnly$);}Class _logos_class$_ungrouped$YTUserDefaults = objc_getClass("YTUserDefaults"); _logos_superclass$_ungrouped$YTUserDefaults = class_getSuperclass(_logos_class$_ungrouped$YTUserDefaults); { _logos_register_hook$(_logos_class$_ungrouped$YTUserDefaults, @selector(streamHDOnWiFiOnly), (IMP)&_logos_method$_ungrouped$YTUserDefaults$streamHDOnWiFiOnly, (IMP *)&_logos_orig$_ungrouped$YTUserDefaults$streamHDOnWiFiOnly);}} }
#line 931 "/Users/bandarhelal/Desktop/Tweaks/Hollow/JB/Hollow/Hollow.xm"
