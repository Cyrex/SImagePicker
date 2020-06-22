//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SAssetCell.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/10/29: Created by Cyrex on 2019/10/29
//

#import "SAssetCell.h"

#import "SImagePickerHelper.h"
#import <Photos/PHAsset.h>

@interface SAssetCell ()

@property (nonatomic, strong, nonnull) PHAsset *asset;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SAssetCell
// MARK: - Class Methods
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}


// MARK: - Public Methods
- (void)fillWithAsset:(PHAsset *)asset {
    if (self.asset) {
        [SImagePickerHelper.sharedHelper cancelFetchWithAsset:self.asset];
    }
    self.asset = asset;
        
    //    if (self.asset.cacheImage) {
    //        self.imageView.image = self.asset.cacheImage;
    //        return;
//    //    }
//    [SImagePickerHelper.sharedHelper requestThumbnailForAsset:self.asset targetSize:CGSizeMake(200, 200) isHighQuality:YES completion:^(UIImage * _Nullable image) {
////        if ([self.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
//            self.imageView.image = image;
////        }
//    }];
}


// MARK: - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.imageView];
}


// MARK: - Getters
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.image = self.image;
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageView;
}

@end
