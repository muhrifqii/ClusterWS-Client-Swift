//
//  Channel.swift
//  Test
//
//  Created by Roman Baitaliuk on 6/10/17.
//  Copyright © 2017 ByteKit. All rights reserved.
//

import Foundation

open class Channel: Equatable {
    
    //channel object comparisment
    public static func ==(lhs: Channel, rhs: Channel) -> Bool {
        if lhs.mChannelName == rhs.mChannelName {
            return true
        } else {
            return false
        }
    }
    
    //MARK: Properties
    
    open let mChannelName: String!
    private var completion: CompletionHandler?
    private let mSocket: ClusterWS!
    
    //MARK: Initialization
    
    public init(channelName: String, socket: ClusterWS) {
        self.mChannelName = channelName
        self.mSocket = socket
        self.subscribe()
    }
    
    
    //MARK: Public functions
    
    public func watch(completion: @escaping CompletionHandler) -> Channel {
        self.completion = completion
        return self
    }
    
    public func publish(data: Any) -> Channel {
        self.mSocket.send(event: self.mChannelName, data: data, type: .publish)
        return self
    }
    
    public func unsubscribe() {
        self.mSocket.send(event: "unsubscribe", data: self.mChannelName, type: .system)
        self.mSocket.mChannels = self.mSocket.mChannels.filter { $0 != self }
    }
    
    //MARK: ClusterWS internal functions
    
    open func subscribe() {
        self.mSocket.send(event: "subscribe", data: self.mChannelName, type: .system)
    }
    
    open func onMessage(data: Any) {
        if let completion = self.completion {
            completion(data)
        }
    }
}
