#import "EmerWidgetController.h"

@implementation EmerWidgetController

+(id)sharedInstance {
    static EmerWidgetController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if(self = [super init]) {
        NSLog(@"EmerWidgetController has been initialized");
    }
    return self;
}

UIView *ipWidget;
UIView *expandedIpWidget;
UILabel *emptyWidget;
UIView *expandedEmptyWidget;
UIView *phWidget;
UIView *expandedPHWidget;
UIView *twitterWidget;
UIView *expandedTwitterWidget;

NSString *oldTwitterFollowers = @"Not found";

-(NSString *)deviceIPAddressForType:(long)type { //https://gist.github.com/niklasberglund/834763c27ed3404fcd5f
    NSString *address = @"Error";
    if(type == 0) { //local
        address = @"No WiFi";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        NSString *networkInterface = @"en0";
        success = getifaddrs(&interfaces);
        if (success == 0) {
            temp_addr = interfaces;
            while (temp_addr != NULL) {
                if( temp_addr->ifa_addr->sa_family == AF_INET) {
                    if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:networkInterface]) {
                        address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        freeifaddrs(interfaces);
        return address;
    } else { //public
        address = @"Error!";
        return address;
    }
    
}

// -(NSString *)twitterFollowersForUser:(NSString *)user {
//     NSString *url = @"https://cdn.syndication.twimg.com/widgets/followbutton/info.json?screen_names=";

//     NSError __block *err = NULL;
//     NSData __block *data;
//     NSURLResponse __block *resp;
//     NSDictionary __block *responseDict;
//     NSString __block *followers = @"a";

//     NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:user]]];
//     [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//     [postRequest setValue:@"0" forHTTPHeaderField:@"if-modified-since"];
//     [postRequest setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
//     [postRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept-Language"];
//     [postRequest setHTTPMethod:@"GET"];

//     [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
//         resp = _response;
//         err = _error;
//         data = _data;    
//         responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//         for(NSDictionary* key in responseDict) {
//             followers = key[@"followers_count"];
//             NSLog(@"LVNVRN %@", followers);
//         }
        
//         NSLog(@"STARF %@", followers);
        
//     }] resume];

    //NSLog(@"ZEBI %@", testt);
    // while (!reqProcessed) {
    //     [NSThread sleepForTimeInterval:0.02];
    // }
    // if(![responseDict isEqual:nil]) {
    //     NSString *followers;
    //     for(NSDictionary* key in responseDict) {
    //         followers = key[@"followers_count"];
    //         NSLog(@"LVNVRN");
    //     }
    //     return followers;
    // }
    // else {
    //     NSLog(@"LV1NVRN");
    //     return oldTwitterFollowers;
    // }
    //return testt;
//     return followers;
// }

-(CGRect)expandedWidgetFrame {
    CGRect expandedWidgetFrame = CGRectMake(0,0,[[EmerController sharedInstance] screenWidth] - 40,80);
    expandedWidgetFrame.size.width = expandedWidgetFrame.size.width - 34;
    expandedWidgetFrame.size.height = expandedWidgetFrame.size.height - 20;

    return expandedWidgetFrame;
}

-(UIView *)ipWidget {
    ipWidget = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    ipWidget.backgroundColor = [UIColor clearColor];
    ipWidget.layer.cornerRadius = 18;
    ipWidget.clipsToBounds = YES;
    ipWidget.tag = 100;

    UILabel *ip = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 38)];
    ip.text = @"IP";
    ip.textColor = [UIColor blackColor];
    ip.font = [UIFont boldSystemFontOfSize:32];
    ip.textAlignment = NSTextAlignmentCenter;

    UILabel *local = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 60, 15)];
    local.text = [self deviceIPAddressForType:0];
    local.textColor = [UIColor blackColor];
    local.font = [UIFont systemFontOfSize:9];
    local.textAlignment = NSTextAlignmentCenter;
    local.tag = 101;

    [ipWidget addSubview:ip];
    [ipWidget addSubview:local];

    return ipWidget;
}

