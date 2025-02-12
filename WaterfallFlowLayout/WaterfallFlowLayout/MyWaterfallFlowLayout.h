//
//  MyWaterfallFlowLayout.h
//  demo
//
//  Created by hyy on 2025/2/12.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,MyWaterfallFlowLayoutStyle) {
    MyWaterfallFlowLayoutStyle_Vertical,   //纵向瀑布流
    MyWaterfallFlowLayoutStyle_Horizontal  //横向标签式
};


NS_ASSUME_NONNULL_BEGIN

@protocol MyWaterfallFlowLayoutDelegate <NSObject>
//横向标签式：设置item的size
-(CGSize)myCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

//纵向瀑布流：设置item的高度
-(CGFloat)myCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface MyWaterfallFlowLayout : UICollectionViewFlowLayout

@property(nonatomic, weak)id<MyWaterfallFlowLayoutDelegate> delegate;
//纵向总列数
@property(nonatomic, assign) NSInteger columns;

-(instancetype)initWithStyle:(MyWaterfallFlowLayoutStyle)style;

@end

NS_ASSUME_NONNULL_END
