//
//  CSCollectionViewCell.h
//  CSLabelTitleView
//
//  Created by Joslyn Wu on 2017/8/1.
//  Copyright © 2017年 joslyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void(^didSelectRowBlock)(NSInteger index, NSArray *data);

@property (nonatomic, strong) NSString *labelTitle;

@end
