#import "CSTDeviceListener.h"
#import "BluetoothManager/CSTBluetoothConnectionManager.h"

@implementation CSTDeviceListener

- (instancetype)initWithTitle:(NSString *)title address:(NSString *)address image:(UIImage *)image listenerType:(CSTListenerType)type capabilities:(NSArray *)capabilities {

    if ((self = [super init])) {

        _address = address;
        self.event_title = title;
        self.event_image = image;
        self.event_type = type;
        self.event_capabilities = capabilities;

        switch (type) {
            case CSTListenerTypeConnect: {
                self.event_group = @"Tooth Connect";
                self.event_subtitle = [@"Connect To Device: " stringByAppendingString:address];
            } break;

            case CSTListenerTypeDisconnect: {
                self.event_group = @"Tooth Disconnect";
                self.event_subtitle = [@"Disconnect From Device: " stringByAppendingString:address];
            } break;

            case CSTListenerTypeToggle: {
                self.event_group = @"Tooth Toggle Connection";
                self.event_subtitle = [@"Toggle Connection for Device: " stringByAppendingString:address];
            } break;

            default: {
                self.event_group = @"Tooth Error";
                self.event_subtitle = @"Error laoding device";
            } break;
        }
    }
    return self;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
    CSTBluetoothConnectionManager *manager = [CSTBluetoothConnectionManager sharedManager];

    switch (self.event_type) {
        case CSTListenerTypeConnect: {
            [manager connectDevice:[manager pairedDeviceForAddress:_address]];
        } break;

        case CSTListenerTypeDisconnect: {
            [manager disconnectDevice:[manager pairedDeviceForAddress:_address]];
        } break;

        case CSTListenerTypeToggle: {
            [manager toggleConnectionForDevice:[manager pairedDeviceForAddress:_address]];
        } break;
    }

    [event setHandled:YES];
}

- (UIImage *)activator:(LAActivator *)activator requiresSmallIconForListenerName:(NSString *)listenerName scale:(CGFloat)scale {
    return self.event_image;
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedGroupForListenerName:(NSString *)listenerName {
    return self.event_group;
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedTitleForListenerName:(NSString *)listenerName {
    return self.event_title;
}

- (NSString *)activator:(LAActivator *)activator requiresLocalizedDescriptionForListenerName:(NSString *)listenerName {
    return self.event_subtitle;
}

- (NSArray *)activator:(LAActivator *)activator requiresCompatibleEventModesForListenerWithName:(NSString *)listenerName {
    return self.event_capabilities;
}

+ (void)load {

    if ([[NSClassFromString(@"LAActivator") sharedInstance] isRunningInsideSpringBoard]) {

        // delay loading listeners to allow BluetoothManager to prepair
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            LAActivator *activator = [NSClassFromString(@"LAActivator") sharedInstance];
            CSTBluetoothConnectionManager *manager = [CSTBluetoothConnectionManager sharedManager];
            
            NSBundle *toothBundle = [NSBundle bundleWithPath:@"/var/mobile/Library/Application Support/ToothSupport.bundle"];
            UIImage *icon = [UIImage imageNamed:@"Icon" inBundle:toothBundle compatibleWithTraitCollection:nil];
            NSArray *capabilities = @[@"springboard", @"lockscreen", @"application"];

            for (BluetoothDevice *device in [manager pairedDevices]) {

                [activator registerListener:[[CSTDeviceListener alloc] initWithTitle:device.name address:device.address image:icon listenerType:CSTListenerTypeConnect capabilities:capabilities]
                                    forName:[@"com.creaturecoding.tooth.tooth-disconnect-from-" stringByAppendingString:device.address]];
                [activator registerListener:[[CSTDeviceListener alloc] initWithTitle:device.name address:device.address image:icon listenerType:CSTListenerTypeDisconnect capabilities:capabilities]
                                    forName:[@"com.creaturecoding.tooth.tooth-connect-to-" stringByAppendingString:device.address]];
                [activator registerListener:[[CSTDeviceListener alloc] initWithTitle:device.name address:device.address image:icon listenerType:CSTListenerTypeToggle capabilities:capabilities]
                                    forName:[@"com.creaturcoding.tooth.tooth-toggle-for-" stringByAppendingString:device.address]];
            }
        });
    }
}

@end


static __attribute__((constructor)) void initialize_bluetooth(int __unused argc, char __unused **argv, char __unused **envp) {

    
    [CSTBluetoothConnectionManager sharedManager];
}