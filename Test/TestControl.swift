//
//  TestControl.swift
//  VkApp
//
//  Created by Дмитрий Кокорин on 06.07.2023.
//

import UIKit

enum Day: Int, CaseIterable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    
    
    
    var title: String {
        switch self {
        case .monday:
            return "ПН"
        case .tuesday:
            return "ВТ"
        case .wednesday:
            return "СР"
        case .thursday:
            return "ЧТ"
        case .friday:
            return "ПТ"
        case .saturday:
            return "СБ"
        case .sunday:
            return "ВС"
        }
    }
}

final class TestControl: UIControl {
    
    var selectDay: Day? = nil
    
    private var buttons = [UIButton]()
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc
    private func selectedDay(_ button: UIButton) {
        guard
            let index = buttons.firstIndex(of: button),
            let day = Day(rawValue: index)
        else { return }
        
        self.selectDay = day
    }
    
    private func setupView() {
        Day.allCases.forEach {
            let button = UIButton(type: .system)
            button.setTitle($0.title, for: [])
            button.setTitleColor(.systemGray6, for: .normal)
            button.setTitleColor(.systemBackground, for: .selected)
            
            button.addTarget(self, action: #selector(selectedDay(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        stackView = UIStackView(arrangedSubviews: buttons)
        addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        
    }
    
    private func updateSelectedDay() {
        for (index, button) in buttons.enumerated() {
            guard let day = Day(rawValue: index) else { continue }
            button.isSelected = day == selectDay
        }
    }
}

