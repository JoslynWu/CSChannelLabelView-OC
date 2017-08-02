//
//  ViewController.m
//  CSLabelTitleView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "ViewController.h"
#import "CSLabelTitleView.h"
#import "CSCollectionViewCell.h"

#define kScreeSize ([UIScreen mainScreen].bounds.size)
static NSString * const CSViewControllerControllerCellId = @"CSViewControllerControllerCellId";
static const CGFloat channelTitleH = 39.0;

@interface ViewController()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) CSLabelTitleView *labelTitleView;
@property (nonatomic, strong) UICollectionView *contentView;
@property (nonatomic, strong) NSMutableArray<NSString *> *labelTitles;
@property (nonatomic, assign) BOOL isLabelTitleDidClick;


@end

@implementation ViewController



// -------------------- CSLabelTitleView --------------------

- (void)addLabelTitleView {
    CSLabelTitleView *labelTitleView = [[CSLabelTitleView alloc] initWithFrame:CGRectMake(0, 64, kScreeSize.width, channelTitleH)];
    self.labelTitleView = labelTitleView;
    [self.view addSubview:labelTitleView];
    labelTitleView.leadingMargin = 15;
    labelTitleView.middleMargin = 35;
    labelTitleView.indicatorAnimationType = CSIndicatorAnimationTypeCrawl;
    [labelTitleView refreshTitles:self.labelTitles];
}

// -------------------- CSLabelTitleView --------------------


















#pragma mark  -  lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CSLabelTitleView";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  -  UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.labelTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CSCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:CSViewControllerControllerCellId forIndexPath:indexPath];
    cell.labelTitle = [self.labelTitles objectAtIndex:indexPath.item];
    __weak typeof(self) weakSelf = self;
    cell.didSelectRowBlock = ^(NSInteger index, NSArray *data) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf updateLabelTitleWithIndex:index];
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.isLabelTitleDidClick) {
        self.isLabelTitleDidClick = NO;
        return;
    }
    NSInteger idx = (scrollView.contentOffset.x + kScreeSize.width * 0.5) / kScreeSize.width;
    [self.labelTitleView selectLabelWithIndex:idx animationType:CSIndicatorAnimationTypeCrawl];
}

#pragma mark  -  action
- (void)updateLabelTitleWithIndex:(NSInteger)idx {
    if (idx > 2) { return; }
    if (idx == 0) {
        [self.labelTitles addObject:[NSString stringWithFormat:@"label%02zd",self.labelTitles.count]];
    } else if (idx == 1) {
        if (self.labelTitles.count <= 1) { return; }
        [self.labelTitles removeLastObject];
    } else {
        NSMutableArray<NSString *> *mArr = [NSMutableArray arrayWithCapacity:self.labelTitles.count];
        [self.labelTitles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mArr addObject:[self randomStringWithMaxCharCount:8]];
        }];
        self.labelTitles = mArr;
    }
    
    [self.labelTitleView refreshTitles:self.labelTitles];
    [self.contentView reloadData];
}

- (NSString *)randomStringWithMaxCharCount:(unsigned int)n {
    NSString *chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSUInteger randomCountN = arc4random_uniform(n) + 1;
    NSMutableString *mStr = [NSMutableString stringWithCapacity:randomCountN];
    do {
        for (NSInteger i = 0; i < randomCountN; i++) {
            NSUInteger randomIdx = arc4random_uniform((uint32_t)(chars.length));
            NSString *s = [chars substringWithRange:NSMakeRange(randomIdx, 1)];
            [mStr appendString:s];
        }
    } while (mStr.length <= 0);
    return mStr.copy;
}

- (void)setupUI {
    [self addLabelTitleView];
    
    CGFloat contentView_top = channelTitleH + 64;
    CGRect rect = CGRectMake(0, contentView_top, kScreeSize.width, kScreeSize.height - contentView_top);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = rect.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *contentView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:flowLayout];
    self.contentView = contentView;
    [self.view addSubview:contentView];
    contentView.dataSource = self;
    contentView.delegate = self;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.pagingEnabled = YES;
    [contentView registerClass:[CSCollectionViewCell class] forCellWithReuseIdentifier:CSViewControllerControllerCellId];
    
    __weak typeof(self) weakSelf = self;
    self.labelTitleView.labelDidClick = ^(NSInteger index) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (index >= strongSelf.labelTitles.count) { return; }
        strongSelf.isLabelTitleDidClick = YES;
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:index inSection:0];
        [strongSelf.contentView scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    };
}

#pragma mark  -  setter / getter
- (NSMutableArray<NSString *> *)labelTitles {
    if (!_labelTitles) {
        _labelTitles = [NSMutableArray arrayWithObjects:@"label00", @"label01", @"label02", @"label03", nil];
    }
    return _labelTitles;
}


@end

