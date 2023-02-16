//
//  AdditionalCategoryDetailInteractor.swift
//  Pods
//
//  Created by Santo Michale on 18/01/23.

// MARK: - Interactor
internal class AdditionalCategoryDetailInteractor: AdditionalCategoryDetailInteractable {
    weak var presenter: AdditionalCategoryDetailPresenterProtocol?
    
    init(presenter: AdditionalCategoryDetailPresenterProtocol? = nil) {
        self.presenter = presenter
    }
}

// MARK: - Service
extension AdditionalCategoryDetailInteractor: AdditionalCategoryDetailServiceHandler {
    internal func getAdditionalCategoryFilledDetail() {
        let url = URL(string: "https://raw.githubusercontent.com/mafmudin/apicontract/main/additional_data_detail.json")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AdditionalCategoryDetailsModel.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_success(data: response.toDomain())
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_failed(error: error)
                }
            }
        }
        
        task.resume()
    }
    
    internal func getAdditionalCategoryMaskedDetail() {
        let url = URL(string: "https://raw.githubusercontent.com/mafmudin/apicontract/main/additional_data_detail.json")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AdditionalCategoryDetailsModel.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_success(data: response.toDomain())
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_failed(error: error)
                }
            }
        }
        
        task.resume()
    }
    
    internal func getAdditionalCategoryEmptyDetail() {
        let url = URL(string: "https://raw.githubusercontent.com/mafmudin/apicontract/main/additional_data_detail.json")!
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AdditionalCategoryDetailsModel.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_success(data: response.toDomain())
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_failed(error: error)
                }
            }
        }
        
        task.resume()
    }
}






DispatchQueue.global().async { [weak self] in
                guard let self = self,
                      let url = URL(string: fileURL),
                      let data = try? Data(contentsOf: url),
                      let image = UIImage(data: data)
                else { return }
                
                DispatchQueue.main.async {
                    self.imgView.image = image
                }
            }


let url = URL(string: "https://raw.githubusercontent.com/mafmudin/apicontract/main/additional_data_detail.json")!
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(["username": "halo"]) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") 
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AdditionalCategoryDetailsModel.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_success(data: response.toDomain())
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presenter?.getAdditionalCategoryDetail_failed(error: error)
                }
            }
        }
        
        task.resume()
