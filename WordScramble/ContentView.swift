//
//  ContentView.swift
//  WordScramble
//
//  Created by Aleksey Nosik on 06.10.2022.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMesssage = ""
    @State private var showingError = false
    
    @State private var lettersCounter = 0
    
    var body: some View {
        NavigationView {
            List {
                Section("Your word") {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section("Score") {
                    HStack {
                        Text("Words")
                        Spacer()
                        Text("\(usedWords.count)")
                    }
                    
                    HStack {
                        Text("Letters")
                        Spacer()
                        Text("\(lettersCounter)")
                    }
                }.bold()
                
                Section(usedWords.isEmpty ? "" : "Used Words" ) {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            } 
            .navigationTitle(rootWord)
            .navigationBarTitleDisplayMode(.large)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame) // вызов функции с возможным фатал эррор
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMesssage)
            }
            .toolbar {
                Button("New Game", action: newGame)
                    .buttonStyle(.borderedProminent)
                    .bold()
                
                Button("New Word", action: startGame)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
    
    func addNewWord() {
        // делаем вводные данные без пробелов и в нижнем регистре
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // проверяем чтобы слово имело хоть одну букву
        guard answer.count > 2 else {
            wordError(title: "This word is too short", message: "Enter other word")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "This word couldn't be as main", message: "Enter other word")
            return
        }
        
        // проверяем что наше слово не использовалось еще
        guard isOriginal(word: answer) else {
            wordError(title: "This word used already", message: "Be more original!")
            return
        }

        //проверяем что наше слово можно составить из предложенного
        guard isPossible(word: answer) else {
            wordError(title: "This word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        // проверяем что наше слово вообще существует
        guard isReal(word: answer) else {
            wordError(title: "This word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        // добавляем наше слово в начало массива использованных слов просто с анимацией
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        // обнуляем наше слово
        newWord = ""
        
        lettersCounter += answer.count
    }
    
    func startGame() {
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWord = try? String(contentsOf: startWordURL) {
                let allWords = startWord.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from our bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        newWord = ""
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMesssage = message
        showingError = true
    }
    
    func newGame() {
        startGame()
        newWord = ""
        usedWords = []
        lettersCounter = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
