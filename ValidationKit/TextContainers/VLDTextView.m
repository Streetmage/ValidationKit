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

#import "VLDTextView.h"
#import "VLDHelpers.h"
#import "VLDTextValidator.h"

static NSInteger defaultCharatersLimit = INT_MAX;

static NSString *const VLDTextObserverKey = @"text";

@interface VLDTextView () <UITextViewDelegate>

@property (nonatomic, readonly) NSUInteger determinedCharactersLimit;
@property (nonatomic, copy) NSString *cachedText;

@end

@implementation VLDTextView

@dynamic delegate;

#pragma mark - Initializers

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
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
        } else {
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
        self.textValidators = mutableValidators;
    }
}

#pragma mark - Private Methods

- (void)setup {
    
    _usesDefaultCharatersLimit = YES;
    
    [self addObserver:self
           forKeyPath:VLDTextObserverKey
              options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
              context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onTextViewDidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
}

- (void)onTextViewDidChange:(NSNotification *)notification {
    [self rollbackTextIfReachedCharatersLimit:notification.object];
}

- (void)rollbackTextIfReachedCharatersLimit:(UITextView *)textView {
    if (textView == self) {
        NSString *expectedText = textView.text;
        BOOL textViewDidReachCharactersLimit = expectedText.length > self.determinedCharactersLimit;
        if (textViewDidReachCharactersLimit) {
            textView.text = self.cachedText;
            if ([self.delegate respondsToSelector:@selector(textViewDidReachCharactersLimit:)]) {
                [self.delegate textViewDidReachCharactersLimit:self];
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
