//
//  AppDelegate.m
//  BlueTalk
//
//  Created by Weighter on 2017/2/23.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import "AppDelegate.h"
#import "UToMsgViewController.h"
#import "UToLinkmanViewController.h"
#import "UToMeViewController.h"
#import "UToBlueSessionManager.h"

AppDelegate *utoDelegate;

@interface AppDelegate () {
    
    UToAlert *_alret;
    MCPeerID *_peerId;
    NSMutableData *_streamData;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    utoDelegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    UToMsgViewController *mvc = [[UToMsgViewController alloc] init];
    mvc.title = @"消息";
    mvc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:0];
    UINavigationController *mNav = [[UINavigationController alloc] initWithRootViewController:mvc];
    
    UToLinkmanViewController *lvc = [[UToLinkmanViewController alloc] init];
    lvc.title = @"联系人";
    lvc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    UINavigationController *lNav = [[UINavigationController alloc] initWithRootViewController:lvc];
    
    UToMeViewController *mevc = [[UToMeViewController alloc] init];
    mevc.title = @"我";
    mevc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
    UINavigationController *meNav = [[UINavigationController alloc] initWithRootViewController:mevc];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[mNav, lNav, meNav];
    self.window.rootViewController= tabBarController;
    
    [get_singleton_for_class(UToCommonDBCache) createTable];
    
    [self initBlueData];
    
    return YES;
}

