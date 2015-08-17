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

#import "ExampleViewController.h"
#import "ExampleView.h"

#import <ValidationKit/ValidationKit.h>

@interface ExampleViewController () <VLDTextFieldDelegate, VLDTextViewDelegate>

@property (nonatomic, strong) ExampleView *screenView;

@end

@implementation ExampleViewController

#pragma mark - Initialization Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // You can do setting global VLD constants just after application finished launching
        VLDSetDefaultTotalDataLimit(20 * VLD_MB);
        VLDSetStringDefaultLengthLimit(512);
        VLDSetDataDefaultLengthLimit(10 * VLD_MB);
        VLDSetTextFieldDefaultCharactersLimit(256);
        VLDSetTextViewDefaultCharactersLimit(512);
    }
    
    return self;
}

- (void)loadView {
    _screenView = [[ExampleView alloc] init];
    self.view = _screenView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_screenView.emailTextField setDelegate:self];
    [_screenView.passwordField setDelegate:self];
    [_screenView.numberTextField setDelegate:self];
    
    [_screenView.textView setDelegate:self];
    
    [_screenView.validateButton addTarget:self
                                   action:@selector(onValidateButtonClick:)
                         forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - VLDTextFieldDelegate Methods

- (void)textFieldDidReachCharactersLimit:(VLDTextField *)textField {
    if (textField == _screenView.emailTextField) {
        [self showAlertWithMessage:@"Email is too long"];
    }
    else if (textField == _screenView.passwordField) {
        [self showAlertWithMessage:@"Password is too long"];
    }
    else if (textField == _screenView.numberTextField) {
        [self showAlertWithMessage:@"Number is too long"];
    }
}

#pragma mark - VLDTextViewDelegate Methods

- (void)textViewDidReachCharactersLimit:(VLDTextView *)textField {
    [self showAlertWithMessage:@"Text should contain at least 10 characters"];
}

#pragma mark - Private Methods

- (void)onValidateButtonClick:(UIButton *)sender {
    NSMutableString *validationErrorMessageAccum = [NSMutableString string];
    if (![_screenView.emailTextField isValidText]) {
        [validationErrorMessageAccum appendString:@"Email is not valid\n"];
    }
    if (![_screenView.passwordField isValidText]) {
        [validationErrorMessageAccum appendString:@"Password is not valid\n"];
    }
    if (![_screenView.numberTextField isValidText]) {
        [validationErrorMessageAccum appendString:@"Number is not valid\n"];
    }
    if (![_screenView.textView isValidText]) {
        [validationErrorMessageAccum appendString:@"Text is not valid, should be at least 10 characters\n"];
    }
    [_screenView setValidationResultText:validationErrorMessageAccum];
}


- (void)showAlertWithMessage:(NSString *)alertMessage {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                        message:alertMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Keyboard Helpers

- (void)keyboardDidShow:(NSNotification *)notification {
    CGRect keyboardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardFrameConverted = [self.view convertRect:keyboardRect
                                                  fromView:self.view.window];
    [_screenView setKeyboardBottomMargin:keyboardFrameConverted.size.height];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [_screenView setKeyboardBottomMargin:0.0f];
}

@end
