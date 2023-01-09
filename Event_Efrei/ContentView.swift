//
//  ContentView.swift
//  Event_Efrei
//
//  Created by CGalbon on 17/12/2022.
//

//TODO

//Creer la page du schedule avec le schedule du jour 1
// Creer une vue avec les details d'une conf
// 

import SwiftUI
let a = ScheduleApiCall()

struct ContentView: View {
    var body: some View {

        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            ScheduleView().tabItem {
                Image(systemName: "list.dash")
                Text("Schedule") }.tag(1)
            SpeakersView().tabItem {
                Image(systemName: "person.fill")
                Text("Speakers") }.tag(2)
            AboutView().tabItem{
                Image(systemName: "info.circle.fill")
                Text("About").tag(3)
            }
        }.onAppear {
            UITabBar.appearance().barTintColor = UIColor(red:0.51, green:0.22, blue:0.93, alpha:1.0)
        }.tint(.white)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
