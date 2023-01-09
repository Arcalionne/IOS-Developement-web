//
//  AboutView.swift
//  Event_Efrei
//
//  Created by CGalbon on 07/01/2023.
//

import SwiftUI
import MapKit

//Pour mettre un pin sur la carte
struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct AboutView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.87721465007979, longitude: 2.306851040617959), span: MKCoordinateSpan(latitudeDelta: 0.01250, longitudeDelta: 0.0125))
    private let place: IdentifiablePlace = IdentifiablePlace(id:UUID(), lat:48.87721465007979, long:2.306851040617959)
    
    var body: some View {
        ScrollView(){
            VStack(alignment: .leading){
                Text("General information").frame(maxWidth: .infinity).font(.title).fontWeight(.bold).foregroundColor(.white).background(Color(red:0.51, green:0.22, blue:0.93))
                Text("The event will take place from February 8th, to February 9th 2023 @ Hôtel du Collectioneur in Paris !\n Tickets have already been sent to participants.\nIf you encounter any problem, send us a mail to contact@corporatemeeting.com").multilineTextAlignment(.leading)
                    .lineLimit(nil)
                
                Spacer()
                Text("Directions").frame(maxWidth: .infinity).font(.title).foregroundColor(.white).fontWeight(.bold).background(Color(red:0.51, green:0.22, blue:0.93))
                VStack(alignment: .leading){ Group(){
                    Text("Hôtel du Collectionneur ").fontWeight(.bold)
                    Text("📍 51/57 rue de Courcelles 75008 Paris, France")
                    Text("Ⓜ️ Metro Line 2 — Courcelles")
                    Text("Ⓜ️ Metro Line 1 — Georges V")
                    Text("🚌 Bus 84 - Murillo")
                    Text("🚆 30 minutes drive from any train station")
                    Text("🛫 30 minutes drive from Roissy or Orly airport")
                    Map(coordinateRegion: $region,annotationItems: [place]){place in
                        MapMarker(coordinate:place.location, tint:Color.purple)
                    }
                    .frame(width: 400, height: 300)
                }}.frame(minWidth:0, maxWidth: .infinity)
                Spacer()
                VStack(alignment: .leading){
                    Group{
                        Text("About the app").frame(maxWidth: .infinity).font(.title).fontWeight(.bold).foregroundColor(.white).background(Color(red:0.51, green:0.22, blue:0.93))
                        Text("Version: 1.0.0")
                        HStack(){
                            Image(systemName:"envelope.fill")
                            Text("contact@corporatemeeting.com")}
                        HStack()
                        {
                            Image(systemName: "phone.fill")
                            Text("066-666-666")
                        }
                        Text("Developers").frame(maxWidth: .infinity).font(.title).fontWeight(.bold).foregroundColor(.white).background(Color(red:0.51, green:0.22, blue:0.93))
                        VStack(alignment: .leading){
                            Text("🙋🏽‍♀️Camille GALBON <camille.galbon@efrei.net>")
                            Text("🙋🏾‍♂️Moubarak FADILI <moubarak.fadili@efrei.net>")
                        }
                    }
                }.frame(minWidth:0, maxWidth: .infinity)
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
