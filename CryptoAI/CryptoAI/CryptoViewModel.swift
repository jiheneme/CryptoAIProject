//
//  CryptoViewModel.swift
//  CryptoAI
//
//  Created by Jihene on 28/04/2025.
//

import Foundation
import Combine

class CryptoViewModel: ObservableObject {
    @Published var cryptos: [Crypto] = []
    @Published var lastUpdated: Date? = nil

    private var timer: Timer?

    init() {
        fetchCryptos()
        startTimer()
    }

    func fetchCryptos() {
        let ids = "bitcoin,ethereum,ripple,cardano,solana,polkadot,dogecoin,tron,polygon,litecoin,chainlink,stellar"
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=\(ids)&order=market_cap_desc&per_page=12&page=1&sparkline=false&price_change_percentage=24h"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([Crypto].self, from: data)
                    DispatchQueue.main.async {
                        self.cryptos = decodedData
                        self.lastUpdated = Date()
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            } else if let error = error {
                print("Network error: \(error)")
            }
        }.resume()
    }

    // MARK Helper Function 
     func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
            self.fetchCryptos()
        }
    }

    deinit {
        timer?.invalidate()
    }
}
