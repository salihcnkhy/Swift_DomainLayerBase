import XCTest
import Combine

@testable import DomainLayerBase

final class DomainLayerBaseTests: XCTestCase {
    
    var anyCancellables = Set<AnyCancellable>()
    let repository = MockRepository()
    let useCaseListener = MockUseCaseListener()
    
    func testWithoutRequest() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let useCase = MockUseCase(repository: repository, useCaseListener: useCaseListener)

        let expectation = self.expectation(description: "combine")
        
        useCase.sink(receiveValue: { response in
            print(response)
        }).store(in: &anyCancellables)
        
        useCase.sink(receiveValue: { response in
            print(response)
        }).store(in: &anyCancellables)
        
        useCase.sink(receiveValue: { response in
            print(response)
        }).store(in: &anyCancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            useCase.sink(receiveValue: { response in
                print(response)
                expectation.fulfill()
            }).store(in: &self.anyCancellables)
        }
        
  
        
        waitForExpectations(timeout: 10)
    }
    
    func testWithRequest() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let useCase = MockUseCase(repository: repository, useCaseListener: useCaseListener)
        
        let expectation = self.expectation(description: "combine")
        
        useCase.setRequest(.init()).sink(receiveValue: { response in
            print(response)
        }).store(in: &anyCancellables)
        
        useCase.setRequest(.init()).sink(receiveValue: { response in
            print(response)
        }).store(in: &anyCancellables)
        
        useCase.setRequest(.init()).sink(receiveValue: { response in
            print(response)
        }).store(in: &anyCancellables)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            useCase.setRequest(.init()).sink(receiveValue: { response in
                print(response)
                expectation.fulfill()
            }).store(in: &self.anyCancellables)
        }
        
        waitForExpectations(timeout: 10)
    }

}

struct MockResponse {
    let id = UUID().uuidString
}
struct MockRequest { }
struct MockRepository {
    func getMock() -> AnyPublisher<MockResponse, Never> {
        Future { promise in
            promise(.success(MockResponse()))
        }.eraseToAnyPublisher()
    }
    
    func getMock(with request: MockRequest) -> AnyPublisher<MockResponse, Never> {
        print(request)
        return Future { promise in
            promise(.success(MockResponse()))
        }.eraseToAnyPublisher()
    }
}

struct MockUseCaseListener: UseCaseListenerProtocol {
    func onPreCall() {
        print("pre")
    }
    
    func onPostCall() {
        print("post")
    }
    
    func onError(with error: Error) {
        print("error: ", error)
    }
}

class MockUseCase: UseCasePublisher<MockRequest, MockResponse, Never, MockRepository> {
    override func createAnyPublisher() -> AnyPublisher<MockResponse, Never> {
        repository.getMock()
    }
    
    override func createAnyPublisher(request: MockRequest) -> AnyPublisher<MockResponse, Never> {
        repository.getMock(with: request)
    }
}
