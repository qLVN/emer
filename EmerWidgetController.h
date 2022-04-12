#import <UIKit/UIKit.h>
#import "EmerController.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface EmerWidgetController : NSObject
+(id)sharedInstance;
-(id)init;

-(NSString *)deviceIPAddressForType:(long)type;
//-(NSString *)twitterFollowersForUser:(NSString *)user;
-(UIView *)ipWidget;
-(UIView *)expandedIpWidget;
-(UILabel *)emptyWidget;
-(UIView *)expandedEmptyWidget;
-(UIView *)phWidget;
-(UIView *)expandedPHWidget;
-(UIView *)twitterWidget;
-(UIView *)expandedTwitterWidget;
-(void)setWidgetsAlpha:(long)alpha;
-(void)setWidgetsHidden:(BOOL)hidden;
-(void)hideExpandedWidgets;
-(void)showViewForWidget:(long)widget;
@end