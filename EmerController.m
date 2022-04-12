#import "EmerController.h"
#import "SparkColourPickerUtils.h"

@implementation EmerController

UIScrollView *cardBlurContainerScrollView;
UIView *firstWidget;
UIView *secondWidget;
UIView *thirdWidget;
UIView *fourthWidget;
UIView *fifthWidget;
UIView *expandedWidgetView;
UIView *expandedWidgetTouchPassThroughView;
UIView *firstWidgetTouchPassThroughView;
UIView *secondWidgetTouchPassThroughView;
UIView *thirdWidgetTouchPassThroughView;
UIView *fourthWidgetTouchPassThroughView;
UIView *fifthWidgetTouchPassThroughView;

UIView *expandedWidget;

long widgetTag = 0;
long widgetNameTag = 0;

+(id)sharedInstance {
    static EmerController *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init {
    if(self = [super init]) {
        NSLog(@"Emer has been initialized (EmerController)");
    }
    return self;
}

-(CGFloat)screenWidth {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    return screenWidth;
}

-(UIVisualEffectView *)baseCard:(NSString *)arg1 {
    NSDictionary *userPrefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.liven.emerprefs"];
    id backType = [userPrefs valueForKey:@"cardBackgroundType"];
    UIBlurEffect *blurEffect;
    NSString *colorString = NULL;
    UIColor *selectedColor;
    if([backType isEqual:@1]) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];
    }
    else if([backType isEqual:@2]) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialLight];
    }
    else if([backType isEqual:@3]) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterial];
    }
    else if([backType isEqual:@4]) {
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialLight]; //CUSTOM COLOR NOT DONE : TEMPORARY
        colorString = [userPrefs objectForKey:@"cardBackgroundColor"];
        selectedColor = [SparkColourPickerUtils colourWithString:colorString withFallback:@"#ffffff"];
    }
    else { //default value in prefs
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];
    }

    if([arg1 isEqual:@"front"]) {
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		blurEffectView.frame = CGRectMake(0,-30,[self screenWidth],248);
		blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if([backType isEqual:@4]) {
            blurEffectView.backgroundColor = selectedColor;
        }
		blurEffectView.layer.cornerRadius = 20;
		blurEffectView.layer.masksToBounds = true;
		
        return blurEffectView;
    }
    else if([arg1 isEqual:@"back"]) {
        UIVisualEffectView *backBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		backBlurEffectView.frame = CGRectMake(10,-20,[self screenWidth] - 20,248);
		backBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if([backType isEqual:@4]) {
            backBlurEffectView.backgroundColor = selectedColor;
        }
		backBlurEffectView.layer.cornerRadius = 20;
		backBlurEffectView.layer.masksToBounds = true;

        return backBlurEffectView;
    }
    else { //still return back yeah its crap
        UIVisualEffectView *backBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		backBlurEffectView.frame = CGRectMake(10,-20,[self screenWidth] - 20,248);
		backBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if([backType isEqual:@4]) {
            backBlurEffectView.backgroundColor = selectedColor;
        }
		backBlurEffectView.layer.cornerRadius = 20;
		backBlurEffectView.layer.masksToBounds = true;

        return backBlurEffectView;
    }
}
    
-(UILabel *)dateLabel {
    NSLocale* currentLocale = [NSLocale currentLocale];
	[[NSDate date] descriptionWithLocale:currentLocale]; 

 	NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init]; 
	[dateFormatter setLocalizedDateFormatFromTemplate:@"MMMMd"];

    NSString *processedDateString = [dateFormatter stringFromDate:[NSDate date]];

    CGRect dateFrame = CGRectMake([self screenWidth] - 225,81,200,30);
	UILabel *dateLabel = [[UILabel alloc] initWithFrame:dateFrame];
	dateLabel.text = processedDateString;
	dateLabel.numberOfLines = 1;
	dateLabel.adjustsFontSizeToFitWidth = YES;
	dateLabel.textAlignment = NSTextAlignmentRight;
	dateLabel.minimumScaleFactor = 10.0f/12.0f;
	dateLabel.textColor = [UIColor whiteColor];
	dateLabel.font = [UIFont boldSystemFontOfSize:24];
	dateLabel.tag = 1;

    return dateLabel;
}

-(UIVisualEffectView *)cardBlurContainer {
	UIBlurEffect *lightBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *cardBlurContainer = [[UIVisualEffectView alloc] initWithEffect:lightBlurEffect];
	cardBlurContainer.frame = CGRectMake(20,120,[self screenWidth] - 40,80);
	cardBlurContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	cardBlurContainer.layer.cornerRadius = 16;
	cardBlurContainer.layer.masksToBounds = true;

    return cardBlurContainer;
}

