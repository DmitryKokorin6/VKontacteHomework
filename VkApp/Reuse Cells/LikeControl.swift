//
//  LikeControl.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 09.07.2023.
//

import UIKit


@IBDesignable
final class LikeControl: UIControl {
    // MARK: Public properties
    var isLiked: Bool = false {
        // наблюдатель свойства выполняет код после установки значения для чвойства
        // вызывается каждый раз когда у войства новое значение
        didSet {
            updateLikeState()
            sendActions(for: .valueChanged)
        }
    }

    // MARK: Private properties
    private var likeButton: UIButton!
    private var stackView: UIStackView!

    // MARK: Lifecycle
    // вызывается чтобы создать контрол программно и нужно создать frame контрола
    override init(frame: CGRect) {
        // инициализация базового класса
        super.init(frame: frame)
        setupView()
    }
    // инициализация потому что кнопка создается на Stryboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    // вызывается при перерисовки frame like
    override func layoutSubviews() {
        stackView.frame = bounds
    }

    // MARK: Actions
    // переключает с true на false
    @objc
    private func toggleLike() {
        isLiked.toggle()
    }

    // MARK: Private methods
    private func setupView() {
        likeButton = UIButton(type: .system)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .focused)
        likeButton.addTarget(self, action: #selector(toggleLike), for: .touchUpInside)
        likeButton.backgroundImage(for: .normal)
        likeButton.backgroundColor = .clear

        stackView = UIStackView(arrangedSubviews: [likeButton])
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor)
        ])
        
    }

    private func updateLikeState() {
        likeButton.isSelected = isLiked
    }
}
