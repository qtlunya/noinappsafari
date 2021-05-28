#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIViewControllerTransitioning.h>
#import <Cephei/HBPreferences.h>

@interface SFSafariViewController : UIViewController
- (NSURL *)initialURL;
@end

HBPreferences *prefs;

%group main

%hook SFSafariViewController
- (void)viewWillAppear:(BOOL)animated {
    NSURL *url = [self initialURL];
    NSString *urlStr = [url absoluteString];

    if ([urlStr hasPrefix:@"https://twitter.com/account/"] ||
            [urlStr hasPrefix:@"https://api.twitter.com/"]) {
        return %orig;
    }

    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
%end

%hook SFInteractiveDismissController
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    [transitionContext completeTransition:NO];
}
%end

%end

%ctor {
    @autoreleasepool {
        prefs = [[HBPreferences alloc] initWithIdentifier:@"net.cadoth.noinappsafari"];

        [prefs registerDefaults:@{
            @"enabled": @YES,
        }];

        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];

        if (![prefs boolForKey:@"enabled"]) {
            NSLog(@"Not loading into %@, tweak is disabled globally", bundleId);
            return;
        }

        if ([bundleId hasPrefix:@"com.apple."]) {
            NSLog(@"Not loading into %@, is a system app", bundleId);
            return;
        }

        if ([prefs boolForKey:[NSString stringWithFormat:@"disabled-%@", bundleId]]) {
            NSLog(@"Not loading into %@, tweak is disabled for app", bundleId);
            return;
        }

        NSLog(@"Loading into %@", bundleId);
        %init(main);
    }
}
