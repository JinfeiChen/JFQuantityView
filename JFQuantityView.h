//
//  JFQuantityView.h
//  CJF - 自定义数量选择视图控件
//
//  Created by cjf on 2017/6/5.
//  Copyright © 2017年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JFQuantityView;
@protocol JFQuantityViewDelegate <NSObject>

- (void)numberDidUpdate: (JFQuantityView *)quantityView;        /**< 数值发生改变 */

@optional
- (void)numberHasBeenMinimized: (JFQuantityView *)quantityView; /**< 数值达到最小值 */
- (void)numberHasBeenMaximized: (JFQuantityView *)quantityView; /**< 数值达到最大值 */

@end

@interface JFQuantityView : UIView

@property (nonatomic, assign) NSInteger max;    /**< 最大数值 */
@property (nonatomic, assign) NSInteger min;    /**< 最小数值 */
@property (nonatomic, assign) NSInteger number; /**< 数值 */

@property (nonatomic, weak) id<JFQuantityViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
