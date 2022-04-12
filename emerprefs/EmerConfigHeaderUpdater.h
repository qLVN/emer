#import <UIKit/UIKit.h>

@interface EmerConfigHeaderUpdater : NSObject
+(id)sharedInstance;
-(id)init;

-(NSString *)emptyWidgetImagePath;
-(UILabel *)configTime;
-(UILabel *)configDate;
-(UIImageView *)firstWidget;
-(UIImageView *)secondWidget;
-(UIImageView *)thirdWidget;
-(UIImageView *)fourthWidget;
-(UIImageView *)fifthWidget;
-(void)updateConfigViewForObject:(long)object newValue:(long)value;
-(void)setCenter:(CGPoint)center forObject:(long)object;
-(void)setFrame:(CGRect)frame forObject:(long)object;
@end