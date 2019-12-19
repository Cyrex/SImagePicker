//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SAssetCell.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/10/29: Created by Cyrex on 2019/10/29
//

#import <UIKit/UIKit.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface SAssetCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

+ (NSString *)reuseIdentifier;

- (void)fillWithAsset:(PHAsset *)asset;

@end

NS_ASSUME_NONNULL_END
