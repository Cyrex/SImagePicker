///
///  Copyright © 2019 zhiweisun. All rights reserved.
///
///  File name: SViewController.m
///  Author:    zhiweisun @Cyrex
///  E-mail:    szwathub@gmail.com
///

#import "SViewController.h"
#import <SImagePicker/SImagePickerUntils.h>

@interface SViewController ()

@end

@implementation SViewController
- (void)viewDidLoad {
    [super viewDidLoad];
	/// Do any additional setup after loading the view, typically from a nib.
//    [SImagePickerUntils requestAuthorization:^(PHAuthorizationStatus status) {
//        ;
//    }];
    PHAsset *as = [SImagePickerUntils fetchAllAsset].firstObject;
    [SImagePickerUntils requestVideoForAsset:as handler:^(NSURL * _Nonnull avURL, CGFloat duration) {
        ;
    }];;
}

@end
