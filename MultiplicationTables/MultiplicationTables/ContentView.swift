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
                    
                    Stepper("Table of: \(chosenTable)", value: $chosenTable, in: 2...maxValueTable)
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
                        isStarted ? restart() : askQuestions()
                        withAnimation {
                            isStarted.toggle()
                        }
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
                        }
                        HStack{
                            ForEach(answer, id: \.self){ num in
                                Button("\(num)"){
                                    withAnimation {
                                        checkAnswer(question: question, answer: num)
                                        //checkAnswer dopo aver fatto il controllo resetta showResult a false ma in quel caso l'animazione mi va a scatti
                                    }
                                }
                                .frame(width: 50, height: 50)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                } else {
                    Spacer()
                    Spacer()
                }
                
                if showResult {
                    Text(isRight ? "Correct" : "Wrong")
                        .foregroundColor(isRight ? .white : .red)
                        .font(.title2)
                        .padding(20)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        .animation(.easeOut, value: showResult)
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
        
        withAnimation {
            showResult = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7){
            
            answer.removeAll()
            
            guard questionNumber <= numberOfQuestion else {
                alertTitle = "Finish"
                alertMessage = "Right answer \(rightAnswer) / \(numberOfQuestion)"
                alertIsShowed = true
                isStarted = false
                return
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
    
    func askQuestions(){
            
            answer.removeAll()
            
            guard questionNumber <= numberOfQuestion else {
                alertTitle = "Finish"
                alertMessage = "Right answer \(rightAnswer) / \(numberOfQuestion)"
                alertIsShowed = true
                isStarted = false
                return
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
    
    func restart(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            chosenTable = 2
            numberOfQuestion = 1
            questionNumber = 1
            question = 0
            rightAnswer = 0
            answer.removeAll()
            showResult = false
        }
    }
    
    func checkAnswer(question: Int, answer: Int){
        
        if question == answer {
            isRight = true
            rightAnswer += 1
            showResult = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                nextQuestion()
            }
            
        } else {
            showResult = true
            isRight = false
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
