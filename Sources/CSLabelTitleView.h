//
//  CSLabelTitleView.h
//  CSLabelTitleView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//
// https://github.com/JoslynWu/CSLabelTitleView-OC
//

#import <UIKit/UIKit.h>

@interface CSLabelTitleView : UIView

@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, assign) CGFloat middleMargin;
@property (nonatomic, assign) CGFloat leadingMargin;
@property (nonatomic, assign) CGFloat scaleOfLMMargin; // 头（或尾）间距与中间间距的比例。item较少时有效。
@property (nonatomic, copy) void(^otherConfig)(UILabel *label);

@property (nonatomic, copy) void(^labelDidClick)(NSInteger index);

- (void)refreshTitles:(NSArray<NSString *> *)titles;

- (void)selectLabelWithIndex:(NSInteger)index animated:(BOOL)flag;

@end
