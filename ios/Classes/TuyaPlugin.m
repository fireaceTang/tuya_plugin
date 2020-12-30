#import "TuyaPlugin.h"
#import <TuyaSmartHomeKit/TuyaSmartKit.h>
#import <Foundation/Foundation.h>

@implementation TuyaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"tuya_plugin"
            binaryMessenger:[registrar messenger]];
  TuyaPlugin* instance = [[TuyaPlugin alloc] init];
  [[TuyaSmartSDK sharedInstance] startWithAppKey:@"dfn7nrd4yy47p89cea3a" secretKey:@"yeetfswhrjm4fvjcad7mwnsm754yuhmw"];
  #ifdef DEBUG
      [[TuyaSmartSDK sharedInstance] setDebugMode:YES];
  #else
  #endif
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
       result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }else if ([@"set_ec_net" isEqualToString:call.method]) {
       [self startConfigWiFi:call.arguments[@"ssid"] password:call.arguments[@"password"] token:call.arguments[@"token"]];
  }else if ([@"set_ap_net" isEqualToString:call.method]) {
       [self startApConfigWiFi:call.arguments[@"ssid"] password:call.arguments[@"password"] token:call.arguments[@"token"]];
  }else if ([@"uid_login" isEqualToString:call.method]) {
      [[TuyaSmartUser sharedInstance] loginOrRegisterWithCountryCode:call.arguments[@"countryCode"] uid:call.arguments[@"uid"]  password:call.arguments[@"passwd"] createHome:YES success:^(id result1) {
              result(@"登陆成功");
      } failure:^(NSError *error) {
             result(@"登陆失败");
      }];
  }else {
    result(FlutterMethodNotImplemented);
  }
}

//ez 配网模式
- (void)startConfigWiFi:(NSString *)ssid password:(NSString *)password token:(NSString *)token {
    // 设置 TuyaSmartActivator 的 delegate，并实现 delegate 方法
    [TuyaSmartActivator sharedInstance].delegate = self;

    // 开始配网，快连模式对应 mode 为 TYActivatorModeEZ
    [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeEZ ssid:ssid password:password token:token timeout:100];
}

#pragma mark - TuyaSmartActivatorDelegate
- (void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error {

    if (!error && deviceModel) {
        //配网成功
        NSLog(@"NSLog与printf的区别");
    }

    if (error) {
        NSLog(@"NSLog与printf的区别");
        //配网失败
    }
}

// ap 配网
- (void)startApConfigWiFi:(NSString *)ssid password:(NSString *)password token:(NSString *)token {
    // 设置 TuyaSmartActivator 的 delegate，并实现 delegate 方法
    [TuyaSmartActivator sharedInstance].delegate = self;

    // 开始配网，热点模式对应 mode 为 TYActivatorModeAP
    [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeAP ssid:ssid password:password token:token timeout:100];
}


@end


