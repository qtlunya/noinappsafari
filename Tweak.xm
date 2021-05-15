#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIViewControllerTransitioning.h>

@interface SFSafariViewController : UIViewController
-(NSURL *)initialURL;
@end

%hook SFSafariViewController
-(void)viewWillAppear:(BOOL)animated {
    NSURL *url = [self initialURL];
    NSString *urlStr = [url absoluteString];

    if ([urlStr hasPrefix:@"https://twitter.com/account/"]) {
        return %orig;
    }

    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
%end

%hook SFInteractiveDismissController
-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:NO];
}
%end