-(UIScrollView *)cardBlurContainerScrollView {
    cardBlurContainerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20,120,[self screenWidth] - 40,80)];
    cardBlurContainerScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    cardBlurContainerScrollView.contentSize = CGSizeMake(374,80); //change widget for testing purposes
    cardBlurContainerScrollView.backgroundColor = [UIColor clearColor];
    cardBlurContainerScrollView.tag = 3;
	cardBlurContainerScrollView.layer.cornerRadius = 16;
	cardBlurContainerScrollView.layer.masksToBounds = true;
    
    return cardBlurContainerScrollView;
}

-(void)bringWidgetPassThroughViewsToFront {
    [cardBlurContainerScrollView bringSubviewToFront:firstWidgetTouchPassThroughView];
    [cardBlurContainerScrollView bringSubviewToFront:secondWidgetTouchPassThroughView];
    [cardBlurContainerScrollView bringSubviewToFront:thirdWidgetTouchPassThroughView];
    [cardBlurContainerScrollView bringSubviewToFront:fourthWidgetTouchPassThroughView];
    [cardBlurContainerScrollView bringSubviewToFront:fifthWidgetTouchPassThroughView];
}

-(CGRect)widgetContainerFrame {
    CGRect widgetContainerFrame = CGRectMake(20,120,[self screenWidth] - 40,80);
    widgetContainerFrame.origin.y = widgetContainerFrame.origin.y + 10;
    widgetContainerFrame.origin.x = widgetContainerFrame.origin.x + 17;
    widgetContainerFrame.size.width = widgetContainerFrame.size.width - 34;
    widgetContainerFrame.size.height = widgetContainerFrame.size.height - 20;

    return widgetContainerFrame;
}

-(UILabel *)timeLabel {
    NSLocale* currentLocale = [NSLocale currentLocale];
	[[NSDate date] descriptionWithLocale:currentLocale]; 

    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init]; 
	[dateFormatter setLocalizedDateFormatFromTemplate:@"HH:mm"];

    NSString *processedTimeString = [dateFormatter stringFromDate:[NSDate date]];
        
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,60,150,53)];
    timeLabel.text = processedTimeString;
    timeLabel.numberOfLines = 1;
    timeLabel.adjustsFontSizeToFitWidth = YES;
	timeLabel.textAlignment = NSTextAlignmentLeft;
	timeLabel.minimumScaleFactor = 10.0f/12.0f;
	timeLabel.textColor = [UIColor whiteColor];
	timeLabel.font = [UIFont boldSystemFontOfSize:48];
	timeLabel.tag = 2;

    return timeLabel;
}

-(long)displayWidget:(long)widget forTag:(long)tag forBaseView:(UIView *)baseView forOldValue:(long)oldValue forWidgetName:(NSString *)name {
    if(oldValue == tag) {
        UIView *widgetToUse = [[baseView viewWithTag:widget] viewWithTag:tag];
		widgetToUse.hidden = NO;
		widgetToUse.alpha = 1;

        return 0;
    }
    else { //was another widget
        if(oldValue != 0) {
            [[[baseView viewWithTag:widget] viewWithTag:oldValue] removeFromSuperview];
        }

        UIView *widgetToAdd;
        
        if([name isEqual:@"ipWidget"]) {
            widgetToAdd = [[EmerWidgetController sharedInstance] ipWidget];
        } 
        else if([name isEqual:@"phWidget"]) {
            widgetToAdd = [[EmerWidgetController sharedInstance] phWidget];
        } 
        else if([name isEqual:@"emptyWidget"]) {
            widgetToAdd = [[EmerWidgetController sharedInstance] emptyWidget];
        }

		widgetToAdd.hidden = NO;
		widgetToAdd.alpha = 1;
		widgetToAdd.tag = tag;
		[[baseView viewWithTag:widget] addSubview:widgetToAdd];
		if([[baseView viewWithTag:widget] viewWithTag:oldValue] != nil) {
			return tag;
		}
        else return 0;
    }
}

-(void)showExpandedWidgetForPrefsValue:(NSString *)value {
    NSDictionary *userPrefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:@"com.liven.emerprefs"];
    id widgetValue = [userPrefs valueForKey:value];

    switch([widgetValue longValue]) {
        case 1: //IP
            [[EmerWidgetController sharedInstance] showViewForWidget:103];
            break;
        case 2: //PERSONAL HOTSPOT
            [[EmerWidgetController sharedInstance] showViewForWidget:110];
            break;
        case 3: //TWITTER
            [[EmerWidgetController sharedInstance] showViewForWidget:113];
            break;
        default:
            [[EmerWidgetController sharedInstance] showViewForWidget:106];
            break;
    }
}

