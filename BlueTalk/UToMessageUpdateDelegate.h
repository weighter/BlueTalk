//
//  UToMessageUpdateDelegate.h
//  BlueTalk
//
//  Created by Weighter on 2017/9/26.
//  Copyright © 2017年 Weighter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UToMessageUpdateDelegate <NSObject>

- (BOOL)receivedNewMessage:(MCPeerID *)peerId chatItem:(UToChatItem *)chatItem;

- (void)peerConnectionStatusChange:(MCPeerID *)peer state:(MCSessionState)state;

- (BOOL)sendNewMessageIsSuccess:(BOOL)isSuccess;

@end
