//
//  FFPictureCtrl.m
//  TestJSPatchDemo
//
//  Created by occ on 2017/2/14.
//  Copyright © 2017年 occ. All rights reserved.
//

#import "FFPictureCtrl.h"
#import "FFPictureCell.h"


@interface FFPictureCtrl ()<UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>
    
    @property (nonatomic, strong) UICollectionViewFlowLayout  * layout;
    
    @property (nonatomic, strong) UICollectionView            * collectionView;
    
    @property (nonatomic, strong) NSMutableArray              * datas;
    
    
    @end

@implementation FFPictureCtrl
    
- (void)dealloc {
    NSLog(@"%s %@", __FUNCTION__, NSStringFromClass([self class]));
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView reloadData];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    // MARK: - getter
    
- (UICollectionViewFlowLayout *)layout {
    
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
    }
    
    return _layout;
}
    
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        
        [_collectionView registerClass:[FFPictureCell class] forCellWithReuseIdentifier:@"FFPictureCell"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        
    }
    
    return _collectionView;
}
    
    
    
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
    
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        return 1;
    }
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
        return 20;
    }
    
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        
        FFPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FFPictureCell" forIndexPath:indexPath];
        cell.backgroundColor = k_COLORRANDOM;
        return cell;
    }
    
    //- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
    //{
    //    if (kind == UICollectionElementKindSectionFooter) {
    //
    //        self.footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFFFooterViewReuseIdentifier forIndexPath:indexPath];
    //        [self.footerView setThemeColorWithColorString:self.themeInfo.color];
    //
    //        return self.footerView;
    //
    //    } else if (kind == UICollectionElementKindSectionHeader) {
    //
    //        FFEasyLifeMainVenueHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFFHeaderViewReuseIdentifier forIndexPath:indexPath];
    //        [headerView setThemeColorWithColorString:self.themeInfo.color];
    //
    //        return headerView;
    //    }
    //
    //    return nil;
    //}
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        return CGSizeMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.width * 2 / 3.);
    }
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
    {
        
        return CGSizeZero;
    }
    
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
    {
        
        return CGSizeZero;
    }
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
    {
        return 0;
    }
    
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
    {
        return 0;
    }
    
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
    {
        
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        
        NSLog(@"----- %li",(long)indexPath.row);
        
    }
    
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        return YES;
    }
    
    
    
    
    
    
    
    
    
    
    @end






