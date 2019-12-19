//
//  Copyright © 2019 ZhiweiSun. All rights reserved.
//
//  File name: SImagePicker.m
//  Author:    Zhiwei Sun @Cyrex
//  E-mail:    szwathub@gmail.com
//

#import "SImagePicker.h"

#import "SAssetCell.h"

#import "SImagePickerConfiguration.h"

@interface SImagePicker () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) SImagePickerConfiguration *configuration;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray<PHAsset *> *dataList;

@end

@implementation SImagePicker
#pragma mark - Override
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configViews];
    [self configNavigations];
    [self renderViews];
}


#pragma mark - Private Methods
- (void)configViews {
    [self.view addSubview:self.collectionView];
}

- (void)configNavigations {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(dismissViewController)];
}

- (void)renderViews {
    self.view.backgroundColor = self.configuration.backgroundColor;
}


#pragma mark - Class Methods
+ (void)showImagePickerFromController:(UIViewController<SImagePickerDataSource,SImagePickerDelegate> *)fromController
                          configBlock:(SImagePickerConfiguration * (^)(void))configBlock {

    SImagePicker *imagePicker = [[SImagePicker alloc] init];
    imagePicker.dataSource    = fromController;
    imagePicker.delegate      = fromController;
    imagePicker.configuration = configBlock();

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


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SAssetCell reuseIdentifier]
                                                                 forIndexPath:indexPath];

    if (indexPath.row < self.dataList.count) {
        PHAsset *asset = [self.dataList objectAtIndex:indexPath.row];
        [SImagePickerHelper.sharedHelper requestThumbnailForAsset:asset targetSize:CGSizeMake(200, 200) isHighQuality:YES completion:^(UIImage *image) {
            cell.image = image;
        }];
    }
//        if (image) {
//            [cell setImage:image];
//        } else {
//            [SImagePickerUntils requestThumbnailForAsset:asset isHighQuality:YES handler:^(UIImage * _Nullable thumbnail) {
//                [cell setImage:thumbnail];
//            }];
////            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////                [SImagePickerUntils requestImageForAsset:asset handler:^(UIImage * _Nullable image) {
////                    dispatch_async(dispatch_get_main_queue(), ^{
////                        [self.imgCache setObject:image forKey:asset];
////                        [cell setImage:image];
////                    });
////                }];
////            });
//        }

    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(floor((CGRectGetWidth(collectionView.bounds) - 12) / 3),
                      floor((CGRectGetWidth(collectionView.bounds) - 12) / 3));
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
        [_collectionView registerClass:[SAssetCell class]
            forCellWithReuseIdentifier:[SAssetCell reuseIdentifier]];
    }

    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 3, 0, 3);
        _flowLayout.minimumLineSpacing = 3;
        _flowLayout.minimumInteritemSpacing = 3;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }

    return _flowLayout;
}

- (NSArray<PHAsset *> *)dataList {
    if (!_dataList) {
//        _dataList = [[SImagePickerHelper sharedHelper] fetchAllAsset];
    }

    return _dataList;
}

@end
