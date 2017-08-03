//
//  CSChannelLabelView.m
//  CSChannelLabelView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import "CSChannelLabelView.h"

@interface CSChannelLabelView ()

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSNumber *> *titleWidths;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIView *selectIndicator;
@property (nonatomic, strong) UILabel *lastSelectLabel;
@property (nonatomic, assign) CGFloat totalWith;
@property (nonatomic, assign) CGFloat middleMargin_tuning;
@property (nonatomic, assign) CGFloat leadingMargin_tuning;
@property (nonatomic, assign) NSInteger lastIndex;

@end

@implementation CSChannelLabelView

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
    self.scaleOfLMMargin = 0.618;
    self.selectColor = [UIColor blueColor];
    self.adjustWidth4Indicator = 0.0;
    self.indicatorAnimationType = CSIndicatorAnimationTypeSlide;
}

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.labels = [NSMutableArray new];
    
    self.bottomLine.hidden = NO;
    
    self.contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:self.contentView];
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    
    self.selectIndicator = [UIView new];
    [self.contentView addSubview:self.selectIndicator];
}

- (void)refreshUI {
    [self clearContainer];
    [self adjustMargin];
    
    CGFloat label_x = self.leadingMargin_tuning;
    for (NSInteger i = 0; i < self.titleWidths.count; i++) {
        CGFloat title_w = [self.titleWidths objectAtIndex:i].floatValue;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(label_x, 0, title_w, CGRectGetHeight(self.frame))];
        label_x += title_w + self.middleMargin_tuning;
        [self.contentView addSubview:label];
        [self.labels addObject:label];
        label.text = [self.titles objectAtIndex:i];
        [self configWithLabel:label];
        label.tag = i;
    }
    
    self.contentView.contentSize = CGSizeMake(CGRectGetMaxX(self.labels.lastObject.frame) + self.leadingMargin_tuning, 0);
    [self selectChannelWithIndex:0 animationType:CSIndicatorAnimationTypeNone];
    if (self.itemDidClick) { self.itemDidClick(0); }
    [self.contentView bringSubviewToFront:self.selectIndicator];
}

- (void)adjustMargin {
    self.leadingMargin_tuning = self.leadingMargin;
    self.middleMargin_tuning = self.middleMargin;
    CGFloat originalPlanWith = self.totalWith + self.leadingMargin * 2 + self.middleMargin * (self.titleWidths.count -1);
    if (originalPlanWith - CGRectGetWidth(self.contentView.frame) >= self.leadingMargin) {
        return;
    }
    
    if (self.scaleOfLMMargin < 0) { return; }
    
    CGFloat spaceWith = CGRectGetWidth(self.contentView.frame) - self.totalWith;
    self.middleMargin_tuning = spaceWith / ((self.titleWidths.count - 1) + 2 * self.scaleOfLMMargin);
    self.leadingMargin_tuning = self.scaleOfLMMargin * self.middleMargin_tuning;
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

- (void)selectChannelWithIndex:(NSInteger)index animationType:(CSIndicatorAnimationType)type {
    if (index >= self.titleWidths.count || index >= self.labels.count) { return; }
    
    [self refreshIndicatorWithIndex:index animationType:type];
    
    UILabel *label = [self.labels objectAtIndex:index];
    
    self.lastSelectLabel.textColor = self.titleColor;
    label.textColor = self.selectColor;
    self.lastSelectLabel = label;
    self.selectIndicator.backgroundColor = self.selectColor;
    
    [self autoScrollWithIndex:index];
}

- (void)refreshIndicatorWithIndex:(NSInteger)index animationType:(CSIndicatorAnimationType)type {

    CGFloat title_w = [self.titleWidths objectAtIndex:index].floatValue;
    UILabel *label = [self.labels objectAtIndex:index];

    CGFloat indicator_h = 2.0;
    CGFloat indicator_w = title_w + self.adjustWidth4Indicator;
    CGFloat indicator_y = CGRectGetHeight(self.frame) - indicator_h;
    CGFloat indicator_x = CGRectGetMidX(label.frame) - indicator_w * 0.5;
    CGRect rect = CGRectMake(indicator_x, indicator_y, indicator_w, indicator_h);
    
    if (type == CSIndicatorAnimationTypeRubber) {
        CGFloat scale = 0.618;
        self.selectIndicator.frame = rect;
        self.selectIndicator.transform = CGAffineTransformMakeScale(scale, scale);
        label.transform = CGAffineTransformMakeScale(scale, scale);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionTransitionNone animations:^{
            label.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.selectIndicator.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
        return;
    }
    
    if (self.lastIndex == index) { return; }
    self.lastIndex = index;
    
    if (type == CSIndicatorAnimationTypeCrawl) {
        CGFloat indicator_x_origin = CGRectGetMinX(self.selectIndicator.frame);
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = self.selectIndicator.frame;
            if (CGRectGetMinX(label.frame) >= indicator_x_origin) {
                CGFloat indicator_w_max = CGRectGetMaxX(label.frame) + self.adjustWidth4Indicator - indicator_x_origin;
                rect = CGRectMake(indicator_x_origin, indicator_y, indicator_w_max, indicator_h);
            } else {
                CGFloat indicator_w_max = CGRectGetMaxX(self.selectIndicator.frame) - CGRectGetMinX(label.frame) + self.adjustWidth4Indicator;
                rect = CGRectMake(indicator_x, indicator_y, indicator_w_max, indicator_h);
            }
            self.selectIndicator.frame = rect;
        } completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.selectIndicator.frame = rect;
                }];
            }
        }];
        return;
    }
    
    if (type == CSIndicatorAnimationTypeSlide) {
        [UIView animateWithDuration:0.25 animations:^{
            self.selectIndicator.frame = rect;
        }];
        return;
    }
    
    self.selectIndicator.frame = rect;
}

- (void)autoScrollWithIndex:(NSInteger)index {
    UILabel *label = [self.labels objectAtIndex:index];
    CGFloat label_center_x = CGRectGetMidX(label.frame);
    CGFloat distance = label_center_x - CGRectGetMidX(self.frame);
    CGFloat scrollDistance = self.leadingMargin_tuning;
    if (self.contentView.contentSize.width <= CGRectGetWidth(self.frame)) {
        return;
    }
    if (distance < 0) {
        scrollDistance = 0.0;
    } else {
        for (NSNumber *w in self.titleWidths) {
            scrollDistance += w.floatValue + self.middleMargin_tuning;
            if (scrollDistance - distance > 0) {
                CGFloat adjustDistance = w.floatValue + self.middleMargin_tuning;
                scrollDistance -= adjustDistance + self.leadingMargin_tuning;
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
    if (self.itemDidClick) {
        self.itemDidClick(tag.view.tag);
    }
    [self selectChannelWithIndex:tag.view.tag animationType:self.indicatorAnimationType];
}


- (void)refreshTitles:(NSArray<NSString *> *)titles {
    if (titles.count <= 0) { return; }
    self.lastIndex = -1;
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

#pragma mark  -  setter / getter
- (UIView *)bottomLine {
    if (!_bottomLine) {
        CGFloat line_h = 0.5;
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - line_h, CGRectGetWidth(self.frame), line_h)];
        [self addSubview:_bottomLine];
        _bottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return _bottomLine;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;
    self.bottomLine.backgroundColor = separatorColor;
}

- (void)setShowSeparator:(BOOL)showSeparator {
    _showSeparator = showSeparator;
    self.bottomLine.hidden = !showSeparator;
}


@end
