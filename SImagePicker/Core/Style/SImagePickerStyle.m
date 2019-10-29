//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerStyle.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SImagePickerStyle.h"

@implementation SImagePickerStyle
#pragma mark - Class Methods
+ (SImagePickerStyle *)defaultStyle {
    SImagePickerStyle *configuration = [[SImagePickerStyle alloc] init];

    configuration.backColor = [UIColor redColor];

    return configuration;
}

@end
