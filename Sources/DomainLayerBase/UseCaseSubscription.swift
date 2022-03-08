//
//  UseCaseSubscription.swift
//  
//
//  Created by Salihcan Kahya on 21.02.2022.
//

import Combine

open class UseCaseSubscription<S: Subscriber>: Subscription {
    
    public var subsciber: S?
    public var useCaseListener: UseCaseListenerProtocol
    private var cancellable: AnyCancellable?
    
    public init(useCaseListener: UseCaseListenerProtocol, subsciber: S) {
        self.useCaseListener = useCaseListener
        self.subsciber = subsciber
    }
    
    public func request(_ demand: Subscribers.Demand) {}
    
    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
        subsciber = nil
    }
    
    func proceed(with anyPublisher: AnyPublisher<S.Input, S.Failure>) {
        useCaseListener.onPreCall()
        cancellable = anyPublisher.sink { [weak self] completion in
            self?.handleCompletion(completion)
        } receiveValue: { [weak self] input in
            self?.handleReceiveValue(input)
        }
    }
    
    private func handleCompletion(_ completion: Subscribers.Completion<S.Failure>) {
        self.subsciber?.receive(completion: completion)
        switch completion {
            case .failure(let error):
                useCaseListener.onError(with: error)
            case .finished:
                useCaseListener.onPostCall()
        }
    }
    
    private func handleReceiveValue(_ input: S.Input) {
        guard let target = subsciber else { return }
        request(target.receive(input))
    }
}
