//
//  VisualQuestionWaterCycle.swift
//  Lemon
//
//  Created by Ishrat Kaur on 11/5/2024.
//

import Foundation

class VisualQuestionWaterCycle: QuestionWaterCycle {
    
    private let answers: [WaterCycleClassification]
    
    init(questionText: String, answers: [WaterCycleClassification]) {
        self.answers = answers
        super.init(questionText: questionText, answerType: .visual)
    }
    
    func checkAnswer(provided: WaterCycleClassification) -> AnswerStatusWaterCycle {
        for answer in self.answers {
            if provided == answer {
                return .correct
            }
        }
        return .incorrect
    }
    
}
