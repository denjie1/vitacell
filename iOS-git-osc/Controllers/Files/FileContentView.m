//
//  FileContentView.m
//  iOS-git-osc
//
//  Created by chenhaoxiang on 14-7-7.
//  Copyright (c) 2014年 chenhaoxiang. All rights reserved.
//

#import "FileContentView.h"
#import "GLGitlab.h"
#import "Tools.h"
#import "UIView+Toast.h"

#import "GITAPI.h"
#import "AFHTTPRequestOperationManager+Util.h"
#import <MBProgressHUD.h>

#define kScreenSize [UIScreen mainScreen].bounds.size

@interface FileContentView ()

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation FileContentView

- (id)initWithProjectID:(int64_t)projectID path:(NSString *)path fileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        _projectID = projectID;
        _path = path;
        _fileName = fileName;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.fileName;
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    self.webView.scrollView.bounces = NO;
    self.webView.userInteractionEnabled = YES;
    self.webView.scalesPageToFit = YES;
    self.webView.multipleTouchEnabled = YES;
    
    [self.view addSubview:self.webView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self fetchFileContent];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)orientChange:(NSNotification *)noti {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            [UIView animateWithDuration:0.25 animations:^{
                [self.navigationController setNavigationBarHidden:NO animated:YES];
                [UIApplication sharedApplication].statusBarHidden = NO;

                self.webView.transform = CGAffineTransformMakeRotation(0);
                self.webView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
                
            }];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [UIView animateWithDuration:0.25 animations:^{
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [UIApplication sharedApplication].statusBarHidden = YES;
                
                self.webView.transform = CGAffineTransformMakeRotation(M_PI*0.5);
                self.webView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
            }];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [UIView animateWithDuration:0.25 animations:^{
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [UIApplication sharedApplication].statusBarHidden = YES;
                self.webView.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
                self.webView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
            }];
        }
            break;
        default:
            break;
    }
}


- (BOOL)shouldAutomaticallyForwardRotationMethods
{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - 获取文件数据

- (void)fetchFileContent
{
    _hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    _hud.userInteractionEnabled = NO;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager GitManager];
    
    
    //不再使用namespace作为或许项目详情的参数，转而使用projectID，这样更加靠谱
    NSString *projectIdStr = [NSString stringWithFormat:@"%lld",_projectID];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@/%@/repository/files", GITAPI_HTTPS_PREFIX,
                                                                               GITAPI_PROJECTS,
                                                                               projectIdStr];
    NSDictionary *parameters = @{
                                 @"private_token" : [Tools getPrivateToken],
                                 @"ref"           : @"master",
                                 @"file_path"     : [NSString stringWithFormat:@"%@%@", _path, _fileName]
                                 };
    
    [manager GET:strUrl
      parameters:parameters
         success:^(AFHTTPRequestOperation * operation, id responseObject) {
             [_hud hideAnimated:YES afterDelay:1];
             if (responseObject == nil) { } else {
                 _content = [[GLBlob alloc] initWithJSON:responseObject].content;
                 [self render];
             }
         } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             if (error != nil) {
				 _hud.detailsLabel.text = [NSString stringWithFormat:@"网络异常，错误码：%ld", (long)error.code];
             } else {
				 _hud.detailsLabel.text = @"网络错误";
             }
             [_hud hideAnimated:YES afterDelay:1];
    }];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)render
{
    NSURL *baseUrl = [NSURL fileURLWithPath:NSBundle.mainBundle.bundlePath];
	BOOL lineNumbers = YES;//[[defaults valueForKey:kLineNumbersDefaultsKey] boolValue];
    NSString *lang = [[_fileName componentsSeparatedByString:@"."] lastObject];
	NSString *theme = @"github";//@"tomorrow-night";//[defaults valueForKey:kThemeDefaultsKey];
	NSString *formatPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"html"];
	NSString *highlightJsPath = [[NSBundle mainBundle] pathForResource:@"highlight.pack" ofType:@"js"];
	NSString *themeCssPath = [[NSBundle mainBundle] pathForResource:theme ofType:@"css"];
	NSString *codeCssPath = [[NSBundle mainBundle] pathForResource:@"code" ofType:@"css"];
	NSString *lineNums = lineNumbers ? @"true" : @"false";
	NSString *format = [NSString stringWithContentsOfFile:formatPath encoding:NSUTF8StringEncoding error:nil];
	NSString *escapedCode = [Tools escapeHTML:_content];
	NSString *contentHTML = [NSString stringWithFormat:format, themeCssPath, codeCssPath, highlightJsPath, lineNums, lang, escapedCode];
    
	[self.webView loadHTMLString:contentHTML baseURL:baseUrl];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view hideToastActivity];
}


@end
