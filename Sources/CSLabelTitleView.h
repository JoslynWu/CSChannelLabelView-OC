//
//  CSLabelTitleView.h
//  CSLabelTitleView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//
// 一个轻量的文字频道View。多个频道可滚动，少量频道可适配间距。
// https://github.com/JoslynWu/CSLabelTitleView-OC
//

#import <UIKit/UIKit.h>

@interface CSLabelTitleView : UIView

/** label点击回调 */
@property (nonatomic, copy) void(^labelDidClick)(NSInteger index);

/** 刷新titles。需要最后调用 */
- (void)refreshTitles:(NSArray<NSString *> *)titles;



/** 主动滚动到指定label。animated指定是否带滚动动画。一般代码在代码触发时调用 */
- (void)selectLabelWithIndex:(NSInteger)index animated:(BOOL)flag;


/** 两个label之前的间距，默认0.0 */
@property (nonatomic, assign) CGFloat middleMargin;

/** 第一个label与边缘的距离（头间距），默认0.0。尾间距默认相等 */
@property (nonatomic, assign) CGFloat leadingMargin;

/** 头（或尾）间距与中间间距的比例。当用指定间距计算出的总长度减去滚动容器的宽度小于一个leadingMargin时有效，默认为0.618。*/
@property (nonatomic, assign) CGFloat scaleOfLMMargin;

/** 选择指示器的调整宽度（相对于文字宽度的单边调整距离）。默认0.0 */
@property (nonatomic, assign) CGFloat adjustWidth4Indicator;



/** 默认15 */
@property (nonatomic, strong) UIFont *titleFont;

/** 默认darkTextColor */
@property (nonatomic, strong) UIColor *titleColor;

/** 选中时的颜色，默认指示器和文字颜色相同，blueColor */
@property (nonatomic, strong) UIColor *selectColor;

/** label的其他设置 */
@property (nonatomic, copy) void(^otherConfig)(UILabel *label);



/** 底部分割线的颜色，默认#f3f2f3 */
@property (nonatomic, strong) UIColor *separatorColor;

/** 底部分割线是否显示，默认YES */
@property (nonatomic, assign, getter=isShowSeparator) BOOL showSeparator;


@end
