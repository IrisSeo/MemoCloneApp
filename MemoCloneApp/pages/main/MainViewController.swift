//
//  MainViewController.swift
//  MemoCloneApp
//
//  Created by MUN JEONG SEO on 2021/02/22.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//  메인이자 로그인 페이지
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
// MARK: 참조
// 네비게이션 바 배경색(목적: 투명한 네비바 만들기): https://zeddios.tistory.com/574


import UIKit
import Firebase

protocol MainDisplayLogic: class {
    func displayStartPage(viewModel: Main.앱진입.ViewModel)
    func displayRegisterSuccess(viewModel: Main.회원가입.ViewModel)
    func displayRegisterFail()
    func displaySignInSuccess(viewModel: Main.로그인.ViewModel)
    func displaySignInFail()
    func displaySignOutSuccess()
    func displaySignOutFail()
}

typealias MainPage = MainViewController
class MainViewController: UIViewController, MainDisplayLogic {
    var interactor: MainBusinessLogic?
    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    
    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    @IBOutlet weak var userInformView: UIView!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var moveToListButton: UIButton!
    
    @IBOutlet weak var inputContainerView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let textFieldInset: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStyle()
        setNavigationBar(navigationItem: self.navigationItem, navigationController: self.navigationController, title: "메인화면")
        checkIsFirstLaunch()
    }
    
    private func initStyle() {
        view.do {
            $0.backgroundColor = getKeyColor()
        }
        
        userInformView.do {
            $0.layer.cornerRadius = 10
        }
        
        moveToListButton.do {
            let btnTitle = NSMutableAttributedString(string: "메모장 리스트로 이동하기")
            btnTitle.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, btnTitle.length))
            $0.setAttributedTitle(btnTitle, for: .normal)
            $0.setAttributedTitle(btnTitle, for: .selected)
        }
        
        inputContainerView.do {
            $0.layer.cornerRadius = 10
        }
        
        idTextField.do {
            $0.addLeftPadding()
            $0.addRightPadding()
        }
        
        pwTextField.do {
            $0.addLeftPadding()
            $0.addRightPadding()
        }
        
        hideUserView()
    }
    
    private func clearInputViewTextField() {
        idTextField.text = ""
        pwTextField.text = ""
    }
    
    @IBAction func handleMoveToListBTNTap(_ sender: Any) {
        self.router?.routeToMemoListPage()
    }
    
    
    @IBAction func handleSignInBTNTap(_ sender: Any) {
        guard let id = idTextField.text,
              let pw = pwTextField.text else {
            print("로그인시 필요한 아이디와 비밀번호를 잘못 입력하였습니다.")
            return
        }
        
        self.interactor?.signInUser(id: id, pw: pw)
    }
    
    @IBAction func handleSignOutBTNTap(_ sender: Any) {
        self.interactor?.signOut()
    }
    
    @IBAction func handleSignUpBTNTap(_ sender: Any) {
        showSignUpAlert()
    }
   
    private func showSignUpAlert() {
        let registerAlert = UIAlertController(title: "회원가입",
                                      message: "필요한 정보를 입력해주세요.",
                                      preferredStyle: .alert)
        registerAlert.addTextField { textField in
            textField.placeholder = "아이디(test@gmail.com)"
        }
        registerAlert.addTextField { textField in
            textField.placeholder = "비밀번호(6자리 이상)"
        }
        
        let cancelAction = UIAlertAction(title: "취소",
                                          style: .destructive, handler: nil)
        let registerAction = UIAlertAction(title: "가입",
                                           style: .default)  { (action) in
            //회원가입
            guard let id = registerAlert.textFields?[0].text,
                  let pw = registerAlert.textFields?[1].text else {
                print("회원가입 시 필요한 아이디와 비밀번호를 잘못 입력하였습니다.")
                return
            }
                  
            self.interactor?.registerUser(id: id, pw: pw)
        }
        
        registerAlert.addAction(cancelAction)
        registerAlert.addAction(registerAction)
        
        self.present(registerAlert, animated: false, completion: nil)
    }
    
    private func showUserView(userId: String?) {
        if let user = userId {
            userIdLabel.text = "\(user)님 환영합니다."
        } else {
            userIdLabel.text = "환영합니다."
        }
        
        userInformView.isHidden = false
        inputContainerView.isHidden = true
        
        signInButton.isHidden = inputContainerView.isHidden
        signUpButton.isHidden = inputContainerView.isHidden
        signOutButton.isHidden = userInformView.isHidden
        
        clearInputViewTextField()
    }
    
    private func hideUserView() {
        userInformView.isHidden = true
        inputContainerView.isHidden = false
        
        signInButton.isHidden = inputContainerView.isHidden
        signUpButton.isHidden = inputContainerView.isHidden
        signOutButton.isHidden = userInformView.isHidden
    }
    
    // MARK: Do something
    
    func checkIsFirstLaunch() {
        interactor?.checkIsFirstLaunch()
    }
    
    func displayStartPage(viewModel: Main.앱진입.ViewModel) {
        guard let isFirstLaunch = viewModel.isFirstLaunch else {
            return
        }
                
        switch isFirstLaunch {
        case true:
            print("앱 처음 설치")
            hideUserView()
            router?.routeToIntroGuidePage()
            
        case false:
            print("앱 첫 설치 아님")
            if viewModel.isAutoSinInSuccess == true {
                showUserView(userId: viewModel.currentUserId)
            } else {
                hideUserView()
            }
        }
    }
    
    func displayRegisterSuccess(viewModel: Main.회원가입.ViewModel) {
        guard let hasCurrentUser = viewModel.hasCurrentUser, hasCurrentUser == true else {
            showOKAlert(vc: self, title: "자동 로그인 실패", message: "직접 아이디와 비밀번호를 입력해주세요.")
            hideUserView()
            return
        }
        
        //회원가입시 자동으로 로그인됨
        let userId = viewModel.currentUserId
        showUserView(userId: userId)
    }
    
    func displayRegisterFail() {
        showOKAlert(vc: self, title: "회원가입 실패", message: "에러가 발생하였습니다.")
        hideUserView()
    }
    
    func displaySignInSuccess(viewModel: Main.로그인.ViewModel) {
        let userId = viewModel.currentUserId
        showUserView(userId: userId)
    }
    
    func displaySignInFail() {
        showOKAlert(vc: self, title: "로그인 실패", message: "아이디 혹은 비밀번호가 일치하지 않습니다.")
        hideUserView()
    }
    
    func displaySignOutSuccess() {
        showOKAlert(vc: self, title: "로그아웃 성공", message: "이용해주셔서 감사합니다.")
        hideUserView()
    }
    
    func displaySignOutFail() {
        showOKAlert(vc: self, title: "로그아웃 실패", message: "에러가 발생하였습니다.")
        hideUserView()
    }
    
}