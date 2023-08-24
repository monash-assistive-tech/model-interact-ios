//
//  QuizMaster.swift
//  Lemon
//
//  Created by Andre Pham on 25/8/2023.
//

import Foundation

enum AnswerStatus {
    case incorrect
    case correct
    case partial
}

class QuizMaster {
    
    private var questions = [String]()
    private var answers = [[String]]()
    private var questionIndex: Int? = nil
    private(set) var readyForAnswer = false
    public var loadedQuestion: String? {
        return self.questionIndex == nil ? nil : self.questions[questionIndex!]
    }
    
    init() {
        self.questions = [
            "Question 1",
            "Question 2",
        ]
        self.answers = [
            ["cats", "dogs"],
            ["milk", "honey"],
        ]
    }
    
    func loadNextQuestion() {
        if let questionIndex {
            self.questionIndex = (questionIndex + 1)%self.questions.count
        } else {
            self.questionIndex = 0
        }
        self.readyForAnswer = true
    }
    
    func acceptAnswer(provided: SpeechText) -> AnswerStatus {
        guard let questionIndex else {
            assertionFailure("Answer shouldn't be accepted with no question loaded")
            self.readyForAnswer = false
            return .partial
        }
        let answer = self.answers[questionIndex]
        var correctCount = 0
        var incorrectCount = 0
        let filteredProvided = provided.getWords(without: "and")
        for word in filteredProvided {
            if answer.contains(word) {
                correctCount += 1
            } else {
                incorrectCount += 1
            }
        }
        
        print("provided: \(provided.words)")
        print("answer: \(answer)")
        print("correct/incorrect: \(correctCount)/\(incorrectCount)")
        
        if correctCount == answer.count {
            self.readyForAnswer = false
            return .correct
        } else if incorrectCount == 0 {
            return .partial
        } else {
            return .incorrect
        }
    }
    
}