-(UIView *)firstWidget {
    firstWidget = [[UIView alloc] initWithFrame:CGRectMake(17, 10, 60, 60)]; //(37, 130, 60, 60)
    firstWidget.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00];
    firstWidget.layer.cornerRadius = 18;
    firstWidget.tag = 11;

    return firstWidget;
}

-(void)firstWidgetTapped:(UIGestureRecognizer *)recognizer {
    expandedWidget = firstWidget;

    firstWidgetTouchPassThroughView.hidden = YES;

    [self showExpandedWidgetForPrefsValue:@"FirstWidget"];

    expandedWidgetView.frame = CGRectMake([firstWidget convertRect:firstWidget.frame toView:nil].origin.x - firstWidget.frame.origin.x, 130, 60, 60);
    expandedWidgetView.hidden = NO;

    expandedWidgetTouchPassThroughView.frame = CGRectMake([firstWidget convertRect:firstWidget.frame toView:nil].origin.x - firstWidget.frame.origin.x, 130, 60, 60);

    [self setWidgetsAlpha:1];

    [UIView animateWithDuration:0.3  delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setWidgetsAlpha:0];

        expandedWidgetView.frame = [self widgetContainerFrame];
        expandedWidgetTouchPassThroughView.frame = [self widgetContainerFrame];
    } completion:nil];
}

-(UIView *)secondWidget {
    secondWidget = [[UIView alloc] initWithFrame:CGRectMake(90, 10, 60, 60)]; //(107, 130, 60, 60)
    secondWidget.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00];
    secondWidget.layer.cornerRadius = 18;
    secondWidget.tag = 12;

    return secondWidget;
}

-(void)secondWidgetTapped:(UIGestureRecognizer *)recognizer {
    expandedWidget = secondWidget;

    secondWidgetTouchPassThroughView.hidden = YES;

    [self showExpandedWidgetForPrefsValue:@"SecondWidget"];

    expandedWidgetView.frame = CGRectMake([secondWidget convertRect:secondWidget.frame toView:nil].origin.x - secondWidget.frame.origin.x, 130, 60, 60);
    expandedWidgetView.hidden = NO;

    expandedWidgetTouchPassThroughView.frame = CGRectMake([secondWidget convertRect:secondWidget.frame toView:nil].origin.x - secondWidget.frame.origin.x, 130, 60, 60);

    [self setWidgetsAlpha:1];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setWidgetsAlpha:0];

        expandedWidgetView.frame = [self widgetContainerFrame];
        expandedWidgetTouchPassThroughView.frame = [self widgetContainerFrame];
    } completion:nil];
}

-(UIView *)thirdWidget {
    thirdWidget = [[UIView alloc] initWithFrame:CGRectMake(160, 10, 60, 60)]; //(177, 130, 60, 60)
    thirdWidget.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00];
    thirdWidget.layer.cornerRadius = 18;
    thirdWidget.tag = 13;

    return thirdWidget;
}

-(void)thirdWidgetTapped:(UIGestureRecognizer *)recognizer {
    expandedWidget = thirdWidget;

    thirdWidgetTouchPassThroughView.hidden = YES;

    [self showExpandedWidgetForPrefsValue:@"ThirdWidget"];

    expandedWidgetView.frame = CGRectMake([thirdWidget convertRect:thirdWidget.frame toView:nil].origin.x - thirdWidget.frame.origin.x, 130, 60, 60);
    expandedWidgetView.hidden = NO;

    expandedWidgetTouchPassThroughView.frame = CGRectMake([thirdWidget convertRect:thirdWidget.frame toView:nil].origin.x - thirdWidget.frame.origin.x, 130, 60, 60);

    [self setWidgetsAlpha:1];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setWidgetsAlpha:0];

        expandedWidgetView.frame = [self widgetContainerFrame];
        expandedWidgetTouchPassThroughView.frame = [self widgetContainerFrame];
    } completion:nil];
}

-(UIView *)fourthWidget {
    fourthWidget = [[UIView alloc] initWithFrame:CGRectMake(230, 10, 60, 60)]; //(247, 130, 60, 60)
    fourthWidget.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00];
    fourthWidget.layer.cornerRadius = 18;
    fourthWidget.tag = 14;

    return fourthWidget;
}

