#include "EMRRootListController.h"
#import "EmerConfigHeaderView.h"
#import <spawn.h>

@implementation EMRRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openReddit {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.reddit.com/user/LVN_N"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Reddit url opened");
        }
    }];
}

- (void)openTwitter {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.twitter.com/LivenOff"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Twitter url opened");
        }
    }];
}

// - (void)respring:(id)sender {
// 	pid_t pid;
//     const char* args[] = {"killall", "backboardd", NULL};
//     posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
// }

-(void)viewWillAppear:(BOOL)view {
    [super viewWillAppear:view];

    if(!self.table.tableHeaderView) {
        EmerConfigHeaderView *view = [[EmerConfigHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        [self.table setTableHeaderView:view];
        [self.table insertSubview:view atIndex:0];
    }

    [super viewWillAppear:view];
}

@end

@interface AppearencePrefsController : PSListController
@end

@implementation AppearencePrefsController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Appearence" target:self];
	}
	[(UINavigationItem *)self.navigationItem setTitle:@"Appearence"];
	return _specifiers;
}

@end

@interface WidgetsSettingsPrefsController : PSListController
@end

@implementation WidgetsSettingsPrefsController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"WidgetSettings" target:self];
	}
	[(UINavigationItem *)self.navigationItem setTitle:@"Widgets Settings"];
	return _specifiers;
}
@end

@interface TwitterWidgetPrefsController : PSListController
@end

@implementation TwitterWidgetPrefsController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"WidgetSettingsPrefs/TwitterWidget" target:self];
	}
	[(UINavigationItem *)self.navigationItem setTitle:@"Twitter Widget Settings"];
	return _specifiers;
}
@end

@interface ipWidgetPrefsController : PSListController
@end

@implementation ipWidgetPrefsController
- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"WidgetSettingsPrefs/ipWidget" target:self];
	}
	[(UINavigationItem *)self.navigationItem setTitle:@"IP Widget Settings"];
	return _specifiers;
}
@end