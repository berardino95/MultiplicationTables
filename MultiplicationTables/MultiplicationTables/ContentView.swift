//
//  ContentView.swift
//  MultiplicationTables
//
//  Created by CHIARELLO Berardino - ADECCO on 05/05/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var chosenTable = 2
    @State private var numberOfQuestion = 1
    @State private var questionNumber = 1
    @State private var question = 0
    @State private var answer = [Int]()
    @State private var rightAnswer = 0
    
    @State private var isStarted = false
    @State private var showResult = false
    @State private var isRight = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertIsShowed = false
    
    @State private var randomImage : String = ""
    
    let maxValueTable = 12
    
    let animalImage = ["bear", "buffalo", "walrus", "snake", "sloth", "rhino", "rabbit", "pig", "penguin", "parrot", "panda", "owl", "narwhal", "moose", "monkey", "horse", "hippo", "gorilla", "goat", "giraffe", "frog", "elephant", "duck", "dog", "crocodile", "cow", "chicken", "chick", "buffalo", "bear"]
    
    
    
    var body: some View {
        ZStack{
            Color.blue
                .ignoresSafeArea()
            VStack {
                Image(randomImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 100, maxHeight: 100)
                
                Text("Multiplications with animal")
                    .multilineTextAlignment(.center)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                
                Spacer()
                VStack(spacing: 10){
                    
                    Stepper("Multiply by \(chosenTable)", value: $chosenTable, in: 2...maxValueTable)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Stepper("\(numberOfQuestion) questions", value: $numberOfQuestion, in: 1...100)
                        .font(.title3)
                        .foregroundColor(.blue)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                    Button(isStarted ? "Stop the game" : "Start the game") {
                        isStarted ? restart() : startGame()
                    }
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(isStarted ? .red : .white)
                    .foregroundColor(isStarted ? .white : .green)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    
                }
                
                if isStarted {
                    Spacer()
                    VStack{
                        HStack{
                            Text("\(chosenTable) x \(question/chosenTable)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                        }
                        HStack{
                            ForEach(answer, id: \.self){ num in
                                Button("\(num)"){
                                    withAnimation {
                                        checkAnswer(question: question, answer: num)
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        
                        Text(isRight ? "Correct" : "Wrong")
                            .foregroundColor(isRight ? .white : .orange)
                            .font(.title2)
                            .padding(20)
                            .opacity(showResult ? 1 : 0)
                    }
                } else {
                    Spacer()
                    Spacer()
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 30)
            .padding()
            .alert(alertTitle, isPresented: $alertIsShowed) {
                Button("Ok", role: .cancel){
                        restart()
                }
            } message: {
                Text(alertMessage)
            }
            .onAppear{
                randomImage = animalImage.randomElement() ?? ""
            }
        }
    }
    
    
    func nextQuestion(){

        guard questionNumber <= numberOfQuestion else {
            alertTitle = "Finish"
            alertMessage = "Right answer \(rightAnswer) / \(numberOfQuestion)"
            alertIsShowed = true
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
            answer.removeAll()
            
            withAnimation {
                showResult = false
            }
            
            questionNumber += 1
            
            question = chosenTable * Int.random(in: 2...maxValueTable)
            answer.append(question)
            while answer.count < 3 {
                let randomValue = Int.random(in: 2...chosenTable * maxValueTable)
                
                if !answer.contains(randomValue){
                    answer.append(randomValue)
                } else {
                    continue
                }
            }
            
            answer.shuffle()
            
            print(question)
            print(answer)
        }
    }
    
    func startGame(){
        
        answer.removeAll()
        
        questionNumber += 1
        
        question = chosenTable * Int.random(in: 2...maxValueTable)
        
        answer.append(question)
        
        while answer.count < 3 {
            let randomValue = Int.random(in: 2...chosenTable * maxValueTable)
            
            if !answer.contains(randomValue){
                answer.append(randomValue)
            } else {
                continue
            }
        }
        
        answer.shuffle()
        
        
        withAnimation {
            isStarted = true
        }
        
        print(question)
        print(answer)
        
    }
    
    func restart(){
        withAnimation {
            isStarted = false
            showResult = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            chosenTable = 2
            numberOfQuestion = 1
            questionNumber = 1
            question = 0
            rightAnswer = 0
            answer.removeAll()

        }
    }
    
    func checkAnswer(question: Int, answer: Int){
        
        if question == answer {
            isRight = true
            rightAnswer += 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation {
                    showResult = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                nextQuestion()
            }
            
        } else {
            isRight = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                withAnimation {
                    showResult = true
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                nextQuestion()
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