-(void)fourthWidgetTapped:(UIGestureRecognizer *)recognizer {
    expandedWidget = fourthWidget;

    fourthWidgetTouchPassThroughView.hidden = YES;

    [self showExpandedWidgetForPrefsValue:@"FourthWidget"];

    expandedWidgetView.frame = CGRectMake([fourthWidget convertRect:fourthWidget.frame toView:nil].origin.x - fourthWidget.frame.origin.x, 130, 60, 60);
    expandedWidgetView.hidden = NO;

    expandedWidgetTouchPassThroughView.frame = CGRectMake([fourthWidget convertRect:fourthWidget.frame toView:nil].origin.x - fourthWidget.frame.origin.x, 130, 60, 60);

    [self setWidgetsAlpha:1];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setWidgetsAlpha:0];

        expandedWidgetView.frame = [self widgetContainerFrame];
        expandedWidgetTouchPassThroughView.frame = [self widgetContainerFrame];
    } completion:nil];
}

-(UIView *)fifthWidget{
    fifthWidget = [[UIView alloc] initWithFrame:CGRectMake(300, 10, 60, 60)]; //(317, 130, 60, 60)
    fifthWidget.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00];
    fifthWidget.layer.cornerRadius = 18;
    fifthWidget.tag = 15;

    return fifthWidget;
}

-(void)fifthWidgetTapped:(UIGestureRecognizer *)recognizer {
    expandedWidget = fifthWidget;

    fifthWidgetTouchPassThroughView.hidden = YES;

    [self showExpandedWidgetForPrefsValue:@"FifthWidget"];

    expandedWidgetView.frame = CGRectMake([fifthWidget convertRect:fifthWidget.frame toView:nil].origin.x - fifthWidget.frame.origin.x, 130, 60, 60);
    expandedWidgetView.hidden = NO;

    expandedWidgetTouchPassThroughView.frame = CGRectMake([fifthWidget convertRect:fifthWidget.frame toView:nil].origin.x - fifthWidget.frame.origin.x, 130, 60, 60);

    [self setWidgetsAlpha:1];

    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self setWidgetsAlpha:0];

        expandedWidgetView.frame = [self widgetContainerFrame];
        expandedWidgetTouchPassThroughView.frame = [self widgetContainerFrame];
    } completion:nil];
}

-(void)setWidgetsAlpha:(long)alpha {
    firstWidget.alpha = alpha;
    secondWidget.alpha = alpha;
    thirdWidget.alpha = alpha;
    fourthWidget.alpha = alpha;
    fifthWidget.alpha = alpha;

    [[EmerWidgetController sharedInstance] setWidgetsAlpha:alpha];
}

-(UIView *)firstWidgetTouchPassThroughView {
    firstWidgetTouchPassThroughView = [[UIView alloc] initWithFrame:firstWidget.frame];
    firstWidgetTouchPassThroughView.backgroundColor = [UIColor clearColor];
    firstWidgetTouchPassThroughView.layer.cornerRadius = 18;
    firstWidgetTouchPassThroughView.tag = 16;

    UITapGestureRecognizer *gesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstWidgetTapped:)];
    [gesture setNumberOfTapsRequired:1];
    [firstWidgetTouchPassThroughView addGestureRecognizer:gesture];

    return firstWidgetTouchPassThroughView;
}

-(UIView *)secondWidgetTouchPassThroughView {
    secondWidgetTouchPassThroughView = [[UIView alloc] initWithFrame:secondWidget.frame];
    secondWidgetTouchPassThroughView.backgroundColor = [UIColor clearColor];
    secondWidgetTouchPassThroughView.layer.cornerRadius = 18;
    secondWidgetTouchPassThroughView.tag = 17;

    UITapGestureRecognizer *gesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondWidgetTapped:)];
    [gesture setNumberOfTapsRequired:1];
    [secondWidgetTouchPassThroughView addGestureRecognizer:gesture];

    return secondWidgetTouchPassThroughView;
}

-(UIView *)thirdWidgetTouchPassThroughView {
    thirdWidgetTouchPassThroughView = [[UIView alloc] initWithFrame:thirdWidget.frame];
    thirdWidgetTouchPassThroughView.backgroundColor = [UIColor clearColor];
    thirdWidgetTouchPassThroughView.layer.cornerRadius = 18;
    thirdWidgetTouchPassThroughView.tag = 18;

    UITapGestureRecognizer *gesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdWidgetTapped:)];
    [gesture setNumberOfTapsRequired:1];
    [thirdWidgetTouchPassThroughView addGestureRecognizer:gesture];

    return thirdWidgetTouchPassThroughView;
}

