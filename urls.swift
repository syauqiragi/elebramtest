let task = URLSession.shared.dataTask(with: url) { data, response, error in
    if let data = data {
        if let books = try? JSONDecoder().decode([Book].self, from: data) {
            print(books)
        } else {
            print("Invalid Response")
        }
    } else if let error = error {
        print("HTTP Request Failed \(error)")
    }
}
