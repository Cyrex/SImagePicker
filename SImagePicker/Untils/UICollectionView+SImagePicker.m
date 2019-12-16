//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: UICollectionView+SImagePicker.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/12/16: Created by Cyrex on 2019/12/16
//

#import "UICollectionView+SImagePicker.h"

@implementation UICollectionView (SImagePicker)
- (NSArray *)s_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionViewLayout layoutAttributesForElementsInRect:rect];

    if (allLayoutAttributes.count == 0) {
        return nil;
    }

    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }

    return indexPaths;
}

@end
