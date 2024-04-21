//
//  ContentView.swift
//  NewsAPI
//
//  Created by Royal, Cindy L on 4/19/24.
//

import SwiftUI
import Combine

// Define your model
struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable {
    var id: String { url }
    let title: String
    let description: String?
    let url: String
    let source: Source
}

struct Source: Codable {
    let id: String?
    let name: String
}

// View Model
class NewsViewModel: ObservableObject {
    @Published var articles = [Article]()

    func fetchNews() {
        let urlString = "https://newsapi.org/v2/everything?q=apple&from=2024-04-18&to=2024-04-18&sortBy=popularity&apiKey=e710c1c7fef44ee59d1af8f740e73002"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.articles = (try? JSONDecoder().decode(NewsResponse.self, from: data))?.articles ?? []
                }
            }
        }.resume()
    }
}

// SwiftUI View
struct NewsListView: View {
    @StateObject var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                VStack(alignment: .leading) {
                    Text(article.title).font(.headline)
                    Text(article.description ?? "No description available").font(.subheadline)
                }
            }
            .navigationTitle("News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}







#Preview {
    NewsListView()
}
