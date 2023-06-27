//
//  ViewController.swift
//  compass
//
//  Created by Никита Ананьев on 17.06.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginView: UIViewController {
    
    //MARK: Variables
    
    let viewModel: LoginViewModel
    let disposeBag = DisposeBag()
    
    //MARK: Views
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "COMPASS"
        label.font = .boldSystemFont(ofSize: 46)
        label.textColor = .black
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.text = "test app"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    lazy var loginTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "enter your login here..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.textColor = .black
        return tf
    }()
    lazy var passwordTF: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string: "enter your password here..", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.textColor = .black
        return tf
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loginTF.text = ""
        passwordTF.text = ""
        
    }
    
    
    //MARK: Layout
    private func setupViews() {
        view.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(187)
            
        }
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints { make in
            make.right.equalTo(mainLabel)
            make.top.equalTo(mainLabel.snp.bottom)
        }
        view.addSubview(loginTF)
        loginTF.snp.makeConstraints { make in
            make.top.equalTo(secondLabel.snp.bottom).offset(74)
            make.leading.equalTo(56)
            make.trailing.equalTo(-56)
            make.width.equalTo(278)
        }
        view.addSubview(passwordTF)
        passwordTF.snp.makeConstraints { make in
            make.top.equalTo(loginTF.snp.bottom).offset(28)
            make.centerX.equalTo(loginTF)
            make.width.equalTo(loginTF)
        }
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .compact {
            // MARK: VERTICAL
            mainLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(187)
            }
        } else {
            // MARK: HORIZONTAL
            mainLabel.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(50)
            }
        }
    }
    
    
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBindings() {
        loginTF.rx.text.orEmpty
            .bind(to: viewModel.username)
            .disposed(by: disposeBag)
        
        passwordTF.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: disposeBag)
        
        viewModel.password
            .asDriver()
            .drive(passwordTF.rx.text)
            .disposed(by: disposeBag)
    }
}

