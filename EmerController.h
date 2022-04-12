#import "EmerWidgetController.h"

@interface _UIBatteryView : UIView
-(void)setShowsPercentage:(BOOL)arg1 ;
-(void)setChargePercent:(double)arg1 ;
-(void)setSaverModeActive:(BOOL)arg1 ;
-(void)setChargingState:(long long)arg1 ;
-(void)setLowBatteryChargePercentThreshold:(double)arg1 ;
-(void)setShowsInlineChargingIndicator:(BOOL)arg1 ;

-(id)alloc;
@end

// @interface _UIStatusBarPersistentAnimationView : UIView
// @end

// @interface _UIStatusBarSignalView : _UIStatusBarPersistentAnimationView
// -(void)setNumberOfBars:(long long)arg1 ;
// -(void)setSignalMode:(long long)arg1 ;

// //-(id)alloc;
// @end

// @interface _UIStatusBarWifiSignalView : _UIStatusBarSignalView
// -(id)alloc;
// @end

// @interface _UIStatusBarCellularSignalView : _UIStatusBarSignalView
// @end


@interface EmerController : NSObject
+(id)sharedInstance;
-(id)init;

-(CGFloat) screenWidth;

-(UIVisualEffectView *)baseCard:(NSString *)arg1;
-(UILabel *)dateLabel;
-(UIVisualEffectView *)cardBlurContainer;
-(UIScrollView *)cardBlurContainerScrollView;
-(void)bringWidgetPassThroughViewsToFront;
-(CGRect)widgetContainerFrame;
-(UILabel *)timeLabel;
-(UIView *)firstWidget;
-(UIView *)secondWidget;
-(UIView *)thirdWidget;
-(UIView *)fourthWidget;
-(UIView *)fifthWidget;
-(void)setWidgetsAlpha:(long)alpha;
-(UIView *)firstWidgetTouchPassThroughView;
-(UIView *)secondWidgetTouchPassThroughView;
-(UIView *)thirdWidgetTouchPassThroughView;
-(UIView *)fourthWidgetTouchPassThroughView;
-(UIView *)fifthWidgetTouchPassThroughView;
-(void)showWidgetsTouchPassThroughView;
-(UIView *)expandedWidgetView;
//here goes widget text etc
-(UIView *)expandedWidgetTouchPassThroughView;
-(_UIBatteryView *)battery;
// -(_UIStatusBarWifiItem *)wifi;
// -(_UIStatusBarCellularSignalView *)cellular;
@end