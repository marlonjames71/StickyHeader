//
//  ContentView.swift
//  Sticky Header
//
//  Created by Marlon Raskin on 8/23/20.
//

import SwiftUI

struct StickyHeaderView: View {
    var body: some View {
		ProfileInfoHeaderView(name: "Marlon Raskin")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StickyHeaderView()
    }
}



struct ProfileInfoHeaderView: View {

	let name: String

	var body: some View {
		HStack {
			Image("profilephoto")
				.resizable()
				.scaledToFill()
				.frame(width: 55, height: 55)
				.clipShape(Circle())
				.shadow(radius: 4)

			VStack(alignment: .leading) {
				Text("Article Written By")
					.font(.custom("Avenir Next", size: 12))
					.foregroundColor(.gray)

				Text(name)
					.font(.custom("Avenir Next", size: 17))
			}
		}
	}
}
