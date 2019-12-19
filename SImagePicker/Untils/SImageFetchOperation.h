//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImageFetchOperation.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/12/19: Created by Cyrex on 2019/12/19
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PHAsset;
@class PHCachingImageManager;

typedef void (^SImageOperationFetchCompletion)(UIImage *__nullable image);

@interface SImageFetchOperation : NSOperation

- (instancetype)initWithAsset:(PHAsset *)asset cacheManager:(PHCachingImageManager *)cacheManager;

- (void)requesImageWithSize:(CGSize)size
            needHighQuality:(BOOL)isHighQuality
                 completion:(SImageOperationFetchCompletion)completion;

@end

NS_ASSUME_NONNULL_END
