//
//  ViewController.m
//  BlockBuster
//
//  インプレスジャパン発行
//  「上を目指すプログラマーのためのiPhoneアプリ開発テクニック iOS 7編」
//  サンプルコード
//

#import "ViewController.h"
#import "SceneController.h"
#import "TitleScene.h"

@interface ViewController ()
@property (nonatomic)SceneController *sceneController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // ビューに表示するデバッグ情報を指定
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;

    // シーン管理オブジェクトを作成
    self.sceneController = [[SceneController alloc] init];
    self.sceneController.view = skView;

    // 最初のシーンを作成・表示
    SKScene *scene = [TitleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
