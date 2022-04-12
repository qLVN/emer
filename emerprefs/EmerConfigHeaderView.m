#import "EmerConfigHeaderView.h"

@implementation EmerConfigHeaderView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if(self) {
        self.container = [[UIView alloc] initWithFrame:CGRectZero];
        self.container.backgroundColor = [UIColor clearColor];

        [self addSubview:self.container];

        NSString *suffix = @".png";

        switch ((int)[UIScreen mainScreen].scale) {
            case 2:
                suffix = @"@2x.png";
                break;
            case 3:
                suffix = @"@3x.png";
                break;
            default:
                break;
        }

    NSString *configImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/configBackground%@", suffix];

    if (![[NSFileManager defaultManager] fileExistsAtPath:configImagePath]) {
        configImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/configBackground%@", suffix];
    }

    self.configBackground = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:configImagePath]];
    self.configBackground.backgroundColor = [UIColor clearColor];
    self.configBackground.contentMode = UIViewContentModeScaleAspectFill;

    [self.container addSubview:self.configBackground];

    // self.configTime = [[UILabel alloc] initWithFrame:CGRectZero];
    // self.configTime.text = @"9:41";
    // self.configTime.numberOfLines = 1;
    // self.configTime.adjustsFontSizeToFitWidth = YES;
    // self.configTime.textAlignment = NSTextAlignmentLeft;
	// self.configTime.clipsToBounds = YES;
	// self.configTime.minimumScaleFactor = 10.0f/12.0f;
	// self.configTime.textColor = [UIColor whiteColor];
	// self.configTime.font = [UIFont boldSystemFontOfSize:48];
    // self.configTime.tag = 1;

    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] configTime]];

    // self.configDate = [[UILabel alloc] initWithFrame:CGRectZero];
    // self.configDate.text = @"June 29";
	// self.configDate.numberOfLines = 1;
	// self.configDate.adjustsFontSizeToFitWidth = YES;
	// self.configDate.textAlignment = NSTextAlignmentRight;
	// self.configDate.clipsToBounds = YES;
	// self.configDate.minimumScaleFactor = 10.0f/12.0f;
	// self.configDate.textColor = [UIColor whiteColor];
	// self.configDate.font = [UIFont boldSystemFontOfSize:24];

    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] configDate]];

    //Widgets Quick Views

    // NSString *emptyWidgetImagePath = [NSString stringWithFormat:@"/Library/PreferenceBundles/emerPrefs.bundle/emptyWidgetIcon@3x.png"]; //Will change

    // if (![[NSFileManager defaultManager] fileExistsAtPath:emptyWidgetImagePath]) {
    //     emptyWidgetImagePath = [NSString stringWithFormat:@"/bootstrap/Library/PreferenceBundles/emerPrefs.bundle/emptyWidgetIcon@3x.png"];
    // }

    // self.firstWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:emptyWidgetImagePath]];
    // self.firstWidget.backgroundColor = [UIColor clearColor];
    // self.firstWidget.contentMode = UIViewContentModeScaleAspectFill;

    // self.secondWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:emptyWidgetImagePath]];
    // self.secondWidget.backgroundColor = [UIColor clearColor];
    // self.secondWidget.contentMode = UIViewContentModeScaleAspectFill;

    // self.thirdWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:emptyWidgetImagePath]];
    // self.thirdWidget.backgroundColor = [UIColor clearColor];
    // self.thirdWidget.contentMode = UIViewContentModeScaleAspectFill;

    // self.fourthWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:emptyWidgetImagePath]];
    // self.fourthWidget.backgroundColor = [UIColor clearColor];
    // self.fourthWidget.contentMode = UIViewContentModeScaleAspectFill;

    // self.fifthWidget = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:emptyWidgetImagePath]];
    // self.fifthWidget.backgroundColor = [UIColor clearColor];
    // self.fifthWidget.contentMode = UIViewContentModeScaleAspectFill;

    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] firstWidget]];
    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] secondWidget]];
    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] thirdWidget]];
    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] fourthWidget]];
    [self.container addSubview:[[EmerConfigHeaderUpdater sharedInstance] fifthWidget]];
    }

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.configBackground.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height + 70);

    //[[[EmerConfigHeaderUpdater sharedInstance] configTime] sizeToFit];
    //[[EmerConfigHeaderUpdater sharedInstance] configTime].center = CGPointMake(75, 50);
    [[EmerConfigHeaderUpdater sharedInstance] setCenter:CGPointMake(75, 50) forObject:1];
    
    [[EmerConfigHeaderUpdater sharedInstance] setCenter:CGPointMake(345, 52) forObject:2];
    // [self.configDate sizeToFit];
    // self.configDate.center = CGPointMake(345, 52);

    [[EmerConfigHeaderUpdater sharedInstance] setFrame:CGRectMake(37, 86, 60, 60) forObject:11];
    [[EmerConfigHeaderUpdater sharedInstance] setFrame:CGRectMake(107, 86, 60, 60) forObject:12];
    [[EmerConfigHeaderUpdater sharedInstance] setFrame:CGRectMake(177, 86, 60, 60) forObject:13];
    [[EmerConfigHeaderUpdater sharedInstance] setFrame:CGRectMake(247, 86, 60, 60) forObject:14];
    [[EmerConfigHeaderUpdater sharedInstance] setFrame:CGRectMake(317, 86, 60, 60) forObject:15];
    // self.firstWidget.frame = CGRectMake(37, 86, 60, 60);
    // self.secondWidget.frame = CGRectMake(107, 86, 60, 60);
    // self.thirdWidget.frame = CGRectMake(177, 86, 60, 60);
    // self.fourthWidget.frame = CGRectMake(247, 86, 60, 60);
    // self.fifthWidget.frame = CGRectMake(317, 86, 60, 60);

    self.container.frame = self.bounds;
    self.container.clipsToBounds = NO;
    self.clipsToBounds = NO;
}

@end