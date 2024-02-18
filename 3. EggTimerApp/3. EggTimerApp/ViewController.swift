//
//  ViewController.swift
//  3. EggTimerApp
//
//  Created by Семен Шевчик on 07.02.2024.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.spacing = 0
        element.axis = .vertical
        element.distribution = .fillEqually
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var labelText: UILabel = {
        let element = UILabel()
        element.text = "How do you like your eggs?"
        element.textAlignment = .center
        element.textColor = .black
        element.font = .systemFont(ofSize: 25)
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var eggStack: UIStackView = {
        let element = UIStackView()
        element.spacing = 20
        element.distribution = .fillEqually
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private let softImageView = UIImageView(name: "soft_egg")
    private let softButton = UIButton(name: "Soft")
    
    private let mediumImageView = UIImageView(name: "medium_egg")
    private let mediumButton = UIButton(name: "Medium")
    
    private let hardImageView = UIImageView(name: "hard_egg")
    private let hardButton = UIButton(name: "Hard")
    
    
    private lazy var timerView: UIView = {
        let element = UIView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    private lazy var progressView: UIProgressView = {
        let element = UIProgressView()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    // MARK: - Private Properties
    
    private let eggTimes = ["Soft": 3, "Medium": 420, "Hard": 720]
    private var totalTime = 0
    private var secondPassed = 0
    private var timer = Timer()
    private var player: AVAudioPlayer?
    private var nameSoundTimer = "alarm_sound"
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        
    }
    
    // MARK: - Business Logic
    
    private func playSound(_ soundName: String) {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }

    @objc private func eggsButtonsTapped(_ sender: UIButton) {
        timer.invalidate()
        progressView.setProgress(0, animated: true)
        secondPassed = 0
        
        let hardness = sender.titleLabel?.text ?? "error"
        
        labelText.text = "You should \(hardness)"
        
        totalTime = eggTimes[hardness] ?? 0
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if secondPassed < totalTime {
            secondPassed += 1
            let percentageProgress = Float(secondPassed) / Float(totalTime)
            progressView.setProgress(percentageProgress, animated: true)
        } else {
            playSound(nameSoundTimer)
            timer.invalidate()
            secondPassed = 0
            labelText.text = "That's done! Let's go repeats?"
            progressView.setProgress(1, animated: true)
        }
    }
}
    
// MARK: - Set Views and Constraints

private extension ViewController {
    
    func setupViews() {
        view.backgroundColor = .systemCyan
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(labelText)
        mainStackView.addArrangedSubview(eggStack)
        mainStackView.addArrangedSubview(timerView)
        
        eggStack.addArrangedSubview(softImageView)
        eggStack.addArrangedSubview(mediumImageView)
        eggStack.addArrangedSubview(hardImageView)
        
        softImageView.addSubview(softButton)
        mediumImageView.addSubview(mediumButton)
        hardImageView.addSubview(hardButton)
        
        softButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        mediumButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        hardButton.addTarget(self, action: #selector(eggsButtonsTapped), for: .touchUpInside)
        
        timerView.addSubview(progressView)
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            progressView.centerYAnchor.constraint(equalTo: timerView.centerYAnchor),
            progressView.leadingAnchor.constraint(equalTo: timerView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: timerView.trailingAnchor),
            
            softButton.topAnchor.constraint(equalTo: softImageView.topAnchor),
            softButton.bottomAnchor.constraint(equalTo: softImageView.bottomAnchor),
            softButton.leadingAnchor.constraint(equalTo: softImageView.leadingAnchor),
            softButton.trailingAnchor.constraint(equalTo: softImageView.trailingAnchor),
            
            mediumButton.topAnchor.constraint(equalTo: mediumImageView.topAnchor),
            mediumButton.bottomAnchor.constraint(equalTo: mediumImageView.bottomAnchor),
            mediumButton.leadingAnchor.constraint(equalTo: mediumImageView.leadingAnchor),
            mediumButton.trailingAnchor.constraint(equalTo: mediumImageView.trailingAnchor),
            
            hardButton.topAnchor.constraint(equalTo: hardImageView.topAnchor),
            hardButton.bottomAnchor.constraint(equalTo: hardImageView.bottomAnchor),
            hardButton.leadingAnchor.constraint(equalTo: hardImageView.leadingAnchor),
            hardButton.trailingAnchor.constraint(equalTo: hardImageView.trailingAnchor),
            
            
        ])
    }
}

// MARK: - Extension UI Elemenet

extension UIImageView {
    convenience init(name: String) {
        self.init()
        self.image = UIImage(named: name)
        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIButton {
    convenience init(name: String) {
        self.init()
        self.setTitle(name, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 18, weight: .black)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

