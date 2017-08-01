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
@property (nonatomic, strong) NSArray<NSString *> *labelTitles;


@end

@implementation ViewController



// -------------------- CSLabelTitleView --------------------

- (void)addLabelTitleView {
    CSLabelTitleView *labelTitleView = [[CSLabelTitleView alloc] initWithFrame:CGRectMake(0, 64, kScreeSize.width, channelTitleH)];
    self.labelTitleView = labelTitleView;
    [self.view addSubview:labelTitleView];
    labelTitleView.leadingMargin = 15;
    labelTitleView.middleMargin = 35;
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
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger idx = (scrollView.contentOffset.x + kScreeSize.width * 0.5) / kScreeSize.width;
    [self.labelTitleView selectLabelWithIndex:idx animated:YES];
}

#pragma mark  -  action
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
        NSIndexPath *idxPath = [NSIndexPath indexPathForItem:index inSection:0];
        [strongSelf.contentView scrollToItemAtIndexPath:idxPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    };
}

#pragma mark  -  setter / getter
- (NSArray<NSString *> *)labelTitles {
    if (!_labelTitles) {
        _labelTitles = @[@"label01", @"label02", @"label03", @"label04"];
    }
    return _labelTitles;
}


@end

