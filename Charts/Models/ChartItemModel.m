//
//  ChartItemModel.m
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import "ChartItemModel.h"

@implementation ChartItemModel
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor*)color
{
    ChartItemModel* model = [ChartItemModel new];
    model.value = value;
    model.color = color;
    return model;
}

+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor*)color description:(NSString*)textDescription
{
    ChartItemModel* model = [ChartItemModel dataItemWithValue:value color:color];
    model.textDescription = textDescription;
    return model;
}

- (void)setValue:(CGFloat)value
{
    NSAssert(value >= 0, @"value should >=0");
    if (value != _value) {
        _value = value;
    }
}

@end
