//
//  MyWaterfallFlowLayout.m
//  demo
//
//  Created by hyy on 2025/2/12.
//

#import "MyWaterfallFlowLayout.h"

/*  ****** 功能说明 ******  */
/*  横向标签式布局，超过一行就换行排布，标签的高度固定  */
/*  纵向瀑布流布局，列数固定，item的高度动态变化  */
@interface MyWaterfallFlowLayout()

//保存item的attributes设置
@property(nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes*> *dataArray;
//记录CollectionView的Height
@property(nonatomic, assign) CGFloat contentSizeHeight;
//瀑布流风格
@property(nonatomic, assign) MyWaterfallFlowLayoutStyle style;

@end

@implementation MyWaterfallFlowLayout

-(instancetype)initWithStyle:(MyWaterfallFlowLayoutStyle)style {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.contentSizeHeight = 0.0;
        self.style = style;
        self.columns = 2;
    }
    return self;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.contentSizeHeight = 0.0;
        self.style = MyWaterfallFlowLayoutStyle_Horizontal;
        self.columns = 2;
    }
    return self;
}

#pragma mark - 重写以下实现
-(void)prepareLayout {
    [super prepareLayout];
    [self.dataArray removeAllObjects];
    
    if (self.style == MyWaterfallFlowLayoutStyle_Horizontal) {
        [self horizontalFlowLayout];
    }
    else {
        [self vorizontalFlowLayout];
    }
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray<UICollectionViewLayoutAttributes *> *attributes = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attribute in self.dataArray) {
        if (CGRectIntersectsRect(attribute.frame, rect)) {
            [attributes addObject:attribute];
        }
    }
    return attributes;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray[indexPath.item];
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentSizeHeight);
}

#pragma mark - 横向布局
-(void)horizontalFlowLayout {
    //取出总个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat itemWidth = 0.0;
    CGFloat itemHeight = 0.0;
    
    //遍历每个item重新布局
    for (NSInteger item = 0; item < itemCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        CGSize itemSize;
        //实现了代理则取代理返回的宽高
        if ([self.delegate respondsToSelector:@selector(myCollectionView:layout:sizeForItemAtIndexPath:)]) {
            itemSize = [self.delegate myCollectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
        }
        //否则取flowLayout设置的宽高
        else {
            itemSize = self.itemSize;
        }
        itemWidth = itemSize.width;
        itemHeight = itemSize.height;
        //超出边界则另起一行
        if (xOffset + itemWidth > self.collectionView.bounds.size.width - self.sectionInset.right) {
            xOffset = self.sectionInset.left;
            yOffset += itemHeight + self.minimumLineSpacing;
        }
        attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
        [self.dataArray addObject:attributes];
        //更新item的x坐标
        xOffset += itemWidth + self.minimumInteritemSpacing;
    }
    self.contentSizeHeight = yOffset + itemHeight;
}

#pragma mark - 纵向布局
-(void)vorizontalFlowLayout {
    //取出总个数
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat itemWidth = (self.collectionView.bounds.size.width - self.minimumInteritemSpacing * (self.columns - 1)) / self.columns;
    CGFloat itemHeight = 0.0;
    
    //遍历每个item重新布局
    for (NSInteger item = 0; item < itemCount; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        //实现了代理则取代理返回的宽高
        if ([self.delegate respondsToSelector:@selector(myCollectionView:layout:heighForItemAtIndexPath:)]) {
            itemHeight = [self.delegate myCollectionView:self.collectionView layout:self heighForItemAtIndexPath:indexPath];
        }
        //否则取flowLayout设置的宽高
        else {
            itemHeight = self.itemSize.height;
        }
        
        if (xOffset + itemWidth > self.collectionView.bounds.size.width - self.sectionInset.right) {
            xOffset = self.sectionInset.left;
        }
        
        //取出当前item对应的上一列item，第一排不需要处理
        if (self.columns <= item) {
            NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:item - self.columns inSection:0];
            UICollectionViewLayoutAttributes *preAttributes = self.dataArray[preIndexPath.item];
            yOffset = preAttributes.size.height + self.minimumLineSpacing + preAttributes.frame.origin.y;
        }
        attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
        [self.dataArray addObject:attributes];
        xOffset += itemWidth + self.minimumInteritemSpacing;
    }
    
    //计算每列的总高度
    CGFloat maxHeight = 0.0;
    for (NSInteger column = 1; column <= self.columns; column++) {
        //取出最后一排的item比较即可
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:itemCount - column inSection:0];
        UICollectionViewLayoutAttributes *lastAttributes = self.dataArray[lastIndexPath.item];
        maxHeight = MAX(lastAttributes.size.height + lastAttributes.frame.origin.y, maxHeight);
    }
    self.contentSizeHeight = maxHeight;
}

@end
