//
//  CSCollectionViewCell.m
//  CSLabelTitleView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "CSCollectionViewCell.h"

static NSString * const CSTableViewCellIdentifier = @"CSTableViewCellIdentifier";
static NSInteger listCount = 30;

@interface CSCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *dataList;

@end

@implementation CSCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark  -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CSTableViewCellIdentifier forIndexPath:indexPath];
    NSString *text = @"";
    if (indexPath.row == 0) {
        text = @"------------> 加一栏 ";
    } else if (indexPath.row == 1) {
        text = @"------------> 减一栏 ";
    } else {
        text = [NSString stringWithFormat:@"---->%@",[self.dataList objectAtIndex:indexPath.row]];
    }
    
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectRowBlock) {
        self.didSelectRowBlock(indexPath.row, self.dataList);
    }
}

#pragma mark  -  action
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.contentView.bounds];
    self.tableView = tableView;
    [self.contentView addSubview:tableView];
    tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CSTableViewCellIdentifier];
}

#pragma mark  -  setter / getter
- (void)setLabelTitle:(NSString *)labelTitle {
    _labelTitle = labelTitle;
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:listCount];
    for (NSInteger i = 0; i < listCount; i++) {
        [mArr addObject:labelTitle];
    }
    self.dataList = mArr.copy;
    [self.tableView reloadData];
}

@end
