//
//  APIClassification.swift
//  SwiftLearning
//

import Foundation

let geminiApiKey = env.GEMINI_API_KEY
let geminiVisionEndpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String?
            }
            let parts: [Part]?
        }
        let content: Content?
    }
    let candidates: [Candidate]?
}

func classifyImage(imageData: Data) async throws -> String? {
    guard let url = URL(string: "\(geminiVisionEndpoint)?key=\(geminiApiKey)") else {
        print("Error: Invalid Gemini API endpoint")
        return nil
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let base64Image = imageData.base64EncodedString()

    let requestBody: [String: Any] = [
        "contents": [
            "parts": [
                ["inline_data": [
                    "mime_type": "image/jpeg",
                    "data": base64Image
                ]],
                [
                    "text": "What is in this image? give facts about it"
                ]
            ]
        ]
    ]

    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
        print("Error: Couldn't create JSON from request body")
        return nil
    }
    
    request.httpBody = jsonData
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let geminiResponse = try decoder.decode(GeminiResponse.self, from: data)

        if let classification = geminiResponse.candidates?.first?.content?.parts?.first?.text {
            return classification
        }
        
        return nil
    } catch {
        print("Request failed:", error)
        return nil
    }
}
