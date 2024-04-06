//
//  TranslationHistoryView.swift
//  TranslateMe
//
//  Created by Helen Hoang on 4/5/24.
//

import SwiftUI

struct TranslationHistoryView: View {
    @Binding var translationHistory: [Translation]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(translationHistory) { translation in
                        VStack(alignment: .leading) {
                            Text("Original: \(translation.originalText)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Translated: \(translation.translatedText)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                //.navigationBarTitle("Translation History", displayMode: .automatic)
                
                Button(action: {
                    translationHistory.removeAll()
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                        Text("Clear History")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.pink)
                    //.cornerRadius(10)
                }
            }
            .navigationBarTitle("Translation History", displayMode: .automatic)
            
        }
    }
}

struct TranslationHistoryView_Previews: PreviewProvider {
    @State static var translationHistory: [Translation] = [
        Translation(originalText: "Hola", translatedText: "Hello"),
        Translation(originalText: "Adiós", translatedText: "Goodbye")
    ]

    static var previews: some View {
        TranslationHistoryView(translationHistory: $translationHistory)
    }
}
