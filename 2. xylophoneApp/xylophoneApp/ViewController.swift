//
//  ViewController.swift
//  xylophoneApp
//
//  Created by Семен Шевчик on 07.02.2024.
//

import UIKit
import AVFoundation

final class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var nameButtons = ["A", "C", "B", "F", "G", "E", "D"]
    
    private var player: AVAudioPlayer?
    
    // MARK: - UI
    
    private lazy var mainStackView: UIStackView = {
        let element = UIStackView()
        element.backgroundColor = .white
        element.axis = .vertical
        element.alignment = .center
        element.distribution = .fillEqually
        element.spacing = 10
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        createButtons()
        view.backgroundColor = .white
    }
    
    // MARK: - Business Logic
    
    private func createButtons() {
        for (index, nameButton) in nameButtons.enumerated() {
            let multiplierWidht = 0.97 - (0.03 * Double(index))
            createdButton(named: nameButton, widht: multiplierWidht)
        }
    }
    
    private func createdButton(named: String, widht: Double) {
        let button = UIButton(type: .system)
        button.setTitle(named, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.backgroundColor = getColor(nameText: named)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.widthAnchor.constraint(equalTo: mainStackView.widthAnchor, multiplier: widht).isActive = true
        button.heightAnchor.constraint(equalToConstant: 100).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        mainStackView.addArrangedSubview(button)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        toggleAlphaButton(sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.toggleAlphaButton(sender)
        }
        guard let buttonText = sender.currentTitle else { return }
        playSound(buttonText)
    }
    
    private func toggleAlphaButton (_ button: UIButton) {
        button.alpha = button.alpha == 1 ? 0.5 : 1
    }
    
    private func playSound (_ buttonText: String) {
        guard let url = Bundle.main.url(forResource: buttonText, withExtension: "wav") else { return }
        
        player = try! AVAudioPlayer(contentsOf: url)
        player?.play()
    }
    
    private func getColor (nameText: String) -> UIColor {
        switch nameText {
        case "A": return .systemRed
        case "C": return .systemYellow
        case "B": return .systemBlue
        case "F": return .systemGray
        case "G": return .systemBrown
        case "E": return .systemPink
        case "D": return .systemMint
            
        default:
            return .white
        }
    }
}

// MARK: - Set Views and Constraints

private extension ViewController {
    func setupViews() {
        view.addSubview(mainStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
}
