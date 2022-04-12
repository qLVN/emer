#import <UIKit/UIKit.h>
#import <notify.h>
#import "EmerController.h"
#import "EmerWidgetController.h"

@interface NCNotificationListHeaderTitleView : UIView
-(void)setTitle:(NSString *)arg1;
@end

@interface SBSleepWakeHardwareButtonInteraction
@end

@interface SBBiometricEventLogger
@end

@interface CSCoverSheetViewController : UIViewController
@property (assign,getter=isDeviceAuthenticated,nonatomic) BOOL deviceAuthenticated;  
@end

@interface NCToggleControl
-(void)setExpanded:(BOOL)arg1 ;
-(void)setTitle:(NSString *)arg1 ;
@end

@interface SBFLockScreenDateViewController
@end

@interface SBLockStateAggregator : NSObject
+(id)sharedInstance;
-(unsigned long long)lockState;
@end

@interface SBUISpotlightBarNavigationController : UINavigationController
-(UIViewController*)searchBarViewController;
-(double)_statusBarHeightAdjustmentForCurrentOrientation;
@end