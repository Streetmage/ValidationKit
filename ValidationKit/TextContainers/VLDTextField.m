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

#import "VLDTextField.h"
#import "VLDHelpers.h"
#import "VLDTextValidator.h"
#import "VLDPhoneNumberValidator.h"
#import "VLDEmailValidator.h"
#import "VLDStrongPasswordValidator.h"

static NSInteger defaultCharatersLimit = INT_MAX;

static NSString *const VLDTextObserverKey = @"text";

@interface VLDTextField () <UITextFieldDelegate>

@property (nonatomic, readonly) NSUInteger determinedCharactersLimit;
@property (nonatomic, copy) NSString *cachedText;

@end

@implementation VLDTextField

@dynamic delegate;

#pragma mark - Initializers

- (instancetype)initWithValidatorTypeMask:(VLDTextFieldValidatorTypeMask)validatorTypeMask {
    self = [self initWithFrame:CGRectZero validatorTypeMask:validatorTypeMask];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame validatorTypeMask:(VLDTextFieldValidatorTypeMask)validatorTypeMask {
    self = [self initWithFrame:frame];
    if (self) {
        [self setupWithValidatorTypeMask:validatorTypeMask];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _usesDefaultCharatersLimit = YES;
        
        [self addObserver:self
               forKeyPath:VLDTextObserverKey
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
        
        [self addTarget:self
                 action:@selector(onTextFieldDidChange:)
       forControlEvents:UIControlEventEditingChanged];
        
    }
    return self;
}

- (void)dealloc {
    @try {
        [self removeObserver:self forKeyPath:VLDTextObserverKey];
    }
    @catch (NSException *exception) {
        VLDLog(@"%@ observer haven't been removed correctly", [self class]);
    }
    
}

#pragma mark - Accessors

- (NSUInteger)determinedCharactersLimit {
    return self.usesDefaultCharatersLimit ? defaultCharatersLimit : self.charactersLimit;
}

- (BOOL)isEmpty {
    return self.text.length == 0;
}

- (BOOL)isValidText {
    BOOL valid = YES;
    for (id <VLDTextValidator> validator in self.textValidators) {
        if ([validator conformsToProtocol:@protocol(VLDTextValidator)]) {
            [validator setText:self.text];
            valid = [validator validate];
            if (!valid) {
                break;
            }
        }
        else {
            VLDLog(@"%@ validator doesn't conform to %@ protocol", [self class], NSStringFromProtocol(@protocol(VLDTextValidator)));
        }
    }
    return valid;
}

#pragma mark - Public Methods

+ (void)setDefaultCharactersLimit:(NSUInteger)charactersLimit {
    defaultCharatersLimit = charactersLimit;
    VLDLog(@"%@ default characters limit changed to %tu", [self class], charactersLimit);
}

- (void)setCharactersLimitAndUseForCompare:(NSUInteger)charactersLimit {
    _usesDefaultCharatersLimit = NO;
    self.charactersLimit = charactersLimit;
}

- (void)addValidators:(NSArray *)objects {
    if (objects) {
        NSMutableArray *mutableValidators = [NSMutableArray arrayWithArray:self.textValidators];
        [mutableValidators addObjectsFromArray:[objects copy]];
    }
}

#pragma mark - Private Methods

- (void)setupWithValidatorTypeMask:(VLDTextFieldValidatorTypeMask)validatorTypeMask {
    id <VLDTextValidator> predefinedValidator = nil;
    if (validatorTypeMask & VLDTextFieldPhoneNumberValidator) {
        predefinedValidator = [[VLDPhoneNumberValidator alloc] init];
    }
    else if (validatorTypeMask & VLDTextFieldEmailValidator) {
        predefinedValidator = [[VLDEmailValidator alloc] init];
    }
    else if (validatorTypeMask & VLDTextFieldStrongPasswordValidator) {
        predefinedValidator = [[VLDStrongPasswordValidator alloc] init];
    }
    _textValidators = [NSArray arrayWithObject:predefinedValidator];
}

- (void)onTextFieldDidChange:(UITextField *)textField {
    [self rollbackTextIfReachedCharatersLimit:textField];
}

- (void)rollbackTextIfReachedCharatersLimit:(UITextField *)textField {
    if (textField == self) {
        NSString *expectedText = textField.text;
        BOOL textFieldDidReachCharactersLimit = expectedText.length > self.determinedCharactersLimit;
        if (textFieldDidReachCharactersLimit) {
            textField.text = self.cachedText;
            if ([self.delegate respondsToSelector:@selector(textFieldDidReachCharactersLimit:)]) {
                [self.delegate textFieldDidReachCharactersLimit:self];
            }
        } else {
            self.cachedText = expectedText;
        }
    }
}

#pragma mark - KVO Methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self && [keyPath isEqualToString:VLDTextObserverKey]) {
        [self rollbackTextIfReachedCharatersLimit:object];
    }
}

@end
