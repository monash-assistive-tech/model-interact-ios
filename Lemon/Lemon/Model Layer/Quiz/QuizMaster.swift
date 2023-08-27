//
//  QuizMaster.swift
//  Lemon
//
//  Created by Andre Pham on 25/8/2023.
//

import Foundation

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
    public var activationPhrases: [String] {
        return ["quiz me", "chris me"]
    }
    public var shorthandActivationPhrases: [String] {
        return ["quiz", "chris"]
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
    
    func isActivatedBy(speech: SpeechText, useShorthand: Bool = false) -> Bool {
        let phrases = useShorthand ? self.shorthandActivationPhrases : self.activationPhrases
        for phrase in phrases {
            if speech.contains(phrase) {
                return true
            }
        }
        return false
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
