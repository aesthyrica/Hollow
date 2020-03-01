//
//  DownloadCell.h
//  objTests
//
//  Created by BandarHelal on 13/04/1441 AH.
//  Copyright © 1441 BandarHelal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Colours.h"


@interface DownloadCell : UITableViewCell
@property (nonatomic, strong) UIImageView *VideoImage;
@property (nonatomic, strong) UILabel *VideoTitle;
@property (nonatomic, strong) UILabel *DownloadedPersent;
@property (nonatomic, strong) UILabel *DownloadStatus;
@end
