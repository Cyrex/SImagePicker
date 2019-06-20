//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerUntils.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/6/20: Created by Cyrex on 2019/6/20
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface SImagePickerUntils : NSObject

+ (void)requestAuthorization:(void(^ __nullable)(PHAuthorizationStatus status))handler;
+ (NSArray<PHAssetCollection *> *)fetchAllCollection;
+ (NSArray<PHAsset *> *)fetchAllAsset;
+ (NSArray<PHAsset *>*)fetchAssetForCollection:(PHAssetCollection *)collection;

@end


#pragma mark -
#pragma mark - Image
@interface SImagePickerUntils (Image)

+ (void)requestThumbnailForAsset:(PHAsset *)asset
                         quality:(BOOL)quality
                         handler:(void (^)(UIImage *__nullable thumbnail))handler;

+ (void)requestImageForAsset:(PHAsset *)asset
                     handler:(void (^)(UIImage *__nullable image))handler;

@end


#pragma mark -
#pragma mark - Video
@interface SImagePickerUntils (Video)

+ (void)requestVideoForAsset:(PHAsset *)asset
                     handler:(void (^)(NSURL *__nullable avURL, CGFloat duration))handler;

@end


#pragma mark -
#pragma mark - LivePhoto
API_AVAILABLE_BEGIN(ios(9.1))
@interface SImagePickerUntils (LivePhoto)

+ (void)requestLivePhotoForAsset:(PHAsset *)asset
                            size:(CGSize)size
                         handler:(void (^)(PHLivePhoto *__nullable livePhoto))handler;

@end
API_AVAILABLE_END

NS_ASSUME_NONNULL_END
