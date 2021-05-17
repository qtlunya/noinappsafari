#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIViewControllerTransitioning.h>

@interface SFSafariViewController : UIViewController
-(NSURL *)initialURL;
@end

%group main
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
%end

%ctor {
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];

    NSArray *excludeBundleIds = @[
        @"com.apple.*",
        @"me.apptapp.installer",
        @"org.coolstar.SileoBeta",
        @"org.coolstar.SileoNightly",
        @"org.coolstar.SileoStore",
        @"xyz.willy.Zebra",
    ];

    for (NSString *bid in excludeBundleIds) {
        if ([bid hasSuffix:@"*"]) {
            NSString *prefix = [bid substringToIndex:[bid length] - 1];

            if ([bundleId hasPrefix:prefix]) {
                return;
            }
        } else if ([bundleId isEqualToString:bid]) {
            return;
        }
    }

    %init(main);
}
