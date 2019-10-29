//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePicker.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SImagePicker.h"
#import "SImagePickerStyle.h"


@interface SImagePicker () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation SImagePicker
#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(dismissViewController)];
}


#pragma mark - Private Methods
- (void)configViews {
//    [self.view addSubview:self.collectionView];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(DeviceNaviHeight, 0, 0, 0));
//    }];
}


#pragma mark - Class Methods
+ (void)showImagePickerFromController:(UIViewController<SImagePickerDataSource, SImagePickerDelegate> *)fromController
                          configBlock:(void (^)(SImagePickerStyle *))configBlock {

    SImagePickerStyle *defaultStyle = SImagePickerStyle.defaultStyle;
    configBlock(defaultStyle);

    SImagePicker *imagePicker = [[SImagePicker alloc] init];
    imagePicker.dataSource    = fromController;
    imagePicker.delegate      = fromController;
    imagePicker.view.backgroundColor = defaultStyle.backColor;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:imagePicker];
    [fromController presentViewController:navController animated:YES completion:nil];
}


#pragma mark - Action Methods
- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerDidCancel:)]) {
            [self.delegate imagePickerDidCancel:self];
        }
    }];
}


#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
//        [_collectionView registerClass:[APStoreCoinsCell class]
//            forCellWithReuseIdentifier:[APStoreCoinsCell reuseIdentifier]];
    }

    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
//        _flowLayout.sectionInset = UIEdgeInsetsMake(S_Y(10), S_Y(18), S_Y(10), S_Y(18));
//        _flowLayout.minimumLineSpacing = S_Y(12);
//        _flowLayout.minimumInteritemSpacing = S_Y(12);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }

    return _flowLayout;
}

@end