-(UIView *)fourthWidgetTouchPassThroughView {
    fourthWidgetTouchPassThroughView = [[UIView alloc] initWithFrame:fourthWidget.frame];
    fourthWidgetTouchPassThroughView.backgroundColor = [UIColor clearColor];
    fourthWidgetTouchPassThroughView.layer.cornerRadius = 18;
    fourthWidgetTouchPassThroughView.tag = 19;

    UITapGestureRecognizer *gesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fourthWidgetTapped:)];
    [gesture setNumberOfTapsRequired:1];
    [fourthWidgetTouchPassThroughView addGestureRecognizer:gesture];

    return fourthWidgetTouchPassThroughView;
}

-(UIView *)fifthWidgetTouchPassThroughView {
    fifthWidgetTouchPassThroughView = [[UIView alloc] initWithFrame:fifthWidget.frame];
    fifthWidgetTouchPassThroughView.backgroundColor = [UIColor clearColor];
    fifthWidgetTouchPassThroughView.layer.cornerRadius = 18;
    fifthWidgetTouchPassThroughView.tag = 20;

    UITapGestureRecognizer *gesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fifthWidgetTapped:)];
    [gesture setNumberOfTapsRequired:1];
    [fifthWidgetTouchPassThroughView addGestureRecognizer:gesture];

    return fifthWidgetTouchPassThroughView;
}

-(void)showWidgetsTouchPassThroughView {
    firstWidgetTouchPassThroughView.alpha = 1;
    firstWidgetTouchPassThroughView.hidden = NO;
    secondWidgetTouchPassThroughView.alpha = 1;
    secondWidgetTouchPassThroughView.hidden = NO;
    thirdWidgetTouchPassThroughView.alpha = 1;
    thirdWidgetTouchPassThroughView.hidden = NO;
    fourthWidgetTouchPassThroughView.alpha = 1;
    fourthWidgetTouchPassThroughView.hidden = NO;
    fifthWidgetTouchPassThroughView.alpha = 1;
    fifthWidgetTouchPassThroughView.hidden = NO;
}

-(UIView *)expandedWidgetView {
    expandedWidgetView = [[UIView alloc] initWithFrame:CGRectZero];
    expandedWidgetView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    expandedWidgetView.backgroundColor = [UIColor colorWithRed: 0.80 green: 0.80 blue: 0.80 alpha: 1.00];
    expandedWidgetView.layer.masksToBounds = YES;
    expandedWidgetView.layer.cornerRadius = 18;
    expandedWidgetView.tag = 4;

    expandedWidgetView.hidden = YES;

    return expandedWidgetView;
}

-(UIView *)expandedWidgetTouchPassThroughView {
    expandedWidgetTouchPassThroughView = [[UIView alloc] initWithFrame:CGRectZero];
    expandedWidgetTouchPassThroughView.backgroundColor = [UIColor clearColor];
    expandedWidgetTouchPassThroughView.layer.cornerRadius = 18;
    expandedWidgetTouchPassThroughView.tag = 6;

    UITapGestureRecognizer *gesture =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expandedWidgetTouchPassThroughViewTapped:)];
    [gesture setNumberOfTapsRequired:1];
    [expandedWidgetTouchPassThroughView addGestureRecognizer:gesture];

    return expandedWidgetTouchPassThroughView;
}

-(void)expandedWidgetTouchPassThroughViewTapped:(UIGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setWidgetsAlpha:1];

        expandedWidgetView.frame = CGRectMake([expandedWidget convertRect:expandedWidget.frame toView:nil].origin.x - expandedWidget.frame.origin.x, 130, 60, 60);
        expandedWidgetTouchPassThroughView.frame = CGRectMake([expandedWidget convertRect:expandedWidget.frame toView:nil].origin.x - expandedWidget.frame.origin.x, 130, 60, 60);
    }
    completion:^(BOOL finished){
        if (finished) { //last expandedWidget will be kept
            firstWidgetTouchPassThroughView.hidden = NO;
            secondWidgetTouchPassThroughView.hidden = NO;
            thirdWidgetTouchPassThroughView.hidden = NO;
            fourthWidgetTouchPassThroughView.hidden = NO;
            fifthWidgetTouchPassThroughView.hidden = NO;
            expandedWidgetView.frame = CGRectZero;
            expandedWidgetTouchPassThroughView.frame = CGRectZero;
            [[EmerWidgetController sharedInstance] hideExpandedWidgets];
        }
    }];
}

-(_UIBatteryView *)battery {
    _UIBatteryView *battery = [[_UIBatteryView alloc] initWithFrame:CGRectMake([self screenWidth] - 50, 65, 24.5, 11.5)];
    battery.showsPercentage = NO;
    battery.lowBatteryChargePercentThreshold = 0.20;
    battery.showsInlineChargingIndicator = YES;
    battery.tag = 5;

    return battery;
}

@end