-(UIView *)expandedIpWidget {
    expandedIpWidget = [[UIView alloc] initWithFrame:[self expandedWidgetFrame]];
    expandedIpWidget.backgroundColor = [UIColor clearColor];
    expandedIpWidget.alpha = 0;
    expandedIpWidget.hidden = YES;
    expandedIpWidget.layer.cornerRadius = 18;
    expandedIpWidget.clipsToBounds = YES;
    expandedIpWidget.tag = 103;

    UILabel *widgetIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    widgetIcon.text = @"IP";
    widgetIcon.textColor = [UIColor blackColor];
    widgetIcon.font = [UIFont boldSystemFontOfSize:32];
    widgetIcon.textAlignment = NSTextAlignmentCenter;

    [expandedIpWidget addSubview:widgetIcon];

    UILabel *widgetTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 20)];
    widgetTitle.text = @"IP Address";
    widgetTitle.textColor = [UIColor blackColor];
    widgetTitle.font = [UIFont boldSystemFontOfSize:24];
    widgetTitle.textAlignment = NSTextAlignmentCenter;

    [expandedIpWidget addSubview:widgetTitle];

    UILabel *localIP = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 15)];
    localIP.font = [UIFont systemFontOfSize:12];
    localIP.text = [[[@"Local: " stringByAppendingString:[self deviceIPAddressForType:0]] stringByAppendingString:@"   Public: "] stringByAppendingString:[self deviceIPAddressForType:1]];
    localIP.textColor = [UIColor blackColor];
    localIP.textAlignment = NSTextAlignmentCenter;
    localIP.tag = 104;

    [expandedIpWidget addSubview:localIP];

    return expandedIpWidget;
}

-(UILabel *)emptyWidget {
    emptyWidget = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    emptyWidget.text = @"...";
    emptyWidget.font = [UIFont boldSystemFontOfSize:32];
    emptyWidget.textColor = [UIColor colorWithRed: 0.89 green: 0.89 blue: 0.89 alpha: 1.00];
    emptyWidget.textAlignment = NSTextAlignmentCenter;
    emptyWidget.tag = 105;

    return emptyWidget;
}

-(UIView *)expandedEmptyWidget {
    expandedEmptyWidget = [[UIView alloc] initWithFrame:[self expandedWidgetFrame]];
    expandedEmptyWidget.backgroundColor = [UIColor clearColor];
    expandedEmptyWidget.alpha = 0;
    expandedEmptyWidget.hidden = YES;
    expandedEmptyWidget.layer.cornerRadius = 18;
    expandedEmptyWidget.clipsToBounds = YES;
    expandedEmptyWidget.tag = 106;

    UILabel *widgetIcon = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    widgetIcon.text = @"...";
    widgetIcon.textColor = [UIColor colorWithRed: 0.89 green: 0.89 blue: 0.89 alpha: 1.00];
    widgetIcon.font = [UIFont boldSystemFontOfSize:32];
    widgetIcon.textAlignment = NSTextAlignmentCenter;

    [expandedEmptyWidget addSubview:widgetIcon];

    UILabel *widgetTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 25)];
    widgetTitle.text = @"This widget is empty.";
    widgetTitle.textColor = [UIColor blackColor];
    widgetTitle.font = [UIFont boldSystemFontOfSize:20];
    widgetTitle.textAlignment = NSTextAlignmentCenter;

    [expandedEmptyWidget addSubview:widgetTitle];

    UILabel *widgetSubtitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 20)];
    widgetSubtitle.text = @"Try adding one in Emer settings";
    widgetSubtitle.textColor = [UIColor blackColor];
    widgetSubtitle.font = [UIFont systemFontOfSize:14];
    widgetSubtitle.textAlignment = NSTextAlignmentCenter;

    [expandedEmptyWidget addSubview:widgetSubtitle];

    return expandedEmptyWidget;
}

