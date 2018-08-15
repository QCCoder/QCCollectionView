//
//  QCCollectionView.h
//  QCCollectionView
//
//  Created by 钱城 on 2018/8/14.
//  Copyright © 2018年 钱城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    QCCollectionViewRefreshTypeRefresh,     //刷新数据
    QCCollectionViewRefreshTypeLoadNewData, //下啦刷新
    QCCollectionViewRefreshTypeLoadMore     //加载更多
} QCCollectionViewRefreshType;

typedef enum : NSUInteger {
    QCCollectionViewStateNormal,   //正常
    QCCollectionViewStateLoading,  //加载中
    QCCollectionViewStateError,    //报错页
    QCCollectionViewStateEmpty     //空数据
} QCCollectionViewState;

@class QCCollectionView;
@protocol QCCollectionViewDataSource <NSObject>

-(UICollectionViewCell *)qcCollectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@required

- (NSInteger)numberOfSectionsInQcCollectionView:(UICollectionView *)collectionView;

- (NSInteger)qcCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;

- (UICollectionReusableView *)qcCollectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

@end

@class QCCollectionView;
@protocol QCCollectionViewDelegate <NSObject>


- (void)qcCollectionView:(QCCollectionView *)collectionView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView qcCollectionView:(QCCollectionView *)collectionView;

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView qcCollectionView:(QCCollectionView *)collectionView;

@end

@class QCCollectionView;
@protocol QCCollectionViewDelegateFlowLayout <NSObject>

- (CGSize)qcCollectionView:(QCCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

-(CGSize)qcCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;

-(CGSize)qcCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

@end

@interface QCCollectionView : UICollectionView

@property (nonatomic, weak) id<QCCollectionViewDelegate> qcDelegate;

@property (nonatomic, weak) id<QCCollectionViewDelegateFlowLayout> qcDelegateFlowLayout;

@property (nonatomic, weak) id<QCCollectionViewDataSource> qcDataSource;

/**
 *  数组存放数据，若数组为空则显示无数据界面
 */
@property (nonatomic, strong) NSArray *datalist;

/**
 *  请求错误时调用,错误界面将会显示error.domain中的文字内容
 */
- (void)refreshWithError:(NSString *)error;

/**
 *  请求成功时调用，传入数组.
 *  若 data,count = 0 显示无数据界面
 */
- (void)refreshWithList:(NSArray *)data refreshType:(QCCollectionViewRefreshType)type;

/**
 *  获取新数据，刷新时会调用这个block
 *  当设置requestMoreData这个属性时，列表会自动加上上拉刷新
 */
@property (nonatomic, copy) void (^headerRefresh)(QCCollectionView *tableView);
- (void)removeHeaderRefreshView;

/**
 *  获取更多数据，上拉加载更对数据时会调用这个block
 *  当设置requestMoreData这个属性时，列表会自动加上下拉加载
 */
@property (nonatomic, copy) void (^footerRefresh)(QCCollectionView *tableView);
- (void)removeFooterRefreshView;

- (void)registerNibName:(NSString *)nibName identifier:(NSString *)identifier;
- (void)registerClassName:(NSString *)className identifier:(NSString *)identifier;

/**
 *  开始加载数据
 */
- (void)loadHeaderData;
- (void)loadHeaderDataWithAnimation;

/**
 *  开始加载数据
 */
- (void)loadFooterData;

//每页加载数据量，默认10,若是不是10的倍数则会显示 ”暂无更多数据“
@property (nonatomic,assign) NSInteger countPerPage;

@end
