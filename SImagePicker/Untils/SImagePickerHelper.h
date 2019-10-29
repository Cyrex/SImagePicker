//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerHelper.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/6/20: Created by Cyrex on 2019/6/20
//      2019/11/29: Add methods for caching image.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SAuthorizationCompletion)(PHAuthorizationStatus status);
typedef void (^SImageRequestCompletion)(UIImage *__nullable image);
typedef void (^SVideoRequestCompletion)(NSURL *__nullable avURL, CGFloat duration);
typedef void (^SLivePhotoRequestCompletion)(PHLivePhoto *__nullable livePhoto) API_AVAILABLE(ios(9.1));

@interface SImagePickerHelper : NSObject

+ (SImagePickerHelper *)sharedHelper;

- (void)requestAuthorization:(_Nullable SAuthorizationCompletion)completion;

- (NSArray<PHAssetCollection *> *)fetchAllCollection;

- (NSArray<PHAsset *> *)fetchAllAsset;

- (NSArray<PHAsset *>*)fetchAssetForCollection:(PHAssetCollection *)collection;

@end


#pragma mark -
#pragma mark - Image
@interface SImagePickerHelper (Image)

- (void)requestThumbnailForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize isHighQuality:(BOOL)isHighQuality completion:(SImageRequestCompletion)completion;

- (void)requestImageForAsset:(PHAsset *)asset completion:(SImageRequestCompletion)completion;

@end


#pragma mark -
#pragma mark - Video
@interface SImagePickerHelper (Video)

- (void)requestVideoForAsset:(PHAsset *)asset completion:(SVideoRequestCompletion)completion;

@end


#pragma mark -
#pragma mark - LivePhoto
@interface SImagePickerHelper (LivePhoto)

- (void)requestLivePhotoForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(SLivePhotoRequestCompletion)completion API_AVAILABLE(ios(9.1));

@end


#pragma mark -
#pragma mark - Caching
@interface SImagePickerHelper (Caching)

- (void)startCachingImagesForAssets:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize;

- (void)stopCachingImagesForAssets:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize;

- (void)stopCachingImagesForAllAssets;

@end

NS_ASSUME_NONNULL_END
