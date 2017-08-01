//
//  CSLabelTitleView.m
//  CSLabelTitleView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "CSLabelTitleView.h"

@interface CSLabelTitleView ()

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSNumber *> *titleWidths;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *selectIndicator;
@property (nonatomic, strong) UILabel *lastSelectLabel;
@property (nonatomic, assign) CGFloat totalWith;

@end

@implementation CSLabelTitleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
        [self setupUI];
    }
    return self;
}

- (void)initialization {
    self.titleFont = [UIFont systemFontOfSize:15];
    self.middleMargin = 0.0;
    self.leadingMargin = 0.0;
    self.titleColor = [UIColor darkTextColor];
    self.totalWith = 0.0;
    self.scaleOfLMMargin = 0.618;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.labels = [NSMutableArray new];
    
    self.bottomLine.hidden = YES;
    
    self.contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    
    self.selectIndicator = [UIView new];
    [self.contentView addSubview:self.selectIndicator];
    self.selectIndicator.backgroundColor = [UIColor blueColor];
}

- (void)refreshUI {
    [self clearContainer];
    [self adjustMargin];
    
    CGFloat label_x = self.leadingMargin;
    for (NSInteger i = 0; i < self.titleWidths.count; i++) {
        CGFloat title_w = [self.titleWidths objectAtIndex:i].floatValue;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(label_x, 0, title_w, CGRectGetHeight(self.frame))];
        label_x += title_w + self.middleMargin;
        [self.contentView addSubview:label];
        [self.labels addObject:label];
        label.text = [self.titles objectAtIndex:i];
        [self configWithLabel:label];
        label.tag = i;
    }
    
    self.contentView.contentSize = CGSizeMake(CGRectGetMaxX(self.labels.lastObject.frame) + self.leadingMargin, 0);
    [self selectLabelWithIndex:0 animated:NO];
    [self showBottomLine:YES];
}

- (void)adjustMargin {
    CGFloat originalPlanWith = self.totalWith + self.leadingMargin * 2 + self.middleMargin * (self.titleWidths.count -1);
    if (originalPlanWith - CGRectGetWidth(self.contentView.frame) >= self.leadingMargin) {
        return;
    }
    
    if (self.scaleOfLMMargin < 0) { return; }
    
    CGFloat spaceWith = CGRectGetWidth(self.contentView.frame) - self.totalWith;
    self.middleMargin = spaceWith / ((self.titleWidths.count - 1) + 2 * self.scaleOfLMMargin);
    self.leadingMargin = self.scaleOfLMMargin * self.middleMargin;
}

- (void)clearContainer {
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    [self.labels removeAllObjects];
}

- (void)configWithLabel:(UILabel *)label {
    label.textAlignment = NSTextAlignmentCenter;
    label.font = self.titleFont;
    label.textColor = self.titleColor;
    label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleDidClick:)];
    [label addGestureRecognizer:tag];
    if (self.otherConfig) {
        self.otherConfig(label);
        self.titleColor = label.textColor;
    }
}

- (void)selectLabelWithIndex:(NSInteger)index animated:(BOOL)flag {
    if (index >= self.titleWidths.count || index >= self.labels.count) { return; }
    CGFloat title_w = [self.titleWidths objectAtIndex:index].floatValue;
    UILabel *label = [self.labels objectAtIndex:index];
    CGFloat indicator_h = 2.0;
    CGFloat indicator_x = CGRectGetMidX(label.frame) - title_w * 0.5;
    CGRect rect = CGRectMake(indicator_x, CGRectGetHeight(self.frame) - indicator_h, title_w, indicator_h);
    if (flag) {
        [UIView animateWithDuration:0.25 animations:^{
            self.selectIndicator.frame = rect;
        }];
    } else {
        self.selectIndicator.frame = rect;
    }
    self.lastSelectLabel.textColor = self.titleColor;
    label.textColor = [UIColor blueColor];
    self.lastSelectLabel = label;
    
    [self autoScrollWithIndex:index];
}

- (void)autoScrollWithIndex:(NSInteger)index {
    UILabel *label = [self.labels objectAtIndex:index];
    CGFloat label_center_x = CGRectGetMidX(label.frame);
    CGFloat distance = label_center_x - CGRectGetMidX(self.frame);
    CGFloat scrollDistance = self.leadingMargin;
    if (self.contentView.contentSize.width <= CGRectGetWidth(self.frame)) {
        return;
    }
    if (distance < 0) {
        scrollDistance = 0.0;
    } else {
        for (NSNumber *w in self.titleWidths) {
            scrollDistance += w.floatValue + self.middleMargin;
            if (scrollDistance - distance > 0) {
                CGFloat adjustDistance = w.floatValue + self.middleMargin;
                scrollDistance -= adjustDistance + self.leadingMargin;
                if ((index + 1) < self.labels.count) {
                    UILabel *nextLabel = [self.labels objectAtIndex:(index + 1)];
                    if (CGRectGetMaxX(nextLabel.frame) - scrollDistance > CGRectGetWidth(self.frame)) {
                        scrollDistance += adjustDistance;
                    }
                }
                if ((self.contentView.contentSize.width - scrollDistance) < CGRectGetWidth(self.frame)) {
                    scrollDistance = self.contentView.contentSize.width - CGRectGetWidth(self.frame);
                }
                
                break;
            }
        }
    }
    [self.contentView setContentOffset:CGPointMake(scrollDistance, 0) animated:YES];
}

- (void)titleDidClick:(UITapGestureRecognizer *)tag {
    if (self.labelDidClick) {
        self.labelDidClick(tag.view.tag);
    }
    [self selectLabelWithIndex:tag.view.tag animated:YES];
}


- (void)refreshTitles:(NSArray<NSString *> *)titles {
    if (titles.count <= 0) { return; }
    self.totalWith = 0.0;
    self.titles = titles;
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:titles.count];
    CGSize maxSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    for (NSString *str in titles) {
        CGSize minSize = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.titleFont} context:nil].size;
        CGFloat w = ceil(minSize.width);
        [mArr addObject:@(w)];
        self.totalWith += w;
    }
    self.titleWidths = mArr.copy;
    
    [self refreshUI];
}

- (void)showBottomLine:(BOOL)flag {
    self.bottomLine.hidden = !flag;
    [self bringSubviewToFront:self.selectIndicator];
}

#pragma mark  -  setter / getter
- (UIView *)bottomLine {
    if (!_bottomLine) {
        CGFloat line_h = 0.5;
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - line_h, CGRectGetWidth(self.frame), line_h)];
        [self addSubview:_bottomLine];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:(230 / 255) alpha:1];
    }
    return _bottomLine;
}

@end
