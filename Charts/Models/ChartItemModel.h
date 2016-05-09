//
//  ChartItemModel.h
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartItemModel : NSObject
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, copy) NSString* textDescription;
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor*)color;
+ (instancetype)dataItemWithValue:(CGFloat)value color:(UIColor*)color description:(NSString*)textDescription;

@end
