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

class Question {
    
    enum AnswerType {
        case audio
        case visual
    }
    
    public let questionText: String
    public let answerType: AnswerType
    
    init(questionText: String, answerType: AnswerType) {
        self.questionText = questionText
        self.answerType = answerType
    }
    
}

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

class VisualQuestion: Question {
    
    private let answers: [TagmataClassification]
    
    init(questionText: String, answers: [TagmataClassification]) {
        self.answers = answers
        super.init(questionText: questionText, answerType: .visual)
    }
    
    func checkAnswer(provided: TagmataClassification) -> AnswerStatus {
        for answer in self.answers {
            if provided == answer {
                return .correct
            }
        }
        return .incorrect
    }
    
}

class QuizMaster {
    
    /// The questions to ask - when every question is asked they repeat in order again
    private var questions = [Question]()
    /// The index of the active question from the questions list
    private var questionIndex: Int = -1
    /// If the quiz master is awaiting an audio answer (a spoken answer provided by the user)
    private(set) var readyForAudioAnswer = false
    /// If the quiz master is awaiting a visual answer (e.g. holding a specific part of the insect)
    private(set) var readyForVisualAnswer = false
    /// If the quiz master has received a question, but has not yet been flagged as ready for an answer
    private(set) var questionReceived = false
    private var loadedQuestion: Question {
        return self.questions[self.questionIndex]
    }
    public var loadedQuestionText: String {
        return self.questions[self.questionIndex].questionText
    }
    
    init() {
        self.questions = [
            AudioQuestion(
                questionText: "What are my three main body segments?",
                answers: [
                    // It's hard to split these into variations - if you only expect x words you can't expect them broken up
                    // E.g. mouthparts / mouth parts
                    ["head", "thorax", "abdomen"],
                    ["how", "thorax", "abdomen"],
                    ["had", "thorax", "abdomen"],
                    ["add", "thorax", "abdomen"],
                    ["heard", "thorax", "abdomen"],
                    ["head", "thrax", "abdomen"],
                    ["how", "thrax", "abdomen"],
                    ["had", "thrax", "abdomen"],
                    ["add", "thrax", "abdomen"],
                    ["heard", "thrax", "abdomen"],
                ]
            ),
            AudioQuestion(
                questionText: "Which main body segment is connected to the wings?",
                answers: [["thorax"], ["thrax"]]
            ),
            AudioQuestion(
                questionText: "What three main receptor parts can be found on my head?",
                answers: [["antenna", "eyes", "mouthparts"], ["antenna", "eyes", "mouth", "parts"]] // in tenna
            ),
            AudioQuestion(
                questionText: "What two parts make up my wing?",
                answers: [
                    ["for", "wing", "hind"],
                    ["four", "wing", "hind"],
                    ["forewing", "hindwing"],
                    ["forewing", "hind", "wing"],
                    ["for", "wing", "hindwing"],
                    ["four", "wing", "hindwing"],
                    ["for", "wing", "find"],
                    ["four", "wing", "find"],
                    ["forewing", "find"],
                ]
            ),
            VisualQuestion(
                questionText: "Can you identify my left wing?",
                answers: [.leftWing]
            )
        ]
    }
    
    func markQuestionAsReceived(_ received: Bool) {
        self.questionReceived = received
    }
    
    func loadNextQuestion() {
        // Reset ready-for answers (just in case)
        self.readyForAudioAnswer = false
        self.readyForVisualAnswer = false
        self.questionIndex = (questionIndex + 1)%self.questions.count
    }
    
    func markReadyForAnswer() {
        switch self.loadedQuestion.answerType {
        case .audio:
            self.readyForAudioAnswer = true
        case .visual:
            self.readyForVisualAnswer = true
        }
    }
    
    func acceptAnswer(provided: SpeechText) -> AnswerStatus {
        let question = self.questions[questionIndex]
        if let audioQuestion = question as? AudioQuestion {
            let result = audioQuestion.checkAnswer(provided: provided)
            if result == .correct {
                // The question is complete - stop listening for answers
                self.readyForAudioAnswer = false
            }
            return result
        } else {
            assertionFailure("Answer was provided when the corresponding question wasn't ready")
            self.readyForAudioAnswer = false
            return .partial
        }
    }
    
    func acceptAnswer(provided: TagmataClassification) -> AnswerStatus {
        let question = self.questions[questionIndex]
        if let visualQuestion = question as? VisualQuestion {
            let result = visualQuestion.checkAnswer(provided: provided)
            if result == .correct {
                // The question is complete - stop listening for answers
                self.readyForVisualAnswer = false
            }
            return result
        } else {
            assertionFailure("Answer was provided when the corresponding question wasn't ready")
            self.readyForVisualAnswer = false
            return .partial
        }
    }
    
}
