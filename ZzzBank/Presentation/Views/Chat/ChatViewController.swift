import UIKit
import SnapKit
import SwiftUI

class ChatViewController: UIViewController {
    private let viewModel: ChatViewModel
    private let speechRecognizer: SpeechRecognizer
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = . customBackgroundColor
        
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        
        return tableView
    }()
    
    private lazy var plusButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapPlus))
        button.tintColor = .mainColor
        
        return button
    }()
    
    init(viewModel: ChatViewModel, speechRecognizer: SpeechRecognizer) {
        self.viewModel = viewModel
        self.speechRecognizer = speechRecognizer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Task {
            await viewModel.fetchChats()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func configureUI() {
        view.backgroundColor = .customBackgroundColor
        navigationItem.title = "Midnight Chat"
        navigationItem.rightBarButtonItem = plusButton
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func didTapPlus() {
        let chat = Chat(title: "New Chat")
        let chatView = ChatView(viewModel: MessageViewModel(api: GeminiAPI(), chat: chat, speechRecognizer: speechRecognizer), speechRecognizer: speechRecognizer)
        let vc = UIHostingController(rootView: chatView)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.chats.count == 0 {
            self.tableView.setEmptyMessage("Start a new chat")
        } else {
            self.tableView.restore()
        }
        
        return viewModel.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.chats[indexPath.row].title)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = viewModel.chats[indexPath.row]
        let chatView = ChatView(viewModel: MessageViewModel(api: GeminiAPI(), chat: chat, speechRecognizer: speechRecognizer), speechRecognizer: speechRecognizer)
        let vc = UIHostingController(rootView: chatView)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
