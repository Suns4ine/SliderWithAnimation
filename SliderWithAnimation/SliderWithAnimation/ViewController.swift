//
//  ViewController.swift
//  SliderWithAnimation
//
//  Created by Vyacheslav Pronin on 09.07.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var squareView: UIView = {
        let view = UIImageView(frame: CGRect(x: Constant.horizontal,
                                        y: Constant.vertical + 80,
                                        width: Constant.height,
                                        height: Constant.height))
        view.backgroundColor = .systemYellow
        view.layer.cornerRadius = 8
        view.image = UIImage(named: "yea")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider(frame: CGRect(x: Constant.horizontal,
                                            y: squareView.frame.maxY + Constant.vertical,
                                            width: view.frame.width - Constant.horizontal * 2,
                                            height: Constant.height / 2))
        slider.tintColor = .systemYellow
        slider.minimumValue = Constant.minValue
        slider.maximumValue = Constant.maxValue
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchUp), for: [.touchUpInside, .touchUpOutside])
        return slider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [squareView, slider].forEach {
            view.addSubview($0)
        }
    }
    
}

private extension ViewController {
    
    enum Constant {
        static let minValue: Float = 0.0
        static let maxValue: Float = 1.0
        
        static let vertical: CGFloat = 20
        static let horizontal: CGFloat = 16
        
        static let height: CGFloat = 60
        static let rotation: CGFloat = .pi / 2
    }
    
    @objc func sliderValueChanged() {
        let currentTransform = CGFloat(slider.value * slider.maximumValue)
        let rotation = CGAffineTransform(rotationAngle: currentTransform * Constant.rotation)
        let transform = rotation.scaledBy(x: currentTransform * 0.5 + 1.0,
                                          y: currentTransform * 0.5 + 1.0)
        squareView.transform = transform

        let minX = Constant.horizontal + squareView.frame.width / 2
        let maxX = view.frame.width - Constant.horizontal - squareView.frame.width / 2
        squareView.center.x = minX + (maxX - minX) * CGFloat(slider.value)
    }
    
    @objc func sliderTouchUp() {
        if slider.value > Constant.minValue {
            UIView.animate(withDuration: 0.3) {
                self.slider.setValue(Constant.maxValue, animated: true)
                self.sliderValueChanged()
            }
        }
    }
}
