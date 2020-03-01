//
//  DownloadCell.m
//  objTests
//
//  Created by BandarHelal on 13/04/1441 AH.
//  Copyright © 1441 BandarHelal. All rights reserved.
//

#import "DownloadCell.h"

@implementation DownloadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor colorFromHexString:@"212121"]];
        [self MakeUI];
    }
    return self;
}

- (void)MakeUI {
    
    // setup image
    self.VideoImage = UIImageView.new;
    [self.VideoImage setBackgroundColor:UIColor.clearColor];
    [self.VideoImage setTranslatesAutoresizingMaskIntoConstraints:false];
    [self addSubview:self.VideoImage];
    
    // image constraint
    [self.VideoImage.topAnchor constraintEqualToAnchor:self.topAnchor].active = true;
    [self.VideoImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = true;
    [self.VideoImage.widthAnchor constraintEqualToConstant:44].active = true;
    [self.VideoImage.heightAnchor constraintEqualToConstant:41].active = true;
    
    
    // setup video label
    self.VideoTitle = UILabel.new;
    self.VideoTitle.textColor = UIColor.whiteColor;
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft) {
        self.VideoTitle.textAlignment = NSTextAlignmentRight;
    }
    if ([UIApplication sharedApplication].userInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionLeftToRight) {
        self.VideoTitle.textAlignment = NSTextAlignmentLeft;
    }
    self.VideoTitle.numberOfLines = 0;
    [self.VideoTitle setTranslatesAutoresizingMaskIntoConstraints:false];
    [self addSubview:self.VideoTitle];
    
    // video label constraint
    [self.VideoTitle.topAnchor constraintEqualToAnchor:self.VideoImage.topAnchor constant:4].active = true;
    [self.VideoTitle.leadingAnchor constraintEqualToAnchor:self.VideoImage.trailingAnchor constant:8].active = true;
    [self.VideoTitle.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-46].active = true;
    [self.VideoTitle.heightAnchor constraintEqualToConstant:20].active = true;
    
    
    // setup Downloaded Persent label
    self.DownloadedPersent = UILabel.new;
    self.DownloadedPersent.textColor = UIColor.whiteColor;
    self.DownloadedPersent.textAlignment = NSTextAlignmentRight;
    self.DownloadedPersent.numberOfLines = 0;
    [self.DownloadedPersent setTranslatesAutoresizingMaskIntoConstraints:false];
    [self addSubview:self.DownloadedPersent];
    
    
    // Downloaded Persent label constraint
    [self.DownloadedPersent.topAnchor constraintEqualToAnchor:self.topAnchor constant:10].active = true;
    [self.DownloadedPersent.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20].active = true;
    
    
    // setup Download Status label
    self.DownloadStatus = UILabel.new;
    self.DownloadStatus.textColor = UIColor.whiteColor;
    self.DownloadStatus.textAlignment = NSTextAlignmentLeft;
    self.DownloadStatus.numberOfLines = 0;
    [self.DownloadStatus setFont:[UIFont systemFontOfSize:10]];
    [self.DownloadStatus setTranslatesAutoresizingMaskIntoConstraints:false];
    [self addSubview:self.DownloadStatus];
    
    // Download Status constraint
    [self.DownloadStatus.leadingAnchor constraintEqualToAnchor:self.VideoImage.trailingAnchor constant:8].active = true;
    [self.DownloadStatus.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-5.5].active = true;
}

@end
