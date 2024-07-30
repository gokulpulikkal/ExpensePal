//
//  AddExpenseViewModel.swift
//  ExpensePal
//
//  Created by Gokul P on 12/07/24.
//

import EmojiPicker
import GoogleGenerativeAI
import Observation
import SwiftUI
import Vision

extension AddExpenseView {
    @Observable
    class ViewModel {

        var expense: Expense

        init(expense: Expense? = nil) {
            if let expense {
                self.expense = expense
            } else {
                self.expense = Expense(emoji: "🛍️", title: "", cost: 0)
            }
        }

        func updateCost(input: String) {
            expense.cost = Double(input) ?? 0
        }

        func updateTitle(title: String) {
            expense.title = title
        }

        func updateEmoji(emoji: String?) {
            expense.emoji = emoji ?? "🛍️"
        }

        func updateSelectedDate(date: Date) {
            expense.date = date
        }

        func recognizeText(scannedImage: UIImage) {
            guard let cgImage = scannedImage.cgImage else {
                return
            }
            let handler = VNImageRequestHandler(cgImage: cgImage)
            let recognizeRequest = VNRecognizeTextRequest { request, _ in

                // Parse the results as text
                guard let result = request.results as? [VNRecognizedTextObservation] else {
                    return
                }

                let maximumCandidates = 1
                var observationList = [(String, CGFloat)]()

                for (_, observation) in result.enumerated() {
                    guard let candidate = observation.topCandidates(maximumCandidates).first else {
                        continue
                    }
                    let text = candidate.string
                    var minDistance = 0.01
                    var replaceIndex: Int? = nil
                    for (itemIndex, (_, minY)) in observationList.enumerated() {
                        if abs(minY - observation.boundingBox.minY) < minDistance {
                            replaceIndex = itemIndex
                            minDistance = abs(minY - observation.boundingBox.minY)
                        }
                    }

                    if replaceIndex == nil {
                        observationList.append((text, observation.boundingBox.minY))
                    } else {
                        observationList[replaceIndex!] = (
                            "\(observationList[replaceIndex!].0) : \(text)",
                            observation.boundingBox.minY
                        )
                    }
                }
                var extractedText = [String]()
                if !observationList.isEmpty {
                    for (item, _) in observationList {
                        extractedText.append(item)
                    }
                }
                let model = ExtractedReceiptDetails(extractedLines: extractedText)
                do {
                    let jsonData = try JSONEncoder().encode(model)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        Task {
                            let model = GenerativeModel(
                                name: "gemini-1.5-flash",
                                apiKey: APIKeyGenAI.default,
                                generationConfig: GenerationConfig(responseMIMEType: "application/json")
                            )
                            let prompt = """
                            \(
                                jsonString
                            )
                            this is a extracted text from a receipt. Consolidate everything in this to a single purchase and create a single data as json string. Make the JSON string to be decoded to a model exactly like below one 

                            struct GenAIResponse: Codable {
                                var emoji: String
                                var title: String
                                var subTitle: String
                                var cost: Double
                                var date: Date
                            }

                            Remove any backticks.
                            """
                            let response = try await model.generateContent(prompt)
                            if let jsonString = response.text, let jsonData = jsonString.data(using: .utf8) {
                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .iso8601
                                let expenseResponseFromGenAI = try decoder.decode(
                                    GenAIResponse.self,
                                    from: jsonData
                                )
                                self.expense = Expense(
                                    emoji: expenseResponseFromGenAI.emoji,
                                    title: expenseResponseFromGenAI.title,
                                    cost: expenseResponseFromGenAI.cost,
                                    date: expenseResponseFromGenAI.date
                                )
                            } else {
                                print("Error $$$$$$$$$$$")
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            // Process the request
            recognizeRequest.recognitionLevel = .accurate
            do {
                try handler.perform([recognizeRequest])
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
