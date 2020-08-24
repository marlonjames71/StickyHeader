//
//  ProfileInfoHeaderView.swift
//  Sticky Header
//
//  Created by Marlon Raskin on 8/23/20.
//

import SwiftUI

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
					.font(.avenirNext(size: 12))
					.foregroundColor(.gray)

				Text(name)
					.font(.avenirNext(size: 17))
			}
		}
	}
}

struct ProfileInfoHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoHeaderView(name: "name")
    }
}
