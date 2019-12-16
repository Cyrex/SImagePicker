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

@interface SAssetCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SAssetCell
#pragma mark - Class Methods
+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}


#pragma mark - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentView addSubview:self.imageView];
}


#pragma mark - Getters
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
