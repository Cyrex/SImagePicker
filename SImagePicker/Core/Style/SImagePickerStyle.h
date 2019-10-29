//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerStyle.h
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

@interface SImagePickerStyle : NSObject

@property (class, strong, readonly) SImagePickerStyle *defaultStyle;

@property (nonatomic, strong) UIColor *backColor;

@end

NS_ASSUME_NONNULL_END
