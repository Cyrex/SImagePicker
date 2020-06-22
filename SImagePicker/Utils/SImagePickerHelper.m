//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerHelper.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SImagePickerHelper.h"
#import "SImageFetchOperation.h"

@interface SImagePickerHelper ()

@property (nonatomic, strong) NSOperationQueue *fetchQueue;
@property (nonatomic, strong) NSMutableDictionary<NSString *, SImageFetchOperation*> *fetchOperationDics;

@end

@implementation SImagePickerHelper
// MARK: Singleton
+ (SImagePickerHelper *)sharedHelper {
    static SImagePickerHelper *__sharedHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      __sharedHelper = [[self alloc] init];
    });

    return __sharedHelper;
}


// MARK: Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.fetchQueue = [NSOperationQueue new];
        self.fetchQueue.maxConcurrentOperationCount = 8;
        self.fetchQueue.name = @"com.szwathub.imagePickerFetchQueue";
        self.fetchOperationDics = [NSMutableDictionary dictionary];
    }

    return self;
}

// MARK: - Public Methods
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

- (NSArray<PHAssetCollection *> *)fetchAllCollection {
    NSMutableArray <PHAssetCollection *> *collectionArray = [NSMutableArray array];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                          subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                          options:nil];
    if (smartAlbums.count > 0) {
        [smartAlbums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assets.count > 0) {
                    [collectionArray addObject:collection];
                }
            }
        }];
    }
    
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                                          subtype:PHAssetCollectionSubtypeAlbumRegular
                                                                          options:nil];
    if (albums.count > 0) {
        [albums enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[PHAssetCollection class]]) {
                PHAssetCollection *collection = obj;
                PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
                if (assets.count > 0) {
                    [collectionArray addObject:collection];
                }
            }
        }];
    }

    return collectionArray;
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

- (void)fetchAssetForCollection:(PHAssetCollection *)collection
                     fetchLimit:(NSUInteger)fetchLimit
                     completion:(SFetchAssetResultCompletion)completion {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                  ascending:NO]];
        options.fetchLimit = fetchLimit;
        PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];

        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion) {
                completion(fetchResult);
            }
        });
    });
}

@end


// MARK: -
// MARK: - Image
@implementation SImagePickerHelper (Image)
// MARK: - Public Methods
- (void)requestThumbnailForAsset:(PHAsset *)asset
                      targetSize:(CGSize)targetSize
                   isHighQuality:(BOOL)isHighQuality
                      completion:(SImageRequestCompletion)completion {

    SImageFetchOperation *operation = [[SImageFetchOperation alloc] initWithAsset:asset];
    __weak typeof(self) weakSelf = self;
    [operation requesImageWithSize:targetSize needHighQuality:isHighQuality completion:^(UIImage *image) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.fetchOperationDics removeObjectForKey:asset.localIdentifier];
        completion(image, asset.localIdentifier);
    }];

    [self.fetchQueue addOperation:operation];
    [self.fetchOperationDics setValue:operation forKey:asset.localIdentifier];
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

    [self requestThumbnailForAsset:asset targetSize:size isHighQuality:YES completion:completion];
}

- (void)cancelFetchWithAsset:(PHAsset *)asset {
    SImageFetchOperation *operation = [[SImagePickerHelper sharedHelper].fetchOperationDics objectForKey:asset.localIdentifier];
    if (operation) {
        [operation cancel];
    }
    [[SImagePickerHelper sharedHelper].fetchOperationDics removeObjectForKey:asset.localIdentifier];
}

@end



// MARK: -
// MARK: - Video
@implementation SImagePickerHelper (Video)
// MARK: - Public Methods
- (void)requestVideoForAsset:(PHAsset *)asset completion:(SVideoRequestCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHVideoRequestOptions *requestOptions = [[PHVideoRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        requestOptions.version = PHVideoRequestOptionsVersionOriginal;

        [PHImageManager.defaultManager requestAVAssetForVideo:asset
                                                      options:requestOptions
                                                resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
                                                    if (completion) {
                                                        if (asset && [asset isKindOfClass:[AVURLAsset class]]) {
                                                            AVURLAsset *avAsset = (AVURLAsset *)asset;
                                                            CMTime time = avAsset.duration;
                                                            CGFloat duration = time.value / time.timescale;
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if(completion) {
                                                                    completion(avAsset.URL, duration);
                                                                }
                                                            });
                                                            
                                                        } else {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                if(completion) {
                                                                    completion(nil, 0.f);
                                                                }
                                                            });
                                                        }
                                                    }
                                            }];
    });
}

@end


// MARK: -
// MARK: - LivePhoto
@implementation SImagePickerHelper (LivePhoto)
// MARK: - Public Methods
- (void)requestLivePhotoForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(SLivePhotoRequestCompletion)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHLivePhotoRequestOptions *requestOptions = [[PHLivePhotoRequestOptions alloc] init];
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        requestOptions.networkAccessAllowed = YES;

        [PHImageManager.defaultManager requestLivePhotoForAsset:asset
                                                     targetSize:targetSize
                                                    contentMode:PHImageContentModeAspectFit
                                                        options:requestOptions
                                                  resultHandler:^(PHLivePhoto *livePhoto, NSDictionary *info) {
                                                    if (completion) {
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            if(completion) {
                                                                completion(livePhoto);
                                                            }
                                                        });
                                                    }
                                                }];
    });
}

@end


