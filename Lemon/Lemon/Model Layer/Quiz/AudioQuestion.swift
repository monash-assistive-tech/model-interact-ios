//
//  AudioQuestion.swift
//  Lemon
//
//  Created by Andre Pham on 28/8/2023.
//

import Foundation

class AudioQuestion: Question {
    
    private let answers: [[String]]
    
    init(questionText: String, answers: [[String]]) {
        self.answers = answers
        super.init(questionText: questionText, answerType: .audio)
    }
    
    func checkAnswer(provided: SpeechText) -> AnswerStatus {
        // We start off assuming they're incorrect
        var finalAnswer: AnswerStatus = .incorrect
        for answer in self.answers {
            // We don't want to accept duplicate answers, such as "thorax, thorax, thorax"
            var answerChecklist = Array(answer)
            var correctCount = 0
            var incorrectCount = 0
            let filteredProvided = provided.getWords(without: "and", "a", "do", "the")
            for word in filteredProvided {
                if let matchingIndex = answerChecklist.firstIndex(where: { $0 == word }) {
                    correctCount += 1
                    answerChecklist.remove(at: matchingIndex)
                } else {
                    incorrectCount += 1
                }
            }
            if correctCount == answer.count {
                // If they've got the correct answer, return correct immediately
                return .correct
            } else if incorrectCount == 0 {
                // If the answer is partially there, we set the final answer to partial
                // (We still check the rest in case they're correct)
                finalAnswer = .partial
            }
            // If we make it here, it's incorrect - either we've already found a partial answer (hence discard the incorrect)
            // or, the final answer is already incorrect (by default)
        }
        return finalAnswer
    }
    
}
