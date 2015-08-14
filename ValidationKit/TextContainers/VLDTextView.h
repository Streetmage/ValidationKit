// The MIT License (MIT)
//
// Copyright (c) 2015 Inostudio Solutions
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

#import <UIKit/UIKit.h>

#define VLDSetTextViewDefaultCharactersLimit(limit) [VLDTextField setDefaultCharactersLimit:limit]

@class VLDTextView;

@protocol VLDTextViewDelegate <UITextViewDelegate>

@optional

- (void)textViewDidReachCharactersLimit:(VLDTextView *)textView;

@end

@interface VLDTextView : UITextView

// Default set to YES and use static variable
@property (nonatomic, assign) BOOL usesDefaultCharatersLimit;

// Don't forget to change |usesDefaultCharatersLimit| to NO
// to start using |charactersLimit| field
@property (nonatomic, assign) NSUInteger charactersLimit;

// Checks if text of |VLDTextView| is empty
@property (nonatomic, readonly, getter = isEmpty) BOOL empty;

// Validator objects should conform to |VLDTextValidator| protocol
@property (nonatomic, copy) NSArray *textValidators;
@property (nonatomic, readonly, getter = isValidText) BOOL validText;

@property (nonatomic, weak) id <VLDTextViewDelegate> delegate;

+ (void)setDefaultCharactersLimit:(NSUInteger)charactersLimit;

// Sets |charatersLimit| property and |usesDefaultCharatersLimit| to NO
- (void)setCharactersLimitAndUseForCompare:(NSUInteger)charactersLimit;

// Validator objects should conform to |VLDTextValidator| protocol
- (void)addValidators:(NSArray *)objects;

@end
