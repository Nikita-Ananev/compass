//
//  LoginViewModel.swift
//  compass
//
//  Created by Никита Ананьев on 18.06.2023.
//
import Foundation
import RxSwift
import RxCocoa
import SwiftJWT

class LoginViewModel {
    let disposeBag = DisposeBag()
    
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var router: Router
    
    init(router: Router) {
        self.router = router
        
        Observable.combineLatest(username, password)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] username, password in
                self?.handleLogin(username: username, password: password)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func handleLogin(username: String, password: String) {
        if username == "Admin" && password == "Password" {
            router.navigateToMapView()
            let fakeToken = generateFakeToken()
            self.username.accept("")
            self.password.accept("")
        } else {
            print("Login failed")
        }
    }
    
    private func generateFakeToken() -> String {
        let claims = MyClaims(sub: "fake_user")
        var jwt = JWT(claims: claims)
        let signer = JWTSigner.hs256(key: "secret_key".data(using: .utf8)!)
        let encodedToken = try! jwt.sign(using: signer)
        print(encodedToken)
        return encodedToken
    }
}

struct MyClaims: Claims {
    let sub: String
}
