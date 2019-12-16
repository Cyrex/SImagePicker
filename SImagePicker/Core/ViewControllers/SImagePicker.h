//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePicker.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/6/20: Created by Cyrex on 2019/6/20
//

#import <UIKit/UIKit.h>

//! Project version number for SImagePicker.
FOUNDATION_EXPORT double SImagePickerVersionNumber;

//! Project version string for SImagePicker.
FOUNDATION_EXPORT const unsigned char SImagePickerVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SImagePicker/SImagePicker.h>
#if __has_include(<SImagePicker/SImagePicker.h>)
    #import <SImagePicker/SImagePickerHelper.h>
    #import <SImagePicker/SImagePickerConfiguration.h>
#else
    #import "SImagePickerHelper.h"
    #import "SImagePickerConfiguration.h"
#endif


NS_ASSUME_NONNULL_BEGIN

@class SImagePickerConfiguration;
@class PHAsset;

@protocol SImagePickerDataSource;
@protocol SImagePickerDelegate;

#pragma mark -
#pragma mark - SImagePicker
@interface SImagePicker : UIViewController

@property (nonatomic, weak) id<SImagePickerDataSource> dataSource;
@property (nonatomic, weak) id<SImagePickerDelegate> delegate;

+ (void)showImagePickerFromController:(UIViewController<SImagePickerDataSource, SImagePickerDelegate> *)fromController
                          configBlock:(SImagePickerConfiguration * (^)(void))configBlock;

@end

#pragma mark -
#pragma mark - SImagePickerDataSource
@protocol SImagePickerDataSource <NSObject>
@required
//- (SImagePickerConfiguration *)configurationForImagePicker:(SImagePicker *)imagePicker;

@end


#pragma mark -
#pragma mark - SImagePickerDelegate
@protocol SImagePickerDelegate <NSObject>
@optional
- (void)imagePicker:(SImagePicker *)imagePicker didPickingAssets:(NSArray <PHAsset *> *)assets;

- (void)imagePickerDidCancel:(SImagePicker *)imagePicker;

@end

NS_ASSUME_NONNULL_END
