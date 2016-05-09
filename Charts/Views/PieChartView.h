//
//  PieChartView.h
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartViewDelegate.h"
@interface PieChartView : UIView
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
@property (nonatomic, readonly,strong) NSArray	*items;
@property (nonatomic,assign)CGFloat outterCircleRadius;
@property (nonatomic,assign)CGFloat innerCircleRadius;

@end
