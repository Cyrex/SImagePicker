//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImageFetchOperation.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/12/19: Created by Cyrex on 2019/12/19
//

#import "SImageFetchOperation.h"
#import <Photos/PHAsset.h>
#import <Photos/PHImageManager.h>

@interface SImageFetchOperation ()

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, assign) PHImageRequestID requestID;
@property (nonatomic, assign) CGSize targetSize;
@property (nonatomic, assign) BOOL isHighQuality;
@property (nonatomic, copy) SImageOperationFetchCompletion completion;

@end

@implementation SImageFetchOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

// MARK: - Life Cycle
- (instancetype)initWithAsset:(PHAsset *)asset {
    if (self = [super init]) {
        self.asset = asset;

        _executing = NO;
        _finished = NO;
    }
    
    return self;
}


// MARK: - Public Methods
- (void)requesImageWithSize:(CGSize)size needHighQuality:(BOOL)isHighQuality completion:(SImageOperationFetchCompletion)completion {
    self.targetSize = size;
    self.isHighQuality = isHighQuality;
    self.completion = completion;
}


// MARK: - Override
- (void)start {
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        if (!self.asset) {
            self.finished = YES;
            [self reset];
            return;
        }
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed   = YES;
        if (self.isHighQuality) {
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        } else {
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
        }
        [PHImageManager.defaultManager requestImageForAsset:self.asset
                                                 targetSize:self.targetSize
                                                contentMode:PHImageContentModeAspectFill
                                                    options:options
                                              resultHandler:^(UIImage *result, NSDictionary * _Nullable info) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        if (self.completion) {
                                                            self.completion(result);
                                                        }
                                                        [self done];
                                                    });
                                            }];
        self.executing = YES;
    }
}

- (void)cancel {
    @synchronized (self) {
        if (self.isFinished) {
            return;
        }

        [super cancel];
        
        if (self.asset && self.requestID != PHInvalidImageRequestID) {
            [PHImageManager.defaultManager cancelImageRequest:self.requestID];
            if (self.isExecuting) self.executing = NO;
            if (!self.isFinished) self.finished = YES;
        }
        [self reset];
    }
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.asset = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
