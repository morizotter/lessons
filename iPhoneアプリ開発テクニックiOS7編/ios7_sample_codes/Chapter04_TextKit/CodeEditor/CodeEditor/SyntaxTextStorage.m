//
//  SyntaxTextStorage.m
//  CodeEditor
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 4-3-4 文字属性の動的変更
 
 文字属性を動的に変更するために、NSTextStorageをサブクラス化する
 **************************************************** */

#import "SyntaxTextStorage.h"

@implementation SyntaxTextStorage {
    NSMutableAttributedString *_backingStore;
    BOOL _dynamicTextNeedsUpdate;
}

- (id)init
{
    self = [super init];
    if (self) {
        _backingStore = [[NSMutableAttributedString alloc] init];
    }
    return self;
}

#pragma mark - primitive methods
#pragma mark NSAttributedString
- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

#pragma mark NSMutableAttributedString
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters|NSTextStorageEditedAttributes
           range:range
  changeInLength:str.length - range.length];
    _dynamicTextNeedsUpdate = YES;
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

#pragma mark - NSTextStorage
- (void)processEditing
{
    if (_dynamicTextNeedsUpdate) {
        _dynamicTextNeedsUpdate = NO;
        [self performReplacementsForCharacterChangeInRange:[self editedRange]];
    }
    [super processEditing];
}

#pragma mark - private methods
// 属性変更の対象となる範囲を拡張
- (void)performReplacementsForCharacterChangeInRange:(NSRange)changedRange
{
    NSString *string = [_backingStore string];
    // changedRange の先頭と同一行を検索対象として拡張
    NSRange extendedRange =
    NSUnionRange(changedRange,
                 [string lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    // changedRange の末尾と同一行を検索対象として拡張
    extendedRange =
    NSUnionRange(changedRange,
                 [string lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyAttributesToRange:extendedRange];
}

// 文字属性の変更
- (void)applyAttributesToRange:(NSRange)range
{
    UIFontDescriptor *normalFontDescriptor =
    [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    
    UIFontDescriptor *boldFontDescriptor =
    [normalFontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    
    // 属性の作成
    NSDictionary *blueAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                     NSFontAttributeName: [UIFont fontWithDescriptor:boldFontDescriptor size:0.0]};
    NSDictionary *blackAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                      NSFontAttributeName: [UIFont fontWithDescriptor:normalFontDescriptor size:0.0]};

    // 全体の属性を初期化（黒・ノーマルフォント） --- (1)
    [self addAttributes:blackAttributes range:range];
    
    // 正規表現を用いて属性変更の対象ととる文字列を検出
    NSRegularExpression *regex =
    [NSRegularExpression regularExpressionWithPattern:@"<.*?>" options:0 error:nil];
    [regex enumerateMatchesInString:[_backingStore string]
                            options:0
                              range:range
                         usingBlock:^(NSTextCheckingResult *result,
                                      NSMatchingFlags flags,
                                      BOOL *stop){
                             // 正規表現にマッチした範囲の属性を変更（青・太字） --- (2)
                             [self removeAttribute:NSForegroundColorAttributeName
                                             range:result.range];
                             [self addAttributes:blueAttributes
                                           range:result.range];
                         }];
}
@end
