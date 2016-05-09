//
//  ChartViewDelegate.h
//  Charts
//
//  Created by chengxun on 16/5/9.
//  Copyright © 2016年 chengxun. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol ChartViewDelegate <NSObject>
@optional
- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex;
- (void)didUnselectPieItem;
@end