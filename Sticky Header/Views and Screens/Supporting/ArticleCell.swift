//
//  ArticleCell.swift
//  Sticky Header
//
//  Created by Marlon Raskin on 8/23/20.
//

import SwiftUI

struct ArticleCell: View {

	var body: some View {
		GeometryReader { reader in
			ZStack(alignment: .bottom) {
				Image("headerphoto")
					.resizable()
					.scaledToFill()
					.frame(width: reader.size.width - 32, height: 200, alignment: .center)
					.clipped()
					.cornerRadius(16)

				HStack {
					Text("How to build a parallax scroll view")
						.foregroundColor(.white)
						.font(.avenirNextRegular(size: 17))
						.padding(.vertical, 4)
						.padding(.horizontal, 6)
						.background(Color.black.opacity(0.6))
						.clipShape(Capsule())
					Spacer()
				}
				.padding(.horizontal, 20)
				.padding(.bottom, 5)
			}
		}
		.frame(height: 200)
	}
}

struct ArticleCell_Previews: PreviewProvider {
	static var previews: some View {
		ArticleCell()
	}
}
