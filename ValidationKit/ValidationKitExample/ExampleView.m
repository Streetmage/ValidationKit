// The MIT License (MIT)
//
// Copyright (c) 2015 INOSTUDIO
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ExampleView.h"

#define ExampleViewBorderColor [UIColor lightGrayColor]

static NSUInteger const ExampleViewBorderWidth = 1.0f;
static NSUInteger const ExampleViewBorderRadius = 5.0f;

@interface ExampleView ()

@property (nonatomic, readonly) UIView *validationResultsLabelHolder;
@property (nonatomic, readonly) UITextView *validationResultsTextView;

@end

@implementation ExampleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _scrollView = [[UIScrollView alloc] init];
        [self addSubview:_scrollView];
        
        _emailTextField = [[VLDTextField alloc] initWithValidatorTypeMask:VLDTextFieldEmailValidator];
        [_emailTextField setPlaceholder:@"Email"];
        [_scrollView addSubview:_emailTextField];
        
        _passwordField = [[VLDTextField alloc] initWithValidatorTypeMask:VLDTextFieldStrongPasswordValidator];
        [_passwordField setPlaceholder:@"Password"];
        [_passwordField setSecureTextEntry:YES];
        [_passwordField setCharactersLimitAndUseForCompare:10];
        [_scrollView addSubview:_passwordField];
        
        VLDBoundaryNumberValidator *boundaryNumberValidator = [[VLDBoundaryNumberValidator alloc] init];
        [boundaryNumberValidator setLowBoundary:10.0f];
        [boundaryNumberValidator setTopBoundary:100.5f];
        
        _numberTextField = [[VLDTextField alloc] init];
        [_numberTextField setPlaceholder:@"A number from 10 to 100.5"];
        [_numberTextField setKeyboardType:UIKeyboardTypeNumberPad];
        [_numberTextField setTextValidators:@[boundaryNumberValidator]];
        [_scrollView addSubview:_numberTextField];
        
        VLDBoundaryCharactersValidator *boundaryCharactersValidator = [[VLDBoundaryCharactersValidator alloc] init];
        [boundaryCharactersValidator setLowBoundary:10];
        
        _textView = [[VLDTextView alloc] init];
        [_textView setCharactersLimitAndUseForCompare:20];
        [_textView setTextValidators:@[boundaryCharactersValidator]];
        [_scrollView addSubview:_textView];
        
        _validateButton = [[UIButton alloc] init];
        [_validateButton setTitle:@"Validate" forState:UIControlStateNormal];
        [_validateButton setBackgroundColor:ExampleViewBorderColor];
        [_validateButton.layer setCornerRadius:ExampleViewBorderRadius];
        [_scrollView addSubview:_validateButton];
        
        _validationResultsLabelHolder = [[UIView alloc] init];
        [_scrollView addSubview:_validationResultsLabelHolder];
        
        _validationResultsTextView = [[UITextView alloc] init];
        [_validationResultsTextView setText:@"Validation results"];
        [_validationResultsTextView setEditable:NO];
        [_validationResultsLabelHolder addSubview:_validationResultsTextView];
        
        [self addBorderToView:_emailTextField];
        [self addBorderToView:_passwordField];
        [self addBorderToView:_numberTextField];
        [self addBorderToView:_textView];
        [self addBorderToView:_validationResultsLabelHolder];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    UIEdgeInsets viewPadding = UIEdgeInsetsMake(20.0f, 5.0f, 20.0f, 5.0f);
    
    CGFloat textFieldWidth = self.frame.size.width - viewPadding.left - viewPadding.right;
    CGFloat textFieldHeight = 30.0f;
    
    [self.emailTextField setFrame:CGRectMake(viewPadding.left,
                                             viewPadding.top + 10.0f,
                                             textFieldWidth,
                                             textFieldHeight)];
    
    [self.passwordField setFrame:CGRectMake(viewPadding.left,
                                            CGRectGetMaxY(self.emailTextField.frame) + viewPadding.top,
                                            textFieldWidth,
                                            textFieldHeight)];
    
    [self.numberTextField setFrame:CGRectMake(viewPadding.left,
                                              CGRectGetMaxY(self.passwordField.frame) + viewPadding.top,
                                              textFieldWidth,
                                              textFieldHeight)];
    
    CGFloat textViewHeight = 100.0f;
    
    [self.textView setFrame:CGRectMake(viewPadding.left,
                                       CGRectGetMaxY(self.numberTextField.frame) + viewPadding.top,
                                       textFieldWidth,
                                       textViewHeight)];
    
    [self.validateButton setFrame:CGRectMake(viewPadding.left,
                                             CGRectGetMaxY(self.textView.frame) + viewPadding.top,
                                             textFieldWidth,
                                             textFieldHeight)];
    
    CGFloat validationResultsLabelHolderHeight = 200.0f;
    
    [self.validationResultsLabelHolder setFrame:CGRectMake(viewPadding.left,
                                                           CGRectGetMaxY(self.validateButton.frame) + viewPadding.top,
                                                           textFieldWidth,
                                                           validationResultsLabelHolderHeight)];
    
    UIEdgeInsets validationResultsTextViewMargins = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    [self.validationResultsTextView setFrame:UIEdgeInsetsInsetRect(self.validationResultsLabelHolder.bounds, validationResultsTextViewMargins)];

    [self.scrollView setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(0.0f, 0.0f, _keyboardBottomMargin, 0.0f))];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,
                                               CGRectGetMaxY(self.validationResultsLabelHolder.frame) + viewPadding.bottom)];
    
}

#pragma mark - Accessors

- (void)setKeyboardBottomMargin:(CGFloat)keyboardBottomMargin {
    _keyboardBottomMargin = keyboardBottomMargin;
    [self setNeedsLayout];
}

#pragma mark - Public Methods

- (void)setValidationResultText:(NSString *)text {
    [_validationResultsTextView setText:[text copy]];
}

#pragma mark - Private Methods

- (void)addBorderToView:(UIView *)view {
    [view.layer setBorderColor:ExampleViewBorderColor.CGColor];
    [view.layer setBorderWidth:ExampleViewBorderWidth];
    [view.layer setCornerRadius:ExampleViewBorderRadius];
}

@end
