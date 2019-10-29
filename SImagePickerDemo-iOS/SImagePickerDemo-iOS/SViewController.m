//
//  Copyright © 2019 zhiweisun. All rights reserved.
//
//  File name: SViewController.m
//  Author:    zhiweisun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SViewController.h"
#import <SImagePicker/SImagePicker.h>
#import "Masonry.h"

@interface SViewController () <SImagePickerDataSource, SImagePickerDelegate>

@property (nonatomic, strong) UIButton *showButton;

@end

@implementation SViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	/// Do any additional setup after loading the view, typically from a nib.
    [[SImagePickerHelper sharedHelper] requestAuthorization:nil];
    [self.view addSubview:self.showButton];
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
        make.size.mas_equalTo(CGSizeMake(200, 60));
    }];
}


#pragma mark - Action Methods
- (void)showImagePicker {
    [SImagePicker showImagePickerFromController:self configBlock:^(SImagePickerStyle *style) {
        style.backColor = [UIColor blueColor];
    }];
}


#pragma mark - SImagePickerDelegate
- (void)imagePicker:(SImagePicker *)imagePicker didPickingAssets:(NSArray<PHAsset *> *)assets {

}

- (void)imagePickerDidCancel:(SImagePicker *)imagePicker {
    ;
}


#pragma mark - Getters
- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [[UIButton alloc] init];
        [_showButton setTitle:@"Show ImagePicker" forState:UIControlStateNormal];
        [_showButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _showButton.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:16];
        [_showButton addTarget:self
                        action:@selector(showImagePicker)
              forControlEvents:UIControlEventTouchUpInside];
    }

    return _showButton;
}

@end
