//
//  UseCasePublisher.swift
//  
//
//  Created by Salihcan Kahya on 9.02.2022.
//

import Combine

open class UseCasePublisher<Input, Output, Failure: Error, Repository>: Publisher {
 
    public let repository: Repository
    public let useCaseListener: UseCaseListenerProtocol
    private var request: Input?
    private var currentPublisher: AnyPublisher<Output, Failure>!
    
    public init(repository: Repository, useCaseListener: UseCaseListenerProtocol) {
        self.repository = repository
        self.useCaseListener = useCaseListener
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        getPublisher()
            .handleEvents(receiveSubscription: { subscription in
                Swift.print("Usecase Subscription")
            }, receiveOutput: { output in
                Swift.print("Usecase Output")
            }, receiveCompletion: { completion in
                Swift.print("Usecase Completion", completion)
            }, receiveCancel: {
                Swift.print("Usecase Cancel Received")
            }, receiveRequest: { demand in
                Swift.print("Usecase Demand", demand)
            })
            .eraseToAnyPublisher()
            .receive(subscriber: subscriber)
    }
    
    public func setRequest(_ request: Input) -> AnyPublisher<Output, Failure> {
        self.request = request
        return self.eraseToAnyPublisher()
    }
    
    private func getPublisher() -> AnyPublisher<Output, Failure> {
        if let request = request {
            currentPublisher = createAnyPublisher(request: request)
        } else {
            currentPublisher = createAnyPublisher()
        }
        
        return currentPublisher
    }
    
    open func createAnyPublisher(request: Input) -> AnyPublisher<Output, Failure> {
        fatalError()
    }
    
    open func createAnyPublisher() -> AnyPublisher<Output, Failure> {
        fatalError()
    }
}
