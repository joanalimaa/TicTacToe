//
//  ContentView.swift
//  Tictactoe
//
//  Created by Joana Lima on 12/10/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
        
        NavigationView {
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(.dark) //chaged background color
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View{
    
    //Moves
    @State var moves : [String] = Array(repeating: "", count: 9)
    //To identify the current Player
    @State var isPlaying = true //false -> O goes first and true -> X goes first
    @State var gameOver = false
    @State var msg = ""
    @State var msg2 = ""
    
    
    var body: some View{
        
        VStack{
            //GridView for playing
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15){
                
                ForEach(0..<9, id: \.self){index in
                    ZStack {
                        
                        //Flip animation
                        Color.pink //Colour of the card after flipped
                        
                        Color.teal //Colour of the card before flipped
                            .opacity(moves[index] == "" ? 1 : 0)
                    
                        Text(moves[index])
                            .font(.system(size: 80))
                            .fontWeight(.heavy)
                            .foregroundColor(.white) //Colour of the text
                            .opacity(moves[index] != "" ? 1 : 0)
                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15) //obviously
                    .rotation3DEffect(.init(degrees: moves[index] != "" ? 180 : 0), axis: (x:0.0, y: 1.0, z: 0.0), anchor: .center, anchorZ: 0.0, perspective: 1.0)
                    
                    //Whenever tapped adding move
                    .onTapGesture(perform: {
                        
                        withAnimation(Animation.easeIn(duration: 0.5)){
                            
                            if moves[index] == ""{ //Putting this makes so you wont be able to change the simbol once its selected (why?)
                                moves[index] = isPlaying ? "X" : "O"
                                //Updating player
                                isPlaying.toggle()
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        //Whenever moves are updated it will check for winner
        .onChange(of: moves, perform: {value in
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            Alert(title: Text(msg2), message: Text(msg), dismissButton: .destructive(Text("Play Again"), action: {
                
                //reseting all data
                withAnimation(Animation.easeIn(duration: 0.5)){
                    
                    moves.removeAll()
                    moves = Array(repeating: "", count: 9)
                    isPlaying = true
                }
            }))
        })
    }
    
    //calculating width
    
    func getWidth() -> CGFloat{
        
        //Horizontal padding = 30
        //spacing = 30
        let width = UIScreen.main.bounds.width - (30 + 30) //for the last 30 apparently added the two 15 from up there
        return width / 3
    }
    
    //Checking for winner
    
    func checkWinner(){
        if checkMoves(player: "X"){
            //Showing allertView
            msg2 = "Winner"
            msg = "Player X is the winner!!!!"
            gameOver.toggle()
            
        }
        else if checkMoves(player: "O"){
            msg2 = "Winner"
            msg = "Player O is the winner!!!!"
            gameOver.toggle()
        }
        else{
            //Checking no moves
            
            let status = moves.contains{ (value) -> Bool in
                return value == ""
            }
            if !status{
                msg2 = "No winners"
                msg = "Game Over. It's a tie!!"
                gameOver.toggle()
            }
        }
    }
    
    func checkMoves(player: String)->Bool{
        
        //Horizontal moves
        for i in stride(from: 0, to: 9, by: 3){
            
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player{
                return true
            }
        }
        
        //Vertical moves
        for i in 0...2{
            
            //the number correspond to the card position, i is the one you chose and you add the number to get to the other positions and see who the winner is
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player{
                return true
            }
        }
        
        //Checking diagonal
        
//        if moves[0] == player && moves[4] == player && moves[8] == player{
//            return true
//        }
//
        if moves[2] == player && moves[4] == player && moves[6] == player{
            return true
        }
        
        return false
    }
    
}
