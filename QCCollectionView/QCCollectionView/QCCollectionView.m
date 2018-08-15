//
//  QCCollectionView.m
//  QCCollectionView
//
//  Created by 钱城 on 2018/8/14.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import "QCCollectionView.h"
#import "QCCollectionViewModel.h"
#import "QCCollectionViewUtil.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"

@interface QCCollectionView()<UICollectionViewDataSource,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic,assign) QCCollectionViewState state;

@property (nonatomic,strong) QCCollectionViewModel *emptyModel;

@property (nonatomic,strong) QCCollectionViewModel *loadingModel;

@property (nonatomic,strong) QCCollectionViewModel *errorModel;

@property (nonatomic,strong,readonly) QCCollectionViewModel *currentModel;

@end

@implementation QCCollectionView

#pragma 懒加载
-(NSArray *)datalist
{
    if (!_datalist) {
        self.datalist = [NSArray array];
    }
    return _datalist;
}

-(QCCollectionViewModel *)emptyModel
{
    if (!_emptyModel) {
        self.emptyModel = [[QCCollectionViewModel alloc]init];
        self.emptyModel.title = [QCCollectionViewUtil getAttribute:@"暂无数据" font:[UIFont systemFontOfSize:16.0] textColor:[QCCollectionViewUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
        self.emptyModel.image = [UIImage imageNamed:@"QCTableView.bundle/empty"];
        self.emptyModel.spaceHeight = 0.0;
        self.emptyModel.verticalOffset = -100.0;
        self.emptyModel.shouldDisplay = YES;
        self.emptyModel.shouldAllowTouch = YES;
        self.emptyModel.shouldAllowScroll = YES;
        self.emptyModel.shouldAnimateImage = NO;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        self.emptyModel.imageAnimation = animation;
    }
    return _emptyModel;
}

-(QCCollectionViewModel *)loadingModel
{
    if (!_loadingModel) {
        self.loadingModel = [[QCCollectionViewModel alloc]init];
        self.loadingModel.backgroundColor = [QCCollectionViewUtil colorWithHex:@"f5f5f5"];
        self.loadingModel.image = [UIImage imageNamed:@"QCTableView.bundle/empty"];
        self.loadingModel.spaceHeight = 0.0;
        self.loadingModel.verticalOffset = -100.0;
        self.loadingModel.shouldDisplay = NO;
        self.loadingModel.shouldAllowTouch = YES;
        self.loadingModel.shouldAllowScroll = YES;
        self.loadingModel.shouldAnimateImage = NO;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        self.loadingModel.imageAnimation = animation;
    }
    return _loadingModel;
}

-(QCCollectionViewModel *)errorModel
{
    if (!_errorModel) {
        self.errorModel = [[QCCollectionViewModel alloc]init];
        self.errorModel.title = [QCCollectionViewUtil getAttribute:@"加载失败" font:[UIFont systemFontOfSize:16.0] textColor:[QCCollectionViewUtil colorWithHex:@"b9b9b9"] lineSpacing:1.0];
        self.errorModel.image = [UIImage imageNamed:@"QCCollectionView.bundle/empty"];
        self.errorModel.spaceHeight = 0.0;
        self.errorModel.verticalOffset = -100.0;
        self.errorModel.shouldDisplay = YES;
        self.errorModel.shouldAllowTouch = YES;
        self.errorModel.shouldAllowScroll = YES;
        self.errorModel.shouldAnimateImage = NO;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        self.errorModel.imageAnimation = animation;
    }
    return _errorModel;
}

-(void)registerNibName:(NSString *)nibName identifier:(NSString *)identifier{
    [self registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:identifier];
}

-(void)registerClassName:(NSString *)className identifier:(NSString *)identifier{
    [self registerClass:NSClassFromString(className) forCellWithReuseIdentifier:identifier];
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if ([self.qcDelegate respondsToSelector:@selector(qcCollectionView:didSelectRowAtIndexPath:)]) {
        [self.qcDelegate qcCollectionView:self didSelectRowAtIndexPath:indexPath];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([self.qcDataSource respondsToSelector:@selector(qcCollectionView:numberOfItemsInSection:)]) {
        return [self.qcDataSource qcCollectionView:self numberOfItemsInSection:section];
    }
    return self.datalist.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if ([self.qcDataSource respondsToSelector:@selector(numberOfSectionsInQcCollectionView:)]) {
        [self.qcDataSource numberOfSectionsInQcCollectionView:self];
    }
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.qcDataSource qcCollectionView:self cellForItemAtIndexPath:indexPath];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([self.qcDataSource respondsToSelector:@selector(qcCollectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        [self.qcDataSource qcCollectionView:self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.qcDelegateFlowLayout respondsToSelector:@selector(qcCollectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.qcDelegateFlowLayout qcCollectionView:self layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if ([self.qcDelegateFlowLayout respondsToSelector:@selector(qcCollectionView:layout:referenceSizeForHeaderInSection:)]) {
        return [self.qcDelegateFlowLayout qcCollectionView:self layout:collectionViewLayout referenceSizeForHeaderInSection:section];
    }
    
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if ([self.qcDelegateFlowLayout respondsToSelector:@selector(qcCollectionView:layout:referenceSizeForFooterInSection:)]) {
        return [self.qcDelegateFlowLayout qcCollectionView:self layout:collectionViewLayout referenceSizeForFooterInSection:section];
    }
    
    return CGSizeZero;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.qcDelegate respondsToSelector:@selector(scrollViewDidScroll:qcCollectionView:)]) {
        [self.qcDelegate scrollViewDidScroll:scrollView qcCollectionView:self];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([self.qcDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:qcCollectionView:)]) {
        [self.qcDelegate scrollViewWillBeginDragging:scrollView qcCollectionView:self];
    }
}

@end
