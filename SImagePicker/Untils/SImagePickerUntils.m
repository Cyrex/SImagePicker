//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerUntils.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/6/20: Created by Cyrex on 2019/6/20
//

#import "SImagePickerUntils.h"

@implementation SImagePickerUntils
#pragma mark - Class Methods
+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    if (PHAuthorizationStatusNotDetermined == status) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                if (handler) {
                    handler(status);
                }
            });
        }];
    } else {
        if (handler) {
            handler(status);
        }
    }
}

+ (NSArray <PHAssetCollection *> *)fetchAllCollection {
    NSMutableArray<PHAssetCollection *> *collectionList = [NSMutableArray array];
    PHFetchResult *smartAlbums = nil;

    smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                           subtype:PHAssetCollectionSubtypeAlbumRegular
                                                           options:nil];
    if (smartAlbums.count > 0) {
        [smartAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (assets.count > 0) {
                [collectionList addObject:collection];
            }
        }];
    }

    PHFetchResult *topCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    if (topCollections.count > 0) {
        [topCollections enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection  options:nil];
            if (assets.count > 0) {
                [collectionList addObject:collection];
            }
        }];
    }

    return collectionList;
}

+ (NSArray <PHAsset *> *)fetchAllAsset {
    NSMutableArray<PHAsset *> *AllAssets = [NSMutableArray array];

    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                              ascending:NO]];
    PHFetchResult *assets = [PHAsset fetchAssetsWithOptions:options];
    if (assets.count > 0) {
        for (PHAsset *asset in assets) {
            [AllAssets addObject:asset];
        }
    }

    return AllAssets;
}

+ (NSArray <PHAsset *>*)fetchAssetForCollection:(PHAssetCollection *)collection {
    NSMutableArray <PHAsset *> *albumAssets = [NSMutableArray array];

    if ([collection isKindOfClass:[PHAssetCollection class]]) {
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                  ascending:NO]];
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
        if (assets.count > 0) {
            for (PHAsset *asset in assets) {
                [albumAssets addObject:asset];
            }
        }
    }

    return albumAssets;
}

@end


#pragma mark -
#pragma mark - Image
@implementation SImagePickerUntils (Image)
#pragma mark - Class Methods
+ (void)requestThumbnailForAsset:(PHAsset *)asset isHighQuality:(BOOL)isHighQuality handler:(void (^)(UIImage *))handler {
    CGSize size = isHighQuality ? CGSizeMake(200.f, 200.f) : CGSizeMake(40.f, 40.f);

    PHImageContentMode contentMode = PHImageContentModeAspectFill;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    if (isHighQuality) {
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    } else {
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
    requestOptions.networkAccessAllowed = YES;
    requestOptions.synchronous = YES;

    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:contentMode
                                                  options:requestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (handler) {
                                                    handler(result);
                                                }
                                            }];
}

+ (void)requestImageForAsset:(PHAsset *)asset handler:(void (^)(UIImage *))handler {
    CGSize size;
    switch ((NSInteger)[UIScreen mainScreen].bounds.size.width) {
        case 320:
            size = CGSizeMake(320.f, 568.f);
        case 375:
            size = CGSizeMake(375.f, 667.f);
        case 414:
            size =  CGSizeMake(414.f, 736.f);
        case 768:
        default:
            size =  CGSizeMake(768.f, 1024.f);
    }

    PHImageContentMode contentMode = PHImageContentModeAspectFit;
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    [requestOptions setResizeMode:PHImageRequestOptionsResizeModeExact];
    [requestOptions setNetworkAccessAllowed:YES];
    [requestOptions setSynchronous:YES];

    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:contentMode
                                                  options:requestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (handler) {
                                                    handler(result);
                                                }
                                            }];
}

@end



#pragma mark -
#pragma mark - Video
@implementation SImagePickerUntils (Video)
#pragma mark - Class Methods
+ (void)requestVideoForAsset:(PHAsset *)asset handler:(void (^)(NSURL *, CGFloat))handler {
    PHVideoRequestOptions *requestOptions = [[PHVideoRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    requestOptions.version = PHVideoRequestOptionsVersionOriginal;

    [[PHImageManager defaultManager] requestAVAssetForVideo:asset
                                                    options:requestOptions
                                              resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                                                  if (handler) {
                                                      if (asset && [asset isKindOfClass:[AVURLAsset class]]) {
                                                          AVURLAsset *avAsset = (AVURLAsset *)asset;
                                                          CMTime time = avAsset.duration;
                                                          CGFloat duration = time.value / time.timescale;
                                                          handler(avAsset.URL, duration);
                                                      } else {
                                                          handler(nil, 0.f);
                                                      }
                                                  }
                                              }];
}

@end


#pragma mark -
#pragma mark - LivePhoto
@implementation SImagePickerUntils (LivePhoto)
#pragma mark - Class Methods
+ (void)requestLivePhotoForAsset:(PHAsset *)asset size:(CGSize)size handler:(void (^)(PHLivePhoto *))handler {
    PHLivePhotoRequestOptions *requestOptions = [[PHLivePhotoRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    requestOptions.networkAccessAllowed = YES;

    [[PHImageManager defaultManager] requestLivePhotoForAsset:asset
                                                   targetSize:size
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:requestOptions
                                                resultHandler:^(PHLivePhoto *livePhoto, NSDictionary *info) {
                                                    if (handler) {
                                                        handler(livePhoto);
                                                    }
                                                }];
}

@end


