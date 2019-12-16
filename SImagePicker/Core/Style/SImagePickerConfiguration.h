//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerConfiguration.h
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//
//  Description:
//
//  History:
//      2019/6/20: Created by Cyrex on 2019/6/20
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SImagePickerConfiguration : NSObject

@property (class, strong, readonly) SImagePickerConfiguration *defaultConfiguration;

// NavigationBar
@property (nonatomic, strong) UIColor *navigationBarColor;

@property (nonatomic, strong) UIColor *backgroundColor;

//
@property (nonatomic, assign) NSInteger maxSelectedCount;

@end

NS_ASSUME_NONNULL_END
