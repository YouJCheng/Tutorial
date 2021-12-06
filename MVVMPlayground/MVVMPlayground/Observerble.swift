//
//  Observerble.swift
//  MVVMPlayground
//
//  Created by YouJCheng on 2021/12/6.
//

import Foundation
class Observerble<T> {
    
    var value: T? {
        didSet {
            listener?(value)
        }
    }
   
    init(_ value: T?) {
        self.value = value
    }
    
    private var listener: ((T?)-> Void)?
   
    func bind(_ listener: @escaping(T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}
