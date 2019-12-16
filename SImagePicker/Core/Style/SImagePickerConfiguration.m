//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePickerConfiguration.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SImagePickerConfiguration.h"

@implementation SImagePickerConfiguration
#pragma mark - Class Methods
+ (SImagePickerConfiguration *)defaultConfiguration {
    SImagePickerConfiguration *configuration = [[SImagePickerConfiguration alloc] init];

    configuration.backgroundColor  = [UIColor whiteColor];
    configuration.maxSelectedCount = 9;

    return configuration;
}

@end
