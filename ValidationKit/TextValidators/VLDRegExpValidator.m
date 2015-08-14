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

#import "VLDRegExpValidator.h"
#import "VLDHelpers.h"

@interface VLDRegExpValidator ()

@property (nonatomic, strong) NSRegularExpression *regExp;

@end

@implementation VLDRegExpValidator

+ (id <VLDValidator>)validatorWithObject:(id)obj {
    VLDRegExpValidator *regExpValidator = [[VLDRegExpValidator alloc] init];
    [regExpValidator setText:obj];
    return regExpValidator;
}

#pragma mark - Accessors

- (NSRegularExpression *)regExp {
    if (!_regExp) {
        NSError *error;
        _regExp = [NSRegularExpression regularExpressionWithPattern:[[self class] regExpPattern]
                                                            options:0
                                                              error:&error];
        if (error) {
            VLDLog(@"%@ reqular expression is not correct: %@", [self class], [[self class] regExpPattern]);
        }
    }
    return _regExp;
}

#pragma mark - Public Methods

+ (NSString *)regExpPattern {
    return [NSString string];
}

#pragma mark - VLDTextValidator Methods

- (BOOL)validate {
    NSArray *matches = [self.regExp matchesInString:self.text
                                            options:0
                                              range:VLDFullLengthStringRange(self.text)];
    return matches.count > 0;
}

@end
