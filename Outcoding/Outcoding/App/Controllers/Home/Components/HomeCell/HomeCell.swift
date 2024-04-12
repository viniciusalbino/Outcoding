
import Foundation
import UIKit

class HomeCell: UIView {
    
    // MARK: - Properties
    private let pictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    // MARK: - Life's Cycle
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        createUIElements()
        configureConstraints()
    }
    
    private func createUIElements() {
        backgroundColor = .white
        
        addSubview(pictureImageView)
        addSubview(textStackView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(subTitleLabel)
    }
    
    private func configureConstraints() {
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            pictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            pictureImageView.widthAnchor.constraint(equalToConstant: 60),
            pictureImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textStackView.leadingAnchor.constraint(equalTo: pictureImageView.trailingAnchor, constant: 8),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func fill(dto: HomeCellDTO) {
        titleLabel.text = "Weight: \(dto.name)"
        subTitleLabel.text = "Height: \(dto.subtitle)"
        if let url = URL(string: dto.imageURL) {
            downloadImage(url: url)
        }
    }
    
    private func downloadImage(url: URL) {
        let imageDownloader = ImageDownloader()
        Task {
            do {
                let image = try await imageDownloader.downloadImage(from: url)
                pictureImageView.image = image
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

struct HomeCellDTO {
    let imageURL: String
    let name: String
    let subtitle: String
}
