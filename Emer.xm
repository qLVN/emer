#import "Emer.h"
#import "emerprefs/EmerConfigHeaderUpdater.h"
#import "emerprefs/EmerConfigHeaderView.h"

bool cardLoaded = false;
UIView *baseView;
bool shouldNotShowCardYet = NO;
double chargePercent;
bool lowPowerMode;
bool charging;
bool isUnlocked = false;

long firstWidgetTag = 0;
long secondWidgetTag = 0;
long thirdWidgetTag = 0;
long fourthWidgetTag = 0;
long fifthWidgetTag = 0;

//Prefs
BOOL enabled;


%group Tweak

	//add Emer
	%hook CSCoverSheetViewController

	-(void)viewDidLoad {
		%orig;

		if(!cardLoaded) {
			baseView = [[UIView alloc] initWithFrame:CGRectMake(0,-288,[[EmerController sharedInstance] screenWidth],258)]; //Not visible, transition not made yet

			[baseView addSubview:[[EmerController sharedInstance] baseCard:@"back"]]; //back base card
			[baseView addSubview:[[EmerController sharedInstance] baseCard:@"front"]]; //base card
			[baseView addSubview:[[EmerController sharedInstance] dateLabel]]; //Monday 6, June
			[baseView addSubview:[[EmerController sharedInstance] cardBlurContainer]]; //light container
			[baseView addSubview:[[EmerController sharedInstance] timeLabel]]; //9:41

			//[baseView addSubview:[[EmerController sharedInstance] expandedWidgetView]];

			//adding as subview of cardBlurContainerScrollView
			[baseView addSubview:[[EmerController sharedInstance] cardBlurContainerScrollView]];
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] firstWidget]]; //First widget "box"
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] secondWidget]]; //Second widget "box"
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] thirdWidget]]; //Third widget "box"
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] fourthWidget]]; //Fourth widget "box"
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] fifthWidget]]; //Fifth widget "box"

			[baseView addSubview:[[EmerController sharedInstance] expandedWidgetView]];

			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] firstWidgetTouchPassThroughView]];
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] secondWidgetTouchPassThroughView]];
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] thirdWidgetTouchPassThroughView]];
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] fourthWidgetTouchPassThroughView]];
			[[baseView viewWithTag:3] addSubview:[[EmerController sharedInstance] fifthWidgetTouchPassThroughView]];


			[[baseView viewWithTag:4] addSubview:[[EmerWidgetController sharedInstance] expandedIpWidget]];
			[[baseView viewWithTag:4] addSubview:[[EmerWidgetController sharedInstance] expandedEmptyWidget]];
			[[baseView viewWithTag:4] addSubview:[[EmerWidgetController sharedInstance] expandedPHWidget]];
			[[baseView viewWithTag:4] addSubview:[[EmerWidgetController sharedInstance] expandedTwitterWidget]];
			[baseView addSubview:[[EmerController sharedInstance] expandedWidgetTouchPassThroughView]];
			[baseView addSubview:[[EmerController sharedInstance] battery]]; //eh
			//[baseView addSubview:[[EmerController sharedInstance] wifi]];
			//[baseView addSubview:[[EmerController sharedInstance] cellular]];

			[self.view addSubview:baseView];

			cardLoaded = true;
		}
	}

	%end

	// %hook NCToggleControl

	// -(void)setExpanded:(BOOL)arg1 {
	// 	if(enabled == YES) {
	// 		%orig(true);
	// 	} else {
	// 		%orig;
	// 	}
	// }

	// -(void)setTitle:(NSString *)arg1 {
	// 	if(enabled == YES) {
	// 		%orig(@"Clear all notifications");
	// 	} else {
	// 		%orig;
	// 	}
	// }

	// %end

	// %hook NCNotificationListHeaderTitleView

	// -(void)setTitle:(NSString *)arg1 {
	// 	if(enabled == YES) {
	// 		%orig(@"");
	// 	}
	// 	%orig;
	// }

	// %end

	//lower notifs
	%hook NCNotificationListView

	-(double)_headerViewHeight {
		if(enabled == YES && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
			return 85;
		}
		else {
			return %orig;
		}
	}

	-(double)_footerViewHeight {
		if(enabled == YES && UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
			return 85;
		}
		else {
			return %orig;
		}
	}

	%end

	//update time
	%hook SBFLockScreenDateViewController

	-(void)updateTimeNow { //update date
		%orig;

		if(enabled == YES) {
			NSLocale* currentLocale = [NSLocale currentLocale];
			[[NSDate date] descriptionWithLocale:currentLocale]; 

			NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init]; 
			[dateFormatter setLocalizedDateFormatFromTemplate:@"MMMMd"];

			NSString *processedDateString = [dateFormatter stringFromDate:[NSDate date]];
			UILabel *label = [baseView viewWithTag:1];

			label.text = processedDateString;
		}
	}

	%end

	//update date
	%hook SBStatusBarStateAggregator

	-(void)_updateTimeItems {
		%orig;

		if(enabled == YES) {
			NSLocale* currentLocale = [NSLocale currentLocale];
			[[NSDate date] descriptionWithLocale:currentLocale]; 

			NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init]; 
			[dateFormatter setLocalizedDateFormatFromTemplate:@"HH:mm"];

			NSString *processedDateString = [dateFormatter stringFromDate:[NSDate date]];
			UILabel *label = [baseView viewWithTag:2];

			label.text = processedDateString;
		}
	}

	%end

	//refresh/reset Emer
	%hook NCNotificationStructuredListViewController

	-(void)setDeviceAuthenticated:(BOOL)arg1 {
		%orig;

		[[EmerController sharedInstance] showWidgetsTouchPassThroughView];
		UIView *expandedWidgetView = [baseView viewWithTag:4];
		UIView *expandedWidgetTouchPassThroughView = [baseView viewWithTag:6];
		expandedWidgetView.frame = CGRectZero;
		expandedWidgetView.hidden = YES;
        expandedWidgetTouchPassThroughView.frame = CGRectZero;

		//Load Widgets
		NSDictionary *userPrefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.liven.emerprefs"];
		id firstWidgetValue = [userPrefs valueForKey:@"FirstWidget"];
		id secondWidgetValue = [userPrefs valueForKey:@"SecondWidget"];
		id thirdWidgetValue = [userPrefs valueForKey:@"ThirdWidget"];
		id fourthWidgetValue = [userPrefs valueForKey:@"FourthWidget"];
		id fifthWidgetValue = [userPrefs valueForKey:@"FifthWidget"];

		[[EmerWidgetController sharedInstance] setWidgetsAlpha:0];
		[[EmerWidgetController sharedInstance] setWidgetsHidden:YES];

		switch([firstWidgetValue longValue]) {
			case 1: //IP
				if(firstWidgetTag == 202) {
					UIView *ipWidget = [baseView viewWithTag:202];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
				}
				else { //was another widget
					if(firstWidgetTag != 0) {
						[[baseView viewWithTag:firstWidgetTag] removeFromSuperview];
					}
					UIView *ipWidget = [[EmerWidgetController sharedInstance] ipWidget];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
					ipWidget.tag = 202;
					[[baseView viewWithTag:11] addSubview:ipWidget];
					if([baseView viewWithTag:202] != nil) {
						firstWidgetTag = 202;
					}
				}
				break;
			case 2: //PERSONAL HOTSPOT
				if(firstWidgetTag == 203) {
					UIView *phWidget = [baseView viewWithTag:203];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
				}
				else { //was another widget
					if(firstWidgetTag != 0) {
						[[baseView viewWithTag:firstWidgetTag] removeFromSuperview];
					}
					UIView *phWidget = [[EmerWidgetController sharedInstance] phWidget];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
					phWidget.tag = 203;
					[[baseView viewWithTag:11] addSubview:phWidget];
					if([baseView viewWithTag:203] != nil) {
						firstWidgetTag = 203;
					}
				}
				break;
			case 3: //TWITTER
				if(firstWidgetTag == 204) {
					UIView *twitterWidget = [baseView viewWithTag:204];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
				}
				else { //was another widget
					if(firstWidgetTag != 0) {
						[[baseView viewWithTag:firstWidgetTag] removeFromSuperview];
					}
					UIView *twitterWidget = [[EmerWidgetController sharedInstance] twitterWidget];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
					twitterWidget.tag = 204;
					[[baseView viewWithTag:11] addSubview:twitterWidget];
					if([baseView viewWithTag:204] != nil) {
						firstWidgetTag = 204;
					}
				}
				break;
			default:
				if(firstWidgetTag == 201) {
					UILabel *emptyWidget = [baseView viewWithTag:201];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
				}
				else {
					if(firstWidgetTag != 0) {
						[[baseView viewWithTag:firstWidgetTag] removeFromSuperview];
					}
					UILabel *emptyWidget = [[EmerWidgetController sharedInstance] emptyWidget];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
					emptyWidget.tag = 201;
					[[baseView viewWithTag:11] addSubview:emptyWidget];
					if([baseView viewWithTag:201] != nil) {
						firstWidgetTag = 201;
					}
				}
				break;
		}
		switch([secondWidgetValue longValue]) {
			case 1: //IP
				if(secondWidgetTag == 302) {
					UIView *ipWidget = [baseView viewWithTag:302];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
				}
				else { //was another widget
					if(secondWidgetTag != 0) {
						[[baseView viewWithTag:secondWidgetTag] removeFromSuperview];
					}
					UIView *ipWidget = [[EmerWidgetController sharedInstance] ipWidget];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
					ipWidget.tag = 302;
					[[baseView viewWithTag:12] addSubview:ipWidget];
					if([baseView viewWithTag:302] != nil) {
						secondWidgetTag = 302;
					}
				}
				break;
			case 2: //PERSONAL HOTSPOT
				if(secondWidgetTag == 303) {
					UIView *phWidget = [baseView viewWithTag:303];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
				}
				else { //was another widget
					if(secondWidgetTag != 0) {
						[[baseView viewWithTag:secondWidgetTag] removeFromSuperview];
					}
					UIView *phWidget = [[EmerWidgetController sharedInstance] phWidget];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
					phWidget.tag = 303;
					[[baseView viewWithTag:12] addSubview:phWidget];
					if([baseView viewWithTag:303] != nil) {
						secondWidgetTag = 303;
					}
				}
				break;
			case 3: //TWITTER
				if(secondWidgetTag == 304) {
					UIView *twitterWidget = [baseView viewWithTag:304];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
				}
				else { //was another widget
					if(secondWidgetTag != 0) {
						[[baseView viewWithTag:secondWidgetTag] removeFromSuperview];
					}
					UIView *twitterWidget = [[EmerWidgetController sharedInstance] twitterWidget];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
					twitterWidget.tag = 304;
					[[baseView viewWithTag:12] addSubview:twitterWidget];
					if([baseView viewWithTag:304] != nil) {
						secondWidgetTag = 304;
					}
				}
				break;
			default:
				if(secondWidgetTag == 301) {
					UILabel *emptyWidget = [baseView viewWithTag:301];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
				}
				else {
					if(secondWidgetTag != 0) {
						[[baseView viewWithTag:secondWidgetTag] removeFromSuperview];
					}
					UILabel *emptyWidget = [[EmerWidgetController sharedInstance] emptyWidget];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
					emptyWidget.tag = 301;
					[[baseView viewWithTag:12] addSubview:emptyWidget];
					if([baseView viewWithTag:301] != nil) {
						secondWidgetTag = 301;
					}
				}
				break;
		}
		switch([thirdWidgetValue longValue]) {
			case 1: //IP
				if(thirdWidgetTag == 402) {
					UIView *ipWidget = [baseView viewWithTag:402];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
				}
				else { //was another widget
					if(thirdWidgetTag != 0) {
						[[baseView viewWithTag:thirdWidgetTag] removeFromSuperview];
					}
					UIView *ipWidget = [[EmerWidgetController sharedInstance] ipWidget];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
					ipWidget.tag = 402;
					[[baseView viewWithTag:13] addSubview:ipWidget];
					if([baseView viewWithTag:402] != nil) {
						thirdWidgetTag = 402;
					}
				}
				break;
			case 2: //PERSONAL HOTSPOT
				if(thirdWidgetTag == 403) {
					UIView *phWidget = [baseView viewWithTag:403];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
				}
				else { //was another widget
					if(thirdWidgetTag != 0) {
						[[baseView viewWithTag:thirdWidgetTag] removeFromSuperview];
					}
					UIView *phWidget = [[EmerWidgetController sharedInstance] phWidget];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
					phWidget.tag = 403;
					[[baseView viewWithTag:13] addSubview:phWidget];
					if([baseView viewWithTag:403] != nil) {
						thirdWidgetTag = 403;
					}
				}
				break;
			case 3: //TWITTER
				if(thirdWidgetTag == 404) {
					UIView *twitterWidget = [baseView viewWithTag:404];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
				}
				else { //was another widget
					if(thirdWidgetTag != 0) {
						[[baseView viewWithTag:thirdWidgetTag] removeFromSuperview];
					}
					UIView *twitterWidget = [[EmerWidgetController sharedInstance] twitterWidget];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
					twitterWidget.tag = 404;
					[[baseView viewWithTag:13] addSubview:twitterWidget];
					if([baseView viewWithTag:404] != nil) {
						thirdWidgetTag = 404;
					}
				}
				break;
			default:
				if(thirdWidgetTag == 401) {
					UILabel *emptyWidget = [baseView viewWithTag:401];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
				}
				else {
					if(thirdWidgetTag != 0) {
						[[baseView viewWithTag:thirdWidgetTag] removeFromSuperview];
					}
					UILabel *emptyWidget = [[EmerWidgetController sharedInstance] emptyWidget];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
					emptyWidget.tag = 401;
					[[baseView viewWithTag:13] addSubview:emptyWidget];
					if([baseView viewWithTag:401] != nil) {
						thirdWidgetTag = 401;
					}
				}
				break;
		}
		switch([fourthWidgetValue longValue]) {
			case 1: //IP
				if(fourthWidgetTag == 502) {
					UIView *ipWidget = [baseView viewWithTag:502];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
				}
				else { //was another widget
					if(fourthWidgetTag != 0) {
						[[baseView viewWithTag:fourthWidgetTag] removeFromSuperview];
					}
					UIView *ipWidget = [[EmerWidgetController sharedInstance] ipWidget];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
					ipWidget.tag = 502;
					[[baseView viewWithTag:14] addSubview:ipWidget];
					if([baseView viewWithTag:502] != nil) {
						fourthWidgetTag = 502;
					}
				}
				break;
			case 2: //PERSONAL HOTSPOT
				if(fourthWidgetTag == 503) {
					UIView *phWidget = [baseView viewWithTag:503];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
				}
				else { //was another widget
					if(fourthWidgetTag != 0) {
						[[baseView viewWithTag:fourthWidgetTag] removeFromSuperview];
					}
					UIView *phWidget = [[EmerWidgetController sharedInstance] phWidget];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
					phWidget.tag = 503;
					[[baseView viewWithTag:14] addSubview:phWidget];
					if([baseView viewWithTag:503] != nil) {
						fourthWidgetTag = 503;
					}
				}
				break;
			case 3: //TWITTER
				if(fourthWidgetTag == 504) {
					UIView *twitterWidget = [baseView viewWithTag:504];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
				}
				else { //was another widget
					if(fourthWidgetTag != 0) {
						[[baseView viewWithTag:fourthWidgetTag] removeFromSuperview];
					}
					UIView *twitterWidget = [[EmerWidgetController sharedInstance] twitterWidget];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
					twitterWidget.tag = 504;
					[[baseView viewWithTag:14] addSubview:twitterWidget];
					if([baseView viewWithTag:504] != nil) {
						fourthWidgetTag = 504;
					}
				}
				break;
			default:
				if(fourthWidgetTag == 501) {
					UILabel *emptyWidget = [baseView viewWithTag:501];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
				}
				else {
					if(fourthWidgetTag != 0) {
						[[baseView viewWithTag:fourthWidgetTag] removeFromSuperview];
					}
					UILabel *emptyWidget = [[EmerWidgetController sharedInstance] emptyWidget];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
					emptyWidget.tag = 501;
					[[baseView viewWithTag:14] addSubview:emptyWidget];
					if([baseView viewWithTag:501] != nil) {
						fourthWidgetTag = 501;
					}
				}
				break;
		}
		switch([fifthWidgetValue longValue]) {
			case 1: //IP
				if(fifthWidgetTag == 602) {
					UIView *ipWidget = [baseView viewWithTag:602];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
				}
				else { //was another widget
					if(fifthWidgetTag != 0) {
						[[baseView viewWithTag:fifthWidgetTag] removeFromSuperview];
					}
					UIView *ipWidget = [[EmerWidgetController sharedInstance] ipWidget];
					ipWidget.hidden = NO;
					ipWidget.alpha = 1;
					ipWidget.tag = 602;
					[[baseView viewWithTag:15] addSubview:ipWidget];
					if([baseView viewWithTag:602] != nil) {
						fifthWidgetTag = 602;
					}
				}
				break;
			case 2: //PERSONAL HOTSPOT
				if(fifthWidgetTag == 603) {
					UIView *phWidget = [baseView viewWithTag:603];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
				}
				else { //was another widget
					if(fifthWidgetTag != 0) {
						[[baseView viewWithTag:fifthWidgetTag] removeFromSuperview];
					}
					UIView *phWidget = [[EmerWidgetController sharedInstance] phWidget];
					phWidget.hidden = NO;
					phWidget.alpha = 1;
					phWidget.tag = 603;
					[[baseView viewWithTag:15] addSubview:phWidget];
					if([baseView viewWithTag:603] != nil) {
						fifthWidgetTag = 603;
					}
				}
				break;
			case 3: //TWITTER
				if(fifthWidgetTag == 604) {
					UIView *twitterWidget = [baseView viewWithTag:604];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
				}
				else { //was another widget
					if(fifthWidgetTag != 0) {
						[[baseView viewWithTag:fifthWidgetTag] removeFromSuperview];
					}
					UIView *twitterWidget = [[EmerWidgetController sharedInstance] twitterWidget];
					twitterWidget.hidden = NO;
					twitterWidget.alpha = 1;
					twitterWidget.tag = 604;
					[[baseView viewWithTag:15] addSubview:twitterWidget];
					if([baseView viewWithTag:604] != nil) {
						firstWidgetTag = 604;
					}
				}
				break;
			default:
				if(fifthWidgetTag == 601) {
					UILabel *emptyWidget = [baseView viewWithTag:601];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
				}
				else {
					if(fifthWidgetTag != 0) {
						[[baseView viewWithTag:fifthWidgetTag] removeFromSuperview];
					}
					UILabel *emptyWidget = [[EmerWidgetController sharedInstance] emptyWidget];
					emptyWidget.hidden = NO;
					emptyWidget.alpha = 1;
					emptyWidget.tag = 601;
					[[baseView viewWithTag:15] addSubview:emptyWidget];
					if([baseView viewWithTag:601] != nil) {
						fifthWidgetTag = 601;
					}
				}
				break;
		}

		if(![[baseView viewWithTag:112] isEqual:nil]) { //if one widget is twitter
			id primaryTwitterInfo = [userPrefs valueForKey:@"primaryTwitterInfo"];
			//id twitterAccount = [userPrefs valueForKey:@"twitterAccount"];
			UILabel *twitterInfoLittle = [baseView viewWithTag:112];
			if([primaryTwitterInfo isEqual:@1]) { //followers
				// NSString *url = @"https://cdn.syndication.twimg.com/widgets/followbutton/info.json?screen_names=";

				// NSError __block *err = NULL;
				// NSData __block *data;
				// NSURLResponse __block *resp;
				// NSDictionary __block *responseDict;
				// NSString __block *followers = @"a";

				// NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAppendingString:twitterAccount]]];
				// [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
				// [postRequest setValue:@"0" forHTTPHeaderField:@"if-modified-since"];
				// [postRequest setValue:@"gzip, deflate, br" forHTTPHeaderField:@"Accept-Encoding"];
				// [postRequest setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept-Language"];
				// [postRequest setHTTPMethod:@"GET"];

				// [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
				// 	resp = _response;
				// 	err = _error;
				// 	data = _data;
				// 	responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
				// 	for(NSDictionary* key in responseDict) {
				// 		followers = key[@"followers_count"];
				// 	}
				// 	twitterInfoLittle.text = followers;
				// }] resume];
				twitterInfoLittle.text = @"nsm";
			}
			else { //notifs
				twitterInfoLittle.text = @"Error";
			}
		}

		//after switchs
		[[EmerController sharedInstance] bringWidgetPassThroughViewsToFront];
		[[EmerController sharedInstance] setWidgetsAlpha:1];
		[[EmerWidgetController sharedInstance] hideExpandedWidgets];

		if(enabled == YES) {
			CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
			if(arg1 == YES) {
				UILabel *dateLabel = [baseView viewWithTag:1];
				dateLabel.frame = CGRectMake(screenWidth - 225,81,200,30);

				MSHookIvar<double>(self, "_statusBarHeightAdjustmentForCurrentOrientation");

				MSHookIvar<double>(self, "_headerViewHeight"); //?
				MSHookIvar<double>(self, "_footerViewHeight");

				_UIBatteryView *battery = [baseView viewWithTag:5];
				battery.frame = CGRectMake([[EmerController sharedInstance] screenWidth] - 50, 65, 24.5, 11.5);

				[baseView setHidden:NO];
				isUnlocked = YES;
				baseView.frame = CGRectMake(0,-288,screenWidth,258);
				baseView.alpha = 0;
				[UIView animateWithDuration:0.5 animations:^{
					baseView.frame = CGRectMake(0,-30,screenWidth,258);
					baseView.alpha = 1;
				}];
			}
			else {
				[baseView setHidden:YES];
				isUnlocked = NO;
			}
		}
	}

	%end

	//lower search bar
	%hook SBUISpotlightBarNavigationController

	-(double)_statusBarHeightAdjustmentForCurrentOrientation {
		if(enabled && isUnlocked) {
			return 200;
		}
		else {
			return %orig;
		}
	}

	%end

	//battery info
	%hook _UIBatteryView

	-(double)chargePercent {
		_UIBatteryView *battery = [baseView viewWithTag:5];
	 	battery.chargePercent = %orig;

		return %orig;
	}

	-(BOOL)saverModeActive {
		_UIBatteryView *battery = [baseView viewWithTag:5];
	 	battery.saverModeActive = %orig;

		return %orig;
	}

	-(NSInteger)chargingState {
	 	_UIBatteryView *battery = [baseView viewWithTag:5];
	 	battery.chargingState = %orig;

		return %orig;
	}

	%end

	//update wifi
	%hook SBWiFiManager

	-(id)currentNetworkName {
		UILabel *local = [baseView viewWithTag:101];
		NSString *newIP = [[EmerWidgetController sharedInstance] deviceIPAddressForType:0];
		if(local.text != newIP) {
			local.alpha = 1;
			[UIView animateWithDuration:0.3 animations:^{
				local.alpha = 0;
			} completion:^(BOOL finished){
				if (finished) { //last expandedWidget will be kept
					local.text = newIP;
					[UIView animateWithDuration:0.3 animations:^{
						local.alpha = 1;
					}];
				}
			}];
		}
		UILabel *localIP = [baseView viewWithTag:104];
		localIP.text = [[[@"Local: " stringByAppendingString:[[EmerWidgetController sharedInstance] deviceIPAddressForType:0]] stringByAppendingString:@"   Public: "] stringByAppendingString:[[EmerWidgetController sharedInstance] deviceIPAddressForType:1]];

		return %orig;
	}

	%end

	// %hook WFHotspotCell

	// -(void)setState:(long long)arg1 {
	// 	%orig;

	// 	UILabel *phDevices = [baseView viewWithTag:108];
	// 	NSString *newText = @"Error while fetching devices";
	// 	if(arg1 == 0) {
	// 		newText = @"Off";
	// 	} else if(arg1 == 1) {
	// 		newText = @"On";
	// 	}
	// 	if(phDevices.text != newText) {
	// 		phDevices.alpha = 1;
	// 		[UIView animateWithDuration:0.3 animations:^{
	// 			phDevices.alpha = 0;
	// 		} completion:^(BOOL finished){
	// 			if (finished) { //last expandedWidget will be kept
	// 				phDevices.text = newText;
	// 				[UIView animateWithDuration:0.3 animations:^{
	// 					phDevices.alpha = 1;
	// 				}];
	// 			}
	// 		}];
	// 	}
	// 	UILabel *expandedPHDevices = [baseView viewWithTag:109];
	// 	expandedPHDevices.text = @"yes";
	// }

	// %end