-(UIView *)phWidget {
    phWidget = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    phWidget.backgroundColor = [UIColor clearColor];
    phWidget.layer.cornerRadius = 18;
    phWidget.clipsToBounds = YES;
    phWidget.tag = 107;

    NSString *hotspotImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/hotspot.png"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:hotspotImagePath]) {
        hotspotImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/hotspot.png"];
    }

    UIImageView *hotspot = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:hotspotImagePath]];
    hotspot.frame = CGRectMake(12, 14.5, 36, 29);
    hotspot.backgroundColor = [UIColor clearColor];
    hotspot.contentMode = UIViewContentModeScaleAspectFill;

    [phWidget addSubview:hotspot];

    UILabel *phDevicesLittle = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 60, 15)];
    //phDevicesLittle.text = [self deviceIPAddressForType:0];
    phDevicesLittle.textColor = [UIColor blackColor];
    phDevicesLittle.font = [UIFont systemFontOfSize:9];
    phDevicesLittle.textAlignment = NSTextAlignmentCenter;
    phDevicesLittle.text = @"Error";
    phDevicesLittle.tag = 108;

    [phWidget addSubview:phDevicesLittle];

    return phWidget;
}

-(UIView *)expandedPHWidget {
    expandedPHWidget = [[UIView alloc] initWithFrame:[self expandedWidgetFrame]];
    expandedPHWidget.backgroundColor = [UIColor clearColor];
    expandedPHWidget.alpha = 0;
    expandedPHWidget.hidden = YES;
    expandedPHWidget.layer.cornerRadius = 18;
    expandedPHWidget.clipsToBounds = YES;
    expandedPHWidget.tag = 110;

    NSString *hotspotImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/hotspot.png"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:hotspotImagePath]) {
        hotspotImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/hotspot.png"];
    }

    UIImageView *widgetIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:hotspotImagePath]];
    widgetIcon.frame = CGRectMake(12, 14.5, 36, 29);
    widgetIcon.backgroundColor = [UIColor clearColor];
    widgetIcon.contentMode = UIViewContentModeScaleAspectFill;

    [expandedPHWidget addSubview:widgetIcon];

    UILabel *widgetTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 25)];
    widgetTitle.text = @"Personal hotspot";
    widgetTitle.textColor = [UIColor blackColor];
    widgetTitle.font = [UIFont boldSystemFontOfSize:20];
    widgetTitle.textAlignment = NSTextAlignmentCenter;

    [expandedPHWidget addSubview:widgetTitle];

    UILabel *phDevices = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 20)];
    phDevices.text = @"Error";
    phDevices.textColor = [UIColor blackColor];
    phDevices.font = [UIFont systemFontOfSize:14];
    phDevices.textAlignment = NSTextAlignmentCenter;
    phDevices.tag = 109;

    [expandedPHWidget addSubview:phDevices];

    return expandedPHWidget;
}

-(UIView *)twitterWidget {
    twitterWidget = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    twitterWidget.backgroundColor = [UIColor clearColor];
    twitterWidget.layer.cornerRadius = 18;
    twitterWidget.clipsToBounds = YES;
    twitterWidget.tag = 111;

    NSString *twitterImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/twitter2.png"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:twitterImagePath]) {
        twitterImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/twitter2.png"];
    }

    UIImageView *twitter = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:twitterImagePath]];
    twitter.frame = CGRectMake(12, 14.5, 36, 29);
    twitter.backgroundColor = [UIColor clearColor];
    twitter.contentMode = UIViewContentModeScaleAspectFill;

    [twitterWidget addSubview:twitter];

    UILabel *twitterInfoLittle = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 60, 15)];
    twitterInfoLittle.textColor = [UIColor blackColor];
    twitterInfoLittle.font = [UIFont systemFontOfSize:9];
    twitterInfoLittle.textAlignment = NSTextAlignmentCenter;
    twitterInfoLittle.text = @"Error";
    twitterInfoLittle.tag = 112;

    [twitterWidget addSubview:twitterInfoLittle];

    return twitterWidget;
}