- (void)initBlueData {
    
    // 初始化  会议室
    [get_singleton_for_class(UToBlueSessionManager) setDisplayName:[NSString stringWithFormat:@" %@",  [[UIDevice currentDevice] name]]];
    
    // 这是为了让 在block中弱引用
    __weak typeof (self) weakSelf = self;
    
    [get_singleton_for_class(UToBlueSessionManager) didReceiveInvitationFromPeer:^void(MCPeerID *peer, NSData *context) {
        
        [get_singleton_for_class(UToBlueSessionManager) connectToPeer:YES];
    }];
    
    [get_singleton_for_class(UToBlueSessionManager) peerConnectionStatusOnMainQueue:YES block:^(MCPeerID *peer, MCSessionState state) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
            if (state == MCSessionStateConnected) {
                
                [[UToAlert AlertTitle:@"已经连接" content:[NSString stringWithFormat:@"现在连接 %@了！", peer.displayName] cancelButton:nil okButton:@"知道了" complete:nil] showAlertWithController:nil];
            } else if (state == MCSessionStateNotConnected) {
                
                _alret = [UToAlert AlertTitle:@"已断开连接" content:[NSString stringWithFormat:@"已断开连接 %@了！", peer.displayName] cancelButton:@"知道了" okButton:@"重新连接" complete:^(BOOL isOk) {
                    
                    if (isOk) {
                        
                        [get_singleton_for_class(UToBlueSessionManager) invitePeerToConnect:peer connected:^{
                            
                        }];
                    }
                    
                }];
                [_alret showAlertWithController:nil];
            }
        if ([strongSelf.rdelegate respondsToSelector:@selector(peerConnectionStatusChange:state:)]) {
            
            [strongSelf.rdelegate peerConnectionStatusChange:peer state:state];
        }
    }];
    
    // 发正常数据的返回
    [get_singleton_for_class(UToBlueSessionManager) receiveDataOnMainQueue:YES block:^(NSData *data, MCPeerID *peer) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        
        UToChatItem *chatItem = [[UToChatItem alloc] init];
        chatItem.displayName = peer.displayName;
        chatItem.isSelf = NO;
        chatItem.states = textStates;
        chatItem.data = data;
        chatItem.time = [[NSDate date] timeIntervalSince1970];
        [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
        if ([strongSelf.rdelegate respondsToSelector:@selector(receivedNewMessage:chatItem:)]) {
            
            [strongSelf.rdelegate receivedNewMessage:peer chatItem:chatItem];
        }
    }];
    
    // 发图片之后的返回
    [get_singleton_for_class(UToBlueSessionManager) receiveFinalResourceOnMainQueue:YES complete:^(NSString *name, MCPeerID *peer, NSURL *url, NSError *error) {
        
        __strong typeof (weakSelf) strongSelf = weakSelf;
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        UToChatItem *chatItem = [[UToChatItem alloc] init];
        chatItem.displayName = peer.displayName;
        chatItem.isSelf = NO;
        chatItem.states = picStates;
        chatItem.time = [[NSDate date] timeIntervalSince1970];
        chatItem.data = data;
        [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
        if ([strongSelf.rdelegate respondsToSelector:@selector(receivedNewMessage:chatItem:)]) {
            
            [strongSelf.rdelegate receivedNewMessage:peer chatItem:chatItem];
        }
    }];
    [get_singleton_for_class(UToBlueSessionManager) startReceivingResourceOnMainQueue:YES block:^(NSString *name, MCPeerID *peer, NSProgress *progress) {
//        MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//        _hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
//        _hud.label.text = @"录音中";
//        _hud.progress = progress;
    }];
    // 流
    [get_singleton_for_class(UToBlueSessionManager) didReceiveStreamFromPeer:^(NSInputStream *stream, MCPeerID *peer, NSString *streamName) {
        _peerId = peer;
//        __strong typeof (weakSelf) strongSelf = weakSelf;
//        strongSelf.inputStream = stream;
//        strongSelf.inputStream.delegate = self;
//        [strongSelf.inputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//        [strongSelf.inputStream open];
//        
//        NSLog(@"we need");
        
    }];
    
    [get_singleton_for_class(UToBlueSessionManager) didFinishReceiveStreamFromPeer:^(UToChatItem *chatItem, MCPeerID *peer) {
        
        [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
        if ([self.rdelegate respondsToSelector:@selector(receivedNewMessage:chatItem:)]) {
            
            [self.rdelegate receivedNewMessage:_peerId chatItem:chatItem];
        }
    }];
}

// 下面是一个代理
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    if (eventCode == NSStreamEventHasBytesAvailable) { // 接收
        
        // 有可读的字节，接收到了数据
        NSInputStream *input = (NSInputStream *)aStream;
        uint8_t buffer[1024];
        NSInteger length = [input read:buffer maxLength:1024];
        [_streamData appendBytes:(const void *)buffer length:(NSUInteger)length];
    } else if (eventCode == NSStreamEventHasSpaceAvailable) { // 发送
        
        // 可以使用输出流的空间，此时可以发送数据给服务器
        // 发送数据的
//        NSData *data = [self getVideoStremData];
//        UToChatItem *chatItem = [[UToChatItem alloc] init];
//        chatItem.isSelf = YES;
//        chatItem.displayName = get_singleton_for_class(UToBlueSessionManager).myPeerID.displayName;
//        chatItem.states = videoStates;
//        chatItem.data = data;
//        chatItem.time = [[NSDate date] timeIntervalSince1970];
//        [self.dataArray addObject:chatItem];
//        [self insertTheTableToButtom];
//        [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
        if ([self.rdelegate respondsToSelector:@selector(receivedNewMessage:chatItem:)]) {
            
            [self.rdelegate sendNewMessageIsSuccess:YES];
        }
        NSOutputStream *output = (NSOutputStream *)aStream;
//        [output write:data.bytes maxLength:data.length];
        [output close];
    } else if (eventCode == NSStreamEventEndEncountered) { // 完成
        
        // 流结束事件，在此事件中负责做销毁工作
        // 同时也是获得最终数据的好地方
        
        UToChatItem *chatItem = [[UToChatItem alloc] init];
        chatItem.isSelf = NO;
        chatItem.displayName = get_singleton_for_class(UToBlueSessionManager).myPeerID.displayName;
        chatItem.states = videoStates;
        chatItem.data = _streamData;
        chatItem.time = [[NSDate date] timeIntervalSince1970];

        [get_singleton_for_class(UToCommonDBCache) addHistoryMessage:chatItem];
        if ([self.rdelegate respondsToSelector:@selector(receivedNewMessage:chatItem:)]) {
            
            [self.rdelegate receivedNewMessage:_peerId chatItem:chatItem];
        }
        
        [aStream close];
        [aStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        if ([aStream isKindOfClass:[NSInputStream class]]) {
            
            _streamData = nil;
        }
    } else if (eventCode == NSStreamEventErrorOccurred) { // 错误
        
        // 发生错误
        NSLog(@"error");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
