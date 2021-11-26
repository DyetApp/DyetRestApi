//
//  WatchNet+Rx.swift
//  WatchNet+Rx
//
//  Created by Ilya Senchukov on 01.08.2021.
//

import UIKit
import WatchNet
import RxSwift
import Foundation

extension RestService: ReactiveCompatible { }

public extension Reactive where Base: RestService {

    func fetch<T: Decodable>(decodingTo: T.Type) -> Single<T> {
        Single.create { single in
            let task = base.execute(decodingTo: T.self, force: true) { res in
                switch res {
                    case .success(let obj):
                        single(.success(obj))
                    case .failure(let error):
                        single(.failure(error))
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }

    func fetch() -> Single<Void> {
        Single.create { single in
            let task = base.execute { res in
                switch res {
                    case .success(_):
                        single(.success(()))
                    case .failure(let error):
                        single(.failure(error))
                }
            }

            return Disposables.create {
                task?.cancel()
            }
        }
    }

}

public extension Reactive where Base: ImageService {

    func fetch(path: String) -> Single<UIImage> {
        Single.create { single in
            let task = base.image(for: path) { res in
                switch res {
                    case .success(let image):
                        single(.success(image))
                    case .failure(let error):
                        single(.failure(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }

}