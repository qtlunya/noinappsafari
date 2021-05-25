#import <UIKit/UIApplication.h>
#import <UIKit/UIViewController.h>
#import <UIKit/UIViewControllerTransitioning.h>

@interface SFSafariViewController : UIViewController
- (NSURL *)initialURL;
@end

static NSUserDefaults *prefs;

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

void NISReloadPrefs() {
    prefs = [[NSUserDefaults alloc] initWithSuiteName:@"/var/mobile/Library/Preferences/net.cadoth.noinappsafari.plist"];
}

%ctor {
    @autoreleasepool {
        NISReloadPrefs();
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)NISReloadPrefs, CFSTR("net.cadoth.noinappsafari/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

        NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];

        if (![[prefs objectForKey:@"enabled"] boolValue]) {
            NSLog(@"Not loading into %@, tweak is disabled globally", bundleId);
            return;
        }

        if ([bundleId hasPrefix:@"com.apple."]) {
            NSLog(@"Not loading into %@, is a system app", bundleId);
            return;
        }

        if ([[prefs objectForKey:[NSString stringWithFormat:@"disabled-%@", bundleId]] boolValue]) {
            NSLog(@"Not loading into %@, tweak is disabled for app", bundleId);
            return;
        }

        NSLog(@"Loading into %@", bundleId);
        %init(main);
    }
}
