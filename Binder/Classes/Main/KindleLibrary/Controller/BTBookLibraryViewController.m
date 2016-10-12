//
//  BTBookLibraryViewController.m
//  Binder
//
//  Created by 钟奇龙 on 16/10/4.
//  Copyright © 2016年 com.developer.jaccob. All rights reserved.
//

#import "BTBookLibraryViewController.h"
#import "BTBookTagViewController.h"
@interface BTBookLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSArray *bookTagArray;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *customLayout;
@end

@implementation BTBookLibraryViewController
static NSString *const cellId = @"cellId";
static NSString *const headerId = @"headerId";
static NSString *const footerId = @"footerId";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"书架";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"cellBackground"] forBarMetrics:UIBarMetricsDefault];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    [backButton setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigationbar_back_highlighted"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _bookTagArray = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"BookTag.plist" ofType:nil]];
    
    // 注册cell、sectionHeader、sectionFooter

    _customLayout = [[UICollectionViewFlowLayout alloc ]init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:_customLayout];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"libraryBackground_0000_Layer-1"]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerId];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerId];
    [self.collectionView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _bookTagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    UIImageView *tagImageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    tagImageView.image = [UIImage imageNamed:@"collectionCellBackground_0004_Texture"];
    tagImageView.userInteractionEnabled = YES;
    
    UILabel *tagLabel = [[UILabel alloc] initWithFrame:cell.bounds];
    tagLabel.text = self.bookTagArray[indexPath.item];
    
//    UIButton *tagButton = [[UIButton alloc] initWithFrame:cell.bounds];
//    [tagButton setBackgroundImage:[UIImage imageNamed:@"collectionCellBackground_0004_Texture"] forState:UIControlStateNormal];
//    [tagButton setTitle:self.bookTagArray[indexPath.item] forState:UIControlStateNormal];
//    tagButton.titleLabel.text = self.bookTagArray[indexPath.item];
    tagLabel.adjustsFontSizeToFitWidth = YES;
    tagLabel.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:tagImageView];
    [cell.contentView addSubview:tagLabel];
    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if([kind isEqualToString:UICollectionElementKindSectionHeader])
//    {
//        UICollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerId forIndexPath:indexPath];
//        if(headerView == nil)
//        {
//            headerView = [[UICollectionReusableView alloc] init];
//        }
//        headerView.backgroundColor = [UIColor grayColor];
//        
//        return headerView;
//    }
//    else if([kind isEqualToString:UICollectionElementKindSectionFooter])
//    {
//        UICollectionReusableView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerId forIndexPath:indexPath];
//        if(footerView == nil)
//        {
//            footerView = [[UICollectionReusableView alloc] init];
//        }
//        footerView.backgroundColor = [UIColor lightGrayColor];
//        
//        return footerView;
//    }
//    
//    return nil;
//}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark ---- UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){UIScreenWidth / 6,44};
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){UIScreenWidth,22};
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return (CGSize){UIScreenWidth,22};
}

#pragma mark ---- UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 点击高亮
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    for (UIView *tagView in cell.contentView.subviews) {
        if (![tagView isKindOfClass:[UIImageView class]]) {
            return;
        }
        UIImageView *tagImageView = (UIImageView *)tagView;
        tagImageView.image = [UIImage imageNamed:@"collectionCellBackground_0002_Button"];
    }
    
    
    
}


// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *bookTag = self.bookTagArray[indexPath.item];
    BTBookTagViewController *bookTagVC = [[BTBookTagViewController alloc] initWithStyle:UITableViewStyleGrouped];
    bookTagVC.bookTag = bookTag;
    
    [self.navigationController pushViewController:bookTagVC animated:YES];
    bookTagVC.title = bookTag;
}

- (void)dealloc
{
    if ([self.delegate respondsToSelector:@selector(bookLibraryVCDidDismissed)]) {
        [self.delegate bookLibraryVCDidDismissed];
    }
}

@end
