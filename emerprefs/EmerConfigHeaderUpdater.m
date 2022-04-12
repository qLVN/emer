#import "EmerConfigHeaderUpdater.h"
#import <AudioToolbox/AudioServices.h>

@implementation EmerConfigHeaderUpdater

    UILabel *configTime; //1
    UILabel *configDate; //2

    UIImageView *firstWidget; //11
    UIImageView *secondWidget; //12
    UIImageView *thirdWidget; //13
    UIImageView *fourthWidget; //14
    UIImageView *fifthWidget; //15

    +(id)sharedInstance {
        static EmerConfigHeaderUpdater *sharedInstance = nil;
        static dispatch_once_t oncePredicate;
        dispatch_once(&oncePredicate, ^{
            sharedInstance = [[self alloc] init];
        });
        return sharedInstance;
    }

    -(id)init {
        if(self = [super init]) {
            NSLog(@"EmerConfigHeaderUpdater has been initialized");
        }
        return self;
    }

    -(NSString *)emptyWidgetImagePath {
        //Make all [UIScreen mainScreen].scale compatibility!
        NSString *emptyWidgetImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/emptyWidgetIcon@3x.png"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:emptyWidgetImagePath]) {
            emptyWidgetImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/emptyWidgetIcon@3x.png"];
        }
        return emptyWidgetImagePath;
    }

    -(UILabel *)configTime {
        configTime = [[UILabel alloc] initWithFrame:CGRectZero];
        configTime.text = @"9:41";
        configTime.numberOfLines = 1;
        configTime.adjustsFontSizeToFitWidth = YES;
        configTime.textAlignment = NSTextAlignmentLeft;
        configTime.clipsToBounds = YES;
        configTime.minimumScaleFactor = 10.0f/12.0f;
        configTime.textColor = [UIColor whiteColor];
        configTime.font = [UIFont boldSystemFontOfSize:48];
        configTime.tag = 1;

        return configTime;
    }

    -(UILabel *)configDate {
        configDate = [[UILabel alloc] initWithFrame:CGRectZero];
        configDate.text = @"June 29";
        configDate.numberOfLines = 1;
        configDate.adjustsFontSizeToFitWidth = YES;
        configDate.textAlignment = NSTextAlignmentRight;
        configDate.clipsToBounds = YES;
        configDate.minimumScaleFactor = 10.0f/12.0f;
        configDate.textColor = [UIColor whiteColor];
        configDate.font = [UIFont boldSystemFontOfSize:24];
        configDate.tag = 2;

        return configDate;
    }

    //Quick Widgets

    -(UIImageView *)firstWidget { //Get prefs
        firstWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self emptyWidgetImagePath]]];
        firstWidget.backgroundColor = [UIColor clearColor];
        firstWidget.contentMode = UIViewContentModeScaleAspectFill;
        return firstWidget;
    }

    -(UIImageView *)secondWidget { //Get prefs
        secondWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self emptyWidgetImagePath]]];
        secondWidget.backgroundColor = [UIColor clearColor];
        secondWidget.contentMode = UIViewContentModeScaleAspectFill;
        return secondWidget;
    }

    -(UIImageView *)thirdWidget { //Get prefs
        thirdWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self emptyWidgetImagePath]]];
        thirdWidget.backgroundColor = [UIColor clearColor];
        thirdWidget.contentMode = UIViewContentModeScaleAspectFill;
        return thirdWidget;
    }

    -(UIImageView *)fourthWidget { //Get prefs
        fourthWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self emptyWidgetImagePath]]];
        fourthWidget.backgroundColor = [UIColor clearColor];
        fourthWidget.contentMode = UIViewContentModeScaleAspectFill;
        return fourthWidget;
    }

    -(UIImageView *)fifthWidget { //Get prefs
        fifthWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[self emptyWidgetImagePath]]];
        fifthWidget.backgroundColor = [UIColor clearColor];
        fifthWidget.contentMode = UIViewContentModeScaleAspectFill;
        return fifthWidget;
    }


    -(void)updateConfigViewForObject:(long)object newValue:(long)value {
        AudioServicesPlaySystemSound(1521);
        configTime.center = CGPointMake(10,20);
        //configTime.text = @"je pleure";
        switch(object) {
            default:
                break;
            case 1:
                //For now no settings for configTime
                //configTime.text = @"je pleure";
                break;
            case 2:
                //For now no settings for configDate
                break;
            case 11:
                //WIP
                break;  
        }
    }

    -(void)setCenter:(CGPoint)center forObject:(long)object {
        switch(object) {
            default:
                break;
            case 1:
                [configTime sizeToFit];
                configTime.center = center;
                break;
            case 2:
                [configDate sizeToFit];
                configDate.center = center;
                break;
        }
    }

    -(void)setFrame:(CGRect)frame forObject:(long)object {
        switch(object) {
            default:
                break;
            case 11:
                firstWidget.frame = frame;
                break;
            case 12:
                secondWidget.frame = frame;
                break;
            case 13:
                thirdWidget.frame = frame;
                break;
            case 14:
                fourthWidget.frame = frame;
                break;
            case 15:
                fifthWidget.frame = frame;
                break;
        }
    }

@end