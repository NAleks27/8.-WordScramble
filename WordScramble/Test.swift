//
//  Test.swift
//  WordScramble
//
//  Created by Aleksey Nosik on 08.10.2022.
//


//MARK: List, Bundle, UITextChecker

import SwiftUI

struct Test: View {
    
    let people = ["Finn", "Leia", "Bonnie", "Rockie"]
    
    var body: some View {
        VStack {
            List {
                Section("Section 1") {
                    Text("Static row 1")
                    Text("Static row 2")
                }
                
                Section("Section 2") {
                    ForEach(0..<5) {
                        Text("Dynamic row \($0)")
                    }
                }
                
                Section("Section 3") {
                    Text("Static row 3")
                    Text("Static row 4")
                }
            }
            .listStyle(.grouped)
            
            
            List(people, id: \.self) {
                Text($0)
            }
            .listStyle(.grouped)
        }
    }
    
    func loadFile() {
        if let fileURL = Bundle.main.url(forResource: "some-file", withExtension: "txt") {
            if let fileContents = try? String(contentsOf: fileURL) {
                // we loaded the file into the string
                // fileContents - string
            }
        }
    }
    
    func text() {
        let input = "a b c"
        let input2 = """
        a
        b
        c
        """
        
        let letters = input.components(separatedBy: " ")
        let letters2 = input2.components(separatedBy: "\n")
        
        let letter = letters2.randomElement()
        
        let trimming = letter?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func test2() {
        // create word
        let word = "swift"
        
        // create checker from uikit
        let checker = UITextChecker()
        
        //create range for our word from objective-c
        let range = NSRange(location: 0, length: word.utf16.count)
        
        // create range with mistakes
        let misspeldRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        // create marker because in objective-c missing optionals
        let allGood = misspeldRange.location == NSNotFound
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
