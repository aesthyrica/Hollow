//
//  DownloadedCell+Video.h
//  ColorPickerTest
//
//  Created by BandarHelal on 06/06/2019.
//  Copyright © 2019 BandarHelal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Colours.h"
#import "MDCButton.h"
#import "MDCSlider.h"
#import "NSData+BH.h"

@interface DownloadedCell : UITableViewCell
@property (nonatomic, strong) UIView *CNView;
@property (nonatomic, strong) UIImageView *VideoImage;
@property (nonatomic, strong) UILabel *VideoTitle;
@property (nonatomic, strong) MDCButton *PlayButton;
@property (nonatomic, strong) UIView *MaskView;
@property (nonatomic, strong) MDCButton *MoreButton;
@property (nonatomic, strong) UIView *TimeView;
@property (nonatomic, strong) UIImageView *TypeImage;
@property (nonatomic, strong) UILabel *TimeLabel;
@property (nonatomic, strong) UILabel *TimeLabelOfTimeLine;
@property (nonatomic, strong) UILabel *TimeLineLabel;
@property (nonatomic, strong) MDCSlider *TimeLine;
@end

@implementation NSString (localized)
//@dynamic bundle;

//- (NSString *)RessourcesPrefsresourcesBundlePath {
//    return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"/Library/Application Support/BH/Ressources.bundle"];;
//}

- (NSBundle *)ResourcesBundle {
    return [NSBundle bundleWithPath:@"/Library/Application Support/BH/Ressources.bundle"];
}

- (NSString *)ResourcesBundle2 {
    return @"/Library/Application Support/BH/Ressources.bundle";
}

- (NSString *)localizedStringForKey:(NSString *)key {
    static NSBundle *fallbackBundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *language = [[NSLocale preferredLanguages] firstObject];
        if ([language containsString:@"en"]) {
            fallbackBundle = [NSBundle bundleWithPath:[[self ResourcesBundle2] stringByAppendingPathComponent:@"en.lproj"]];
        }
        
        if ([language containsString:@"ar"]) {
            fallbackBundle = [NSBundle bundleWithPath:[[self ResourcesBundle2] stringByAppendingPathComponent:@"ar.lproj"]];
        }
        
        if ([language containsString:@"fr"]) {
            fallbackBundle = [NSBundle bundleWithPath:[[self ResourcesBundle2] stringByAppendingPathComponent:@"fr.lproj"]];
        }
        
    });
    NSString *localString = [[self ResourcesBundle] localizedStringForKey:key value:key table:nil];
    
    if (!localString || [localString isEqualToString:key] || localString.length < 1) {
        localString = [fallbackBundle localizedStringForKey:key value:key table:nil];
    }
    return localString ? : key;
}

@end

@implementation NSMutableArray (Reverse)

- (void)reverse {
    if ([self count] <= 1)
        return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
}

- (void)removeDupArray {
    for (id obj in self) {
        if (![self containsObject:obj]) {
            [self addObject:obj];
        }
    }
}

@end

