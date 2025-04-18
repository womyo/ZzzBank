//
//  CustomVideoViewController.swift
//  ZzzBank
//
//  Created by wayblemac02 on 4/17/25.
//

import UIKit
import AVFoundation
import AVKit

extension AVPlayer{ // 영상이 현재 진행중인지 판단하는 부분
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}

class CustomVideoViewController: UIViewController {
    private let viewModel = CustomVideoViewModel()
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var timer: Timer?
    var timeObserver : Any?
    private var isSeeking: Bool = false
    
    private var totalDuration: Double?
    
    private let totalBtnsView = UIView()

    private let videoBackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.closeViewAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.addAction(UIAction { [weak self] _ in
            self?.clickPlayAction()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var backwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.setActionMoveSeconds(goValue: -10.0)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var forwardButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.addAction(UIAction { [weak self] _ in
            self?.setActionMoveSeconds(goValue: 10.0)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00 / 00:00"
        
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.value = 0.0
        slider.addAction(UIAction { [weak self] _ in
            self?.timelineValueChanged()
        }, for: .touchUpInside)
        
        slider.addAction(UIAction { [weak self] _ in
            self?.isSeeking = true
        }, for: .touchDown)
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideUIControls()
        configureUI()
        
        viewModel.loadSubTitles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setVideoView(url: viewModel.getVideoURL())
        
        resetTimer()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleUIControls))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoBackView.bounds
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    @objc private func hideUIControls() {
        totalBtnsView.isHidden = true
    }
    
    @objc private func toggleUIControls() {
        totalBtnsView.isHidden = !totalBtnsView.isHidden
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(hideUIControls), userInfo: nil, repeats: false)
    }
    
    private func configureUI() {
        view.backgroundColor = .customBackgroundColor
        view.addSubview(totalBtnsView)
        view.addSubview(videoBackView)
        view.sendSubviewToBack(videoBackView)
        totalBtnsView.addSubview(closeButton)
        totalBtnsView.addSubview(playButton)
        totalBtnsView.addSubview(backwardButton)
        totalBtnsView.addSubview(forwardButton)
        totalBtnsView.addSubview(timeLabel)
        totalBtnsView.addSubview(slider)
        
        totalBtnsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        videoBackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        backwardButton.snp.makeConstraints {
            $0.trailing.equalTo(playButton.snp.leading).offset(-16)
            $0.centerY.equalToSuperview()
        }
        
        forwardButton.snp.makeConstraints {
            $0.leading.equalTo(playButton.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.bottom.equalTo(slider.snp.top).offset(-10)
        }
        
        slider.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
        }
    }
    
    private func setVideoView(url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer?.frame = videoBackView.bounds
        videoBackView.layer.addSublayer(playerLayer!)
        player?.play()
        
        setPlayButtonImage()
        
        let interval = CMTime(seconds: 0.01, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { elapsedTime in
            let subtitles = self.viewModel.loadSubTitles()
            
            self.timeLabel.text = self.viewModel.subTitle(for: CMTimeGetSeconds(elapsedTime), in: subtitles)
//            Task {
//                await self.getVideoTotalTime()
//            }
        })
    }
}

extension CustomVideoViewController {
    
    // MARK: - 닫기 버튼 클릭
    private func closeViewAction() {
        player?.pause()
        player = nil
        dismiss(animated: true)
    }
    
    // MARK: - Play버튼 클릭
    private func clickPlayAction() {
        if (player?.isPlaying ?? false) {
            self.player?.pause()
        } else {
            self.player?.play()
        }
        
        setPlayButtonImage()
    }
    
    private func setPlayButtonImage() {
        playButton.setImage(UIImage(systemName: player?.isPlaying ?? false ? "pause.fill" : "play.fill"), for: .normal)
    }
}

extension CustomVideoViewController {
    // MARK: - 동영상 진행
    func getVideoTotalTime() async {
        guard let playerItem = player?.currentItem else { return }
        let asset = playerItem.asset
        
        do {
            let duration = try await asset.load(.duration)
            totalDuration = duration.seconds
            updateTimelineSlider()
        } catch {
            print(error)
        }
    }
    
    func updateTimelineSlider() {
        guard !isSeeking, let player = player, let duration = totalDuration, duration > 0 else { return }
        
        let currentTime = player.currentTime().seconds
        slider.value = Float(currentTime / duration)
        timeLabel.text = formatTime(currentTime) + " / " + formatTime(duration)
    }
    
    func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}


extension CustomVideoViewController {
    
    // MARK: - 타임라인 슬라이더 조절
    private func timelineValueChanged() {
        let playStatus = player?.isPlaying
        player?.pause()
        
        guard let duration = player?.currentItem?.duration else { return }
        let value = Float64(slider.value) * CMTimeGetSeconds(duration)
        let seekTime = CMTime(value: CMTimeValue(value), timescale: 1)
        
        isSeeking = true
        player?.seek(to: seekTime) { [weak self] _ in
            if playStatus ?? false {
                self?.isSeeking = false
                self?.player?.play()
            }
        }
    }
    
    // MARK: - 전, 후 10초 이동
    func setActionMoveSeconds(goValue: Double) {
        let playStatus = player?.isPlaying
        player?.pause()
        
        guard let currentTime = player?.currentItem?.currentTime() else { return }
        let currentTimeInSecondMove = CMTimeGetSeconds(currentTime).advanced(by: goValue)
        let seekTime = CMTime(value: CMTimeValue(currentTimeInSecondMove), timescale: 1)
        player?.seek(to: seekTime) { [weak self] _ in
            if playStatus ?? false {
                self?.player?.play()
            }
        }
    }
}
