//
//  JFQuantityView.m
//  CJF
//
//  Created by cjf on 2017/6/5.
//  Copyright © 2017年 Jinfei Chen. All rights reserved.
//

#import "JFQuantityView.h"

#import "UIView+JFExtension.h"

static CGFloat PADDING = 8;
static CGFloat LINEWIDTH = 2;

@interface JFQuantityView ()<UITextFieldDelegate>{
    UITextField *_inputField; /**< 中间输入框 */
    UIButton *_minusButton;   /**< 减按钮 */
    UIButton *_plusButton;    /**< 加按钮 */
}

@end

@implementation JFQuantityView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // 设置初始值
        _min = 0;
        _max = CGFLOAT_MAX;
        
        [self buildView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置初始值
        _min = 0;
        _max = CGFLOAT_MAX;
        
        [self buildView];
    }
    return self;
}

#pragma mark - Action

- (void)plusAction: (id)sender {
    
    if (_inputField.text.integerValue == _max) {
        
        if ([self.delegate respondsToSelector:@selector(numberHasBeenMaximized:)]) {
            
            [self.delegate numberHasBeenMaximized:self];
        }
        
        return;
    }
    
    if (_inputField.text.integerValue < _max) {
        
        _inputField.text = [NSString stringWithFormat:@"%ld", (long)(_inputField.text.integerValue == _max ? _max : _inputField.text.integerValue + 1)];
        _number = _inputField.text.integerValue;
        
        [self updateButtonUI];
        
        if ([self.delegate respondsToSelector:@selector(numberDidUpdate:)]) {
            
            [self.delegate numberDidUpdate:self];
        }
    }
}

- (void)minusAction: (id)sender {
    
    if (_inputField.text.integerValue == _min) {
        
        if ([self.delegate respondsToSelector:@selector(numberHasBeenMinimized:)]) {
            
            [self.delegate numberHasBeenMinimized:self];
        }
        
        return;
    }
    
    if (_inputField.text.integerValue > _min) {
        
        _inputField.text = [NSString stringWithFormat:@"%ld", (long)(_inputField.text.integerValue == _min ? _min : _inputField.text.integerValue - 1)];
        _number = _inputField.text.integerValue;
        
        [self updateButtonUI];
        
        if ([self.delegate respondsToSelector:@selector(numberDidUpdate:)]) {
            
            [self.delegate numberDidUpdate:self];
        }
    }
}

#pragma mark - Setter

- (void)setMin:(NSInteger)min {
    _min = min;
    
    if (!_number) {
        _inputField.text = [NSString stringWithFormat:@"%ld", (long)_min];
    }
}

- (void)setNumber:(NSInteger)number {
    _number = number;
    
    _inputField.text = [NSString stringWithFormat:@"%ld", (long)_number];
    
    [self updateButtonUI];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateItemFrame];
}

#pragma mark - Private Method

- (void)buildView {
    
    // 配置小按钮
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _minusButton.frame = CGRectMake(0, 0, self.height, self.height);
    [self addSubview:_minusButton];
    
    [_minusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:NO Normal:YES]] forState:UIControlStateNormal];
    [_minusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:NO Normal:NO]] forState:UIControlStateHighlighted];
    
    [_minusButton addTarget:self action:@selector(minusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 配置中间输入控件
    _inputField = [[UITextField alloc] initWithFrame:CGRectMake(self.height+1, 0, self.width-2*self.height-2*1, self.height)];
    [self addSubview:_inputField];
    _inputField.delegate = self;
    _inputField.text = [NSString stringWithFormat:@"%ld", (long)_min];
    _inputField.textAlignment = NSTextAlignmentCenter;
    _inputField.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.0];
    _inputField.keyboardType = UIKeyboardTypeNumberPad;
    _inputField.textColor = [UIColor grayColor];
    
    // 配置加按钮
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _plusButton.frame = CGRectMake(self.width - self.height, 0, self.height, self.height);
    [self addSubview:_plusButton];
    
    [_plusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:YES Normal:YES]] forState:UIControlStateNormal];
    [_plusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:YES Normal:NO]] forState:UIControlStateHighlighted];
    
    [_plusButton addTarget:self action:@selector(plusAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 更新UI状态
    [self updateButtonUI];
}

- (void)updateItemFrame {
    
    _minusButton.frame = CGRectMake(0, 0, self.height, self.height);
    _inputField.frame = CGRectMake(self.height+1, 0, self.width-2*self.height-2*1, self.height);
    _plusButton.frame = CGRectMake(self.width - self.height, 0, self.height, self.height);
}

/**
 创建加或减按钮符号view

 @param isPlus 是否为加号
 @param isNormal 是否为普通状态
 @return 符号view
 */
- (UIView *)plusminusViewWithPlus: (BOOL)isPlus Normal: (BOOL)isNormal {
    
    CGFloat buttonWidth = self.height;
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
    UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(PADDING, (buttonWidth-LINEWIDTH)/2, buttonWidth-2*PADDING, LINEWIDTH)];
    UIView *verticalView = [[UIView alloc] initWithFrame:CGRectMake((buttonWidth-LINEWIDTH)/2, PADDING, LINEWIDTH, buttonWidth-2*PADDING)];
    
    if (isPlus) {
        
        [contentView addSubview:horizontalView];
        [contentView addSubview:verticalView];
    }
    else {
        
        [contentView addSubview:horizontalView];
    }
    
    if (isNormal) {
        
        contentView.backgroundColor = [UIColor colorWithWhite:0.945 alpha:1.0];
        horizontalView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        verticalView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
    else {
        
        contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        horizontalView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        verticalView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    }
    
    return contentView;
}

/**
 UIView生成图片对象

 @param view view对象
 @return 图片对象
 */
- (UIImage *)imageFromView: (UIView *)view {
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, view.layer.contentsScale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)updateButtonUI {
    
    if (_inputField.text.length != 0 && _inputField.text.integerValue <= _min) {
        
        [_minusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:NO Normal:NO]] forState:UIControlStateNormal];
    }
    else {
        
        [_minusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:NO Normal:YES]] forState:UIControlStateNormal];
    }
    
    if (_inputField.text.length != 0 && _inputField.text.integerValue >= _max) {
        
        [_plusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:YES Normal:NO]] forState:UIControlStateNormal];
    }
    else {
        
        [_plusButton setBackgroundImage:[self imageFromView:[self plusminusViewWithPlus:YES Normal:YES]] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate 

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    _number = textField.text.integerValue;
    [self updateButtonUI];
    
    if ([self.delegate respondsToSelector:@selector(numberDidUpdate:)]) {
        
        [self.delegate numberDidUpdate:self];
    }
}

@end



