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

#import "VLDCategoriesHelpers.h"
#import "NSString+VLDValidation.h"
#import "NSData+VLDValidation.h"
#import "VLDHelpers.h"

static NSUInteger defaultTotalDataLimit = VLD_TB;

@implementation VLDCategoriesHelpers

#pragma mark - Public Methods

+ (void)setDefaultTotalDataLimit:(NSUInteger)totalDataLimit {
    defaultTotalDataLimit = totalDataLimit;
    VLDLog(@"%@ default total data limit changed to %tu bytes", [self class], defaultTotalDataLimit);
}

+ (BOOL)validateArrayObjects:(NSArray *)array {
    BOOL valid = YES;
    for (id object in array) {
        if ([object isKindOfClass:[NSString class]] ||
            [object isKindOfClass:[NSData class]]) {
            valid = [object validateByDefaultLength];
            if (!valid) {
                break;
            }
        }
    }
    return valid;
}

+ (BOOL)validateArrayForTotalDataLength:(NSArray *)array {
    NSUInteger totalDataLength = 0;
    for (id object in array) {
        totalDataLength += sizeof(object);
    }
    return totalDataLength <= defaultTotalDataLimit;
}

@end
