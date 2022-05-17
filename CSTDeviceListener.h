#import <libactivator/libactivator.h>
#import <Foundation/Foundation.h>

enum {
    CSTListenerTypeConnect = 0,
    CSTListenerTypeDisconnect = 1,
    CSTListenerTypeToggle = 2
};
typedef NSUInteger CSTListenerType;

@interface CSTDeviceListener : NSObject <LAListener> {
    NSString *_address;
}

@property (nonatomic, retain) NSString *event_title;
@property (nonatomic, retain) NSString *event_subtitle;
@property (nonatomic, retain) NSString *event_group;
@property (nonatomic, retain) NSArray *event_capabilities;
@property (nonatomic, retain) UIImage *event_image;
@property (nonatomic, assign) CSTListenerType event_type;

- (instancetype)initWithTitle:(NSString *)title address:(NSString *)address image:(UIImage *)image listenerType:(CSTListenerType)type capabilities:(NSArray *)capabilities;
@end