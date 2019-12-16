//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: UICollectionView+SImagePicker.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/12/16: Created by Cyrex on 2019/12/16
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (SImagePicker)

- (NSArray *)s_indexPathsForElementsInRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
