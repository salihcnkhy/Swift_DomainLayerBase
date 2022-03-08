//
//  UseCaseListenerProtocol.swift
//  
//
//  Created by Salihcan Kahya on 21.02.2022.
//

import Foundation

public protocol UseCaseListenerProtocol {
    func onPreCall()
    func onPostCall()
    func onError(with error: Error)
}
