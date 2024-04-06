//
//  ContentView.swift
//  TranslateMe
//
//  Created by Helen Hoang on 4/5/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var translationHistory: [Translation] = []
    @State private var showingHistory = false
    @State private var selectedSourceLanguage: String = "English"
    @State private var selectedTargetLanguage: String = "Spanish"
    @State private var languagePair: String = "en|es"
    let availableLanguages = ["English", "Spanish", "French", "German", "Italian", "Chinese", "Japanese", "Korean", "Russian"]
    let languageCodes: [String: String] = ["English": "en", "Spanish": "es", "French": "fr", "German": "de", "Italian": "it", "Chinese": "zh", "Japanese": "ja", "Korean": "ko", "Russian": "ru"]

    var body: some View
    {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("TranslatorME")
                        .fontWeight(.bold)
                }
                .foregroundColor(.pink)
                .font(.largeTitle)
                .padding(.bottom, 10)
                
                Divider()
                // Language selection
                HStack {
                    Picker("From", selection: $selectedSourceLanguage) {
                        ForEach(availableLanguages, id: \.self) { language in
                            Text(language)
                                .tag(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedSourceLanguage) { newSourceLanguage in
                        updateLanguagePair(source: languageCodes[newSourceLanguage] ?? "en", target: languageCodes[selectedTargetLanguage] ?? "es")
                    }

                    Picker("To", selection: $selectedTargetLanguage) {
                        ForEach(availableLanguages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: selectedTargetLanguage) { newTargetLanguage in
                        updateLanguagePair(source: languageCodes[selectedSourceLanguage] ?? "en", target: languageCodes[newTargetLanguage] ?? "es")
                    }
                }
                .padding()
            
                // Divider()
                
                HStack {
                    Image(systemName: "text.bubble")
                        .foregroundColor(.blue)
                    TextField("Enter text to translate", text: $inputText)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    translateText()
                                    
                }) {
                    HStack {
                        Text("Translate")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding()
                
                Spacer()
                
                // TextEditor to display translation history
                TextEditor(text: $translatedText)
                    .padding()
                    .border(Color.blue, width: 2)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding()
                
                Button(action: {
                    showingHistory = true
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("Translation History")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .sheet(isPresented: $showingHistory) {
                    TranslationHistoryView(translationHistory: $translationHistory)
                }

            }
        }
        .navigationBarTitle("TranslatorME", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            showingHistory = true
        }) {
            Image(systemName: "clock.arrow.circlepath")
        })
    }
    
    
    func translateText() {
        // Call MyMemory API and update translatedText
        // Save translation to Firestore and update translationHistory
        let textToTranslate = inputText
        // languagePair = "es|en" // Example: translating from English to Spanish

        // Construct the URL for the MyMemory API
        let urlString = "https://api.mymemory.translated.net/get?q=\(textToTranslate)&langpair=\(languagePair)"
        let urlEncodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        guard let url = URL(string: urlEncodedString!) else {
            print("Invalid URL")
            return
        }

        // Create a URL request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Start the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            // Parse the response data
            if let data = data {
                if let translationResponse = try? JSONDecoder().decode(TranslationResponse.self, from: data) {
                    // Update the UI on the main thread
                    DispatchQueue.main.async {
                        // Set the translated text
                        self.translatedText = translationResponse.responseData.translatedText
                        
                        // Add to history
                        let newTranslation = Translation(
                            originalText: textToTranslate,
                            translatedText: self.translatedText
                        )
                        self.translationHistory.append(newTranslation)
                    }
                } else {
                    print("JSON decoding error")
                }
            }
        }.resume() // Don't forget to call resume() to start the task
    }
    
    private func updateLanguagePair(source: String, target: String) {
        languagePair = "\(source)|\(target)"
        // Here you can also trigger the translation process if needed
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
