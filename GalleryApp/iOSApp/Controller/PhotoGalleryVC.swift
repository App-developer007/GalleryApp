//
//  PhotoGalleryVC.swift
//  GalleryApp
//
//  Created by baps on 05/03/24.
//

import UIKit

class PhotoGalleryVC: UIViewController {
    
    // ---------------------------------------------------
    //                 MARK: - Outlet -
    // ---------------------------------------------------
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // ---------------------------------------------------
    //                 MARK: - Property -
    // ---------------------------------------------------
    var imageUrls: [String] = []
    var currentPageIndex: Int = 0
    
    // ---------------------------------------------------
    //                 MARK: - View Life Cycle -
    // ---------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch images from API
        self.fetchImagesFromAPI()
        
        // Add swipe gesture recognizers
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeftGesture.direction = .left
        view.addGestureRecognizer(swipeLeftGesture)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRightGesture.direction = .right
        view.addGestureRecognizer(swipeRightGesture)
    }
    
    // ---------------------------------------------------
    //                 MARK: - Function -
    // ---------------------------------------------------
    func fetchImagesFromAPI() {
        // Replace "YOUR_ACCESS_KEY" with your actual Unsplash API access key
        let accessKey = "nTeqHxw43ISGjP8cM4YRzRY-CpI5PEsM8GGwSdDix4Q"
        let apiUrl = "https://api.unsplash.com/photos"
        let queryParams = [
            "page": "300",
            "per_page": "10"
        ]
        
        var components = URLComponents(string: apiUrl)!
        components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        var request = URLRequest(url: components.url!)
        request.addValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching images: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let photos = try JSONDecoder().decode([Photo].self, from: data)
                self.imageUrls = photos.map { $0.urls.regular }
                DispatchQueue.main.async {
                    self.displayCurrentImage()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                    self.pageControl.isHidden = false
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func displayCurrentImage() {
        guard currentPageIndex >= 0 && currentPageIndex < imageUrls.count else { return }
        
        let imageUrl = imageUrls[currentPageIndex]
        
        if let url = URL(string: imageUrl), let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            
            self.imageView.image = image
        }
        
        // Load and display image from imageUrl using your preferred method
        self.pageControl.numberOfPages = imageUrls.count
        self.pageControl.currentPage = currentPageIndex
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            self.nextPage()
        } else if gesture.direction == .right {
            self.previousPage()
        }
    }
    
    func nextPage() {
        guard currentPageIndex < imageUrls.count - 1 else { return }
        currentPageIndex += 1
        self.displayCurrentImage()
    }
    
    func previousPage() {
        guard currentPageIndex > 0 else { return }
        currentPageIndex -= 1
        self.displayCurrentImage()
    }
}
