//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerHelper.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SImagePickerHelper.h"

@interface SImagePickerHelper ()

@property (nonatomic, strong) PHCachingImageManager *cacheManager;

@end

@implementation SImagePickerHelper
#pragma mark - Singleton
+ (SImagePickerHelper *)sharedHelper {
    static SImagePickerHelper *__sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      __sharedHelper = [[self alloc] init];
    });

    return __sharedHelper;
}

#pragma mark - Class Methods
- (void)requestAuthorization:(SAuthorizationCompletion)completion {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    if (PHAuthorizationStatusNotDetermined == status) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(status);
                }
            });
        }];
    } else {
        if (completion) {
            completion(status);
        }
    }
}

- (NSArray <PHAssetCollection *> *)fetchAllCollection {
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

- (void)fetchAllAsset:(SFetchAssetResultCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                  ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:options];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion(fetchResult);
            }
        });
    });
}

- (void)fetchAssetForCollection:(PHAssetCollection *)collection completion:(SFetchAssetResultCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                  ascending:NO]];
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion(fetchResult);
            }
        });
    });
}


#pragma mark - Getters
- (PHCachingImageManager *)cacheManager {
    if (!_cacheManager) {
        _cacheManager = [[PHCachingImageManager alloc] init];
    }

    return _cacheManager;
}

@end


#pragma mark -
#pragma mark - Image
@implementation SImagePickerHelper (Image)
#pragma mark - Class Methods
- (void)requestThumbnailForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize isHighQuality:(BOOL)isHighQuality completion:(SImageRequestCompletion)completion {
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    if (isHighQuality) {
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    } else {
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    }
    requestOptions.networkAccessAllowed = YES;
    requestOptions.synchronous = YES;

    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:requestOptions
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (completion) {
                                                    completion(result);
                                                }
                                            }];
}

- (void)requestImageForAsset:(PHAsset *)asset completion:(SImageRequestCompletion)completion {
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

    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    requestOptions.networkAccessAllowed = YES;
    requestOptions.synchronous = YES;

    [self.cacheManager requestImageForAsset:asset
                                 targetSize:size
                                contentMode:PHImageContentModeAspectFill
                                    options:requestOptions
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                    if (completion) {
                                        completion(result);
                                    }
                                }];
}

@end



#pragma mark -
#pragma mark - Video
@implementation SImagePickerHelper (Video)
#pragma mark - Class Methods
- (void)requestVideoForAsset:(PHAsset *)asset completion:(SVideoRequestCompletion)completion {
    PHVideoRequestOptions *requestOptions = [[PHVideoRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    requestOptions.version = PHVideoRequestOptionsVersionOriginal;

    [self.cacheManager requestAVAssetForVideo:asset
                                      options:requestOptions
                                resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                                    if (completion) {
                                        if (asset && [asset isKindOfClass:[AVURLAsset class]]) {
                                            AVURLAsset *avAsset = (AVURLAsset *)asset;
                                            CMTime time = avAsset.duration;
                                            CGFloat duration = time.value / time.timescale;
                                            completion(avAsset.URL, duration);
                                        } else {
                                            completion(nil, 0.f);
                                        }
                                    }
                                }];
}

@end


#pragma mark -
#pragma mark - LivePhoto
@implementation SImagePickerHelper (LivePhoto)
#pragma mark - Class Methods
- (void)requestLivePhotoForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(SLivePhotoRequestCompletion)completion {
    PHLivePhotoRequestOptions *requestOptions = [[PHLivePhotoRequestOptions alloc] init];
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    requestOptions.networkAccessAllowed = YES;

    [self.cacheManager requestLivePhotoForAsset:asset
                                     targetSize:targetSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:requestOptions
                                  resultHandler:^(PHLivePhoto *livePhoto, NSDictionary *info) {
                                        if (completion) {
                                            completion(livePhoto);
                                        }
                                    }];
}

@end

#pragma mark -
#pragma mark - Caching
@implementation SImagePickerHelper (Caching)
- (void)startCachingImagesForAssets:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize {
    [self.cacheManager startCachingImagesForAssets:assets
                                        targetSize:targetSize
                                       contentMode:PHImageContentModeAspectFill
                                           options:nil];
}

- (void)stopCachingImagesForAssets:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize {
    [self.cacheManager startCachingImagesForAssets:assets
                                        targetSize:targetSize
                                       contentMode:PHImageContentModeAspectFill
                                           options:nil];
}

- (void)stopCachingImagesForAllAssets {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

    if (PHAuthorizationStatusNotDetermined == status) {
        [self.cacheManager stopCachingImagesForAllAssets];
    }
}

@end


