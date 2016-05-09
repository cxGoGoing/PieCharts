//
//  PieChartBottomCell.m
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import "PieChartBottomCell.h"
#import "ChartItemModel.h"
#import <PureLayout.h>
@interface PieChartBottomCell()
@property (nonatomic,strong)UIImageView * titleImageView;
@property (nonatomic,strong)UILabel * titleLabel;
@end
@implementation PieChartBottomCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUpUI];
    }
    return self;
}

- (UIImageView*)titleImageView{
    if(!_titleImageView){
        _titleImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_titleImageView];
    }
    return _titleImageView;
}

- (UILabel*)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)setUpUI{
    [self.titleImageView autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [self.titleImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];

    
}

- (void)setModel:(ChartItemModel *)model{
    _model = model;
    self.titleImageView.backgroundColor = model.color;
}

@end