-(UIView *)expandedTwitterWidget {
    expandedTwitterWidget = [[UIView alloc] initWithFrame:[self expandedWidgetFrame]];
    expandedTwitterWidget.backgroundColor = [UIColor clearColor];
    expandedTwitterWidget.alpha = 0;
    expandedTwitterWidget.hidden = YES;
    expandedTwitterWidget.layer.cornerRadius = 18;
    expandedTwitterWidget.clipsToBounds = YES;
    expandedTwitterWidget.tag = 113;

    NSString *twitterImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/twitter2.png"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:twitterImagePath]) {
        twitterImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/twitter2.png"];
    }

    UIImageView *widgetIcon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:twitterImagePath]];
    widgetIcon.frame = CGRectMake(12, 14.5, 36, 29);
    widgetIcon.backgroundColor = [UIColor clearColor];
    widgetIcon.contentMode = UIViewContentModeScaleAspectFill;

    [expandedTwitterWidget addSubview:widgetIcon];

    UILabel *widgetTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 20)];
    widgetTitle.text = @"Twitter";
    widgetTitle.textColor = [UIColor blackColor];
    widgetTitle.font = [UIFont boldSystemFontOfSize:24];
    widgetTitle.textAlignment = NSTextAlignmentCenter;

    [expandedTwitterWidget addSubview:widgetTitle];

    UILabel *twitterInfo = [[UILabel alloc] initWithFrame:CGRectMake(60, 35, [[EmerController sharedInstance] cardBlurContainer].frame.size.width - 94, 15)];
    twitterInfo.font = [UIFont systemFontOfSize:12];
    twitterInfo.text = @"Error";
    twitterInfo.textColor = [UIColor blackColor];
    twitterInfo.textAlignment = NSTextAlignmentCenter;
    twitterInfo.tag = 114;

    [expandedTwitterWidget addSubview:twitterInfo];

    return expandedTwitterWidget;
}

-(void)setWidgetsAlpha:(long)alpha { //increment here
    ipWidget.alpha = alpha;
    emptyWidget.alpha = alpha;
    phWidget.alpha = alpha;
    twitterWidget.alpha = alpha;
}

-(void)setWidgetsHidden:(BOOL)hidden { //increment here
    ipWidget.hidden = hidden;
    emptyWidget.hidden = hidden;
    phWidget.hidden = hidden;
    twitterWidget.hidden = hidden;
}

-(void)hideExpandedWidgets { //increment here
    expandedIpWidget.alpha = 0;
    expandedIpWidget.hidden = YES;
    expandedEmptyWidget.alpha = 0;
    expandedEmptyWidget.hidden = YES;
    expandedPHWidget.alpha = 0;
    expandedPHWidget.hidden = YES;
    expandedTwitterWidget.alpha = 0;
    expandedTwitterWidget.hidden = YES;
}

-(void)showViewForWidget:(long)widget { //increment here
    expandedIpWidget.hidden = YES;
    expandedIpWidget.alpha = 0;

    expandedEmptyWidget.hidden = YES;
    expandedEmptyWidget.alpha = 0;

    expandedPHWidget.hidden = YES;
    expandedPHWidget.alpha = 0;

    expandedTwitterWidget.hidden = YES;
    expandedTwitterWidget.alpha = 0;

    switch(widget) {
        case 103:
            expandedIpWidget.hidden = NO;
            expandedIpWidget.alpha = 1;
            break;
        case 106:
            expandedEmptyWidget.hidden = NO;
            expandedEmptyWidget.alpha = 1;
            break;
        case 110:
            expandedPHWidget.hidden = NO;
            expandedPHWidget.alpha = 1;
            break;
        case 113:
            expandedTwitterWidget.hidden = NO;
            expandedTwitterWidget.alpha = 1;
            break;
        default:
            break;
    }
}

@end