%end

static void changeEnabled() {
	if(enabled == NO) {

		[baseView setHidden:NO];
		enabled = YES;

		NSLocale* currentLocale = [NSLocale currentLocale];
        [[NSDate date] descriptionWithLocale:currentLocale]; 

        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init]; 
        [dateFormatter setLocalizedDateFormatFromTemplate:@"MMMMd"];

        NSString *processedDateString = [dateFormatter stringFromDate:[NSDate date]];
		UILabel *time = [baseView viewWithTag:1];

		time.text = processedDateString;

        [dateFormatter setLocalizedDateFormatFromTemplate:@"HH:mm"];

        processedDateString = [dateFormatter stringFromDate:[NSDate date]];
		UILabel *date = [baseView viewWithTag:2];

		date.text = processedDateString;
	}
	else {
		[baseView setHidden:YES];
		enabled = NO;
	}
}

%ctor {
  	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)changeEnabled, CFSTR("com.liven.emerprefs-enable"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	%init;

	%init(Tweak);

	changeEnabled();
	NSDictionary *userPrefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.liven.emerprefs"];

	id isEnabled = [userPrefs valueForKey:@"enabled"];

	if([isEnabled isEqual:@0]) {
		enabled = NO;
		[baseView setHidden:YES];
	}
	else {
		enabled = YES;
	}

}