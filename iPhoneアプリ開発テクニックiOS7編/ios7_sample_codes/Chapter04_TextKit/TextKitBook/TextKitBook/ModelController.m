//
//  ModelController.m
//  TextKitBook
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

/* ****************************************************
 4-3-3 マルチカラムレイアウト
 
 Page-Based Applicationのテンプレートを元に、NSTextContainerを
 利用してマルチカラムレイアウトを実現する例
 **************************************************** */

#import "ModelController.h"

#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface ModelController()
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSLayoutManager *layoutManager;
@property (nonatomic) NSUInteger numberOfPages;
@end

@implementation ModelController

// 初期化処理 P.140
- (id)init
{
    self = [super init];
    if (self) {
        NSString *filePath =
        [[NSBundle mainBundle] pathForResource:@"sample-text" ofType:@"txt"];
        NSString *text = [NSString stringWithContentsOfFile:filePath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
        UIFont *bodyFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        NSAttributedString *attrText =
        [[NSAttributedString alloc] initWithString:text
                                        attributes:@{NSFontAttributeName: bodyFont}];
        // テキストストレージを作成
        self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attrText];
        // レイアウトマネージャを作成しテキストストレージに追加
        self.layoutManager = [[NSLayoutManager alloc] init];
        [self.textStorage addLayoutManager:self.layoutManager];
        // テキストコンテナの作成
        [self createContainers];
    }
    return self;
}

// 必要数分のテキストコンテナを作成 P.141
- (void)createContainers
{
    CGSize containerSize = CGSizeMake(304, 874);
    NSRange range = NSMakeRange(0, 0);
    
    // 最後に作ったtextContainerに収納されている最終グリフのインデックスと
    // layoutManagerが持つグリフ数を比較し、
    // 前者の方が小さければ、テキストコンテナを作り続ける --- (1)
    while (NSMaxRange(range) < self.layoutManager.numberOfGlyphs) {
        
        NSTextContainer *textContainer =
        [[NSTextContainer alloc] initWithSize:containerSize];
        
        // レイアウトマネージャにテキストコンテナを対応づける --- (2)
        [self.layoutManager addTextContainer:textContainer];
        
        // 作成したコンテナに収まっているグリフのレンジ --- (3)
        range = [self.layoutManager glyphRangeForTextContainer:textContainer];
    }
    
    // ページ数の確定 --- (4)
    self.numberOfPages = [self.layoutManager.textContainers count] / 2 +
    ([self.layoutManager.textContainers count] % 2);
}

// 以下のプライベートメソッドとデータソースメソッドは、コメント箇所を修正 P.142
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index
                                   storyboard:(UIStoryboard *)storyboard
{
    // ページ数との比較に変更
    if ((self.numberOfPages == 0) || (index >= self.numberOfPages)) {
        return nil;
    }
    DataViewController *dataViewController =
    [storyboard instantiateViewControllerWithIdentifier:@"DataViewController"];
    // ページ数を表示させるように変更
    dataViewController.dataObject = [NSString stringWithFormat:@"- %ld -",
                                                       (unsigned long)(index+1)];
    // テキストコンテナを渡すように変更
    dataViewController.leftContainer = self.layoutManager.textContainers[index*2];
    dataViewController.rightContainer =
    (index*2+1 < [self.layoutManager.textContainers count]) ?
    self.layoutManager.textContainers[index*2+1] : nil;
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{   
    // textContainer からインデックスを求めるように変更
    NSTextContainer *textContainer = viewController.leftContainer;
    return [self.layoutManager.textContainers indexOfObject:textContainer] / 2;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index =
    [self indexOfViewController:(DataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == self.numberOfPages) { // ページ数との比較に変更
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
