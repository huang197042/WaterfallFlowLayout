//
//  ViewController.m
//  WaterfallFlowLayout
//
//  Created by hyy on 2025/2/12.
//

#import "ViewController.h"
#import "MyWaterfallFlowLayout.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,MyWaterfallFlowLayoutDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[@"你好呀这是一行非常长的段落，为了测试一行展示不全的效果应该是怎么样的",@"测试数据",@"测试数据测试数据",@"测试数据",@"测试数据测试数据测试数据测试数据",@"测试数据测试数据",@"测试数据",@"测试",@"测试数据测试数据测试数据",@"测试数据",@"测试",@"测试数据测试数据",@"测试",@"数",@"据",@"的",@"测试数据测试数据测试数据",@"测",@"试",@"测试数据",@"测试数据测试数据",@"测试数据",@"测试数据",@"测试数据",@"测试数据",@"测试数据",@"测试数据测试数据",@"测试数据测试数据测试数据"];
    
    MyWaterfallFlowLayout *flowLayout = [[MyWaterfallFlowLayout alloc] initWithStyle:MyWaterfallFlowLayoutStyle_Horizontal];
    flowLayout.delegate = self;
    flowLayout.minimumLineSpacing = 10.0;
    flowLayout.minimumInteritemSpacing = 5.0;
    flowLayout.columns = 5;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, self.view.frame.size.height - 200) collectionViewLayout:flowLayout];
    collection.dataSource = self;
    collection.delegate = self;
    collection.backgroundColor = [UIColor clearColor];
    collection.showsVerticalScrollIndicator = YES;
    [self.view addSubview:collection];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(CGSize)myCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = self.dataArray[indexPath.item];
    CGFloat width = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    if (width > self.view.frame.size.width - 20) {
        width = self.view.frame.size.width - 20;
    }
    else {
        width += 10;
    }
    return CGSizeMake(width, 30);
}

-(CGFloat)myCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath {
    return 100+arc4random_uniform(150);
}

@end
