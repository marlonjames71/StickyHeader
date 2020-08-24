//
//  ContentView.swift
//  Sticky Header
//
//  Created by Marlon Raskin on 8/23/20.
//

import SwiftUI

struct StickyHeaderView: View {

	@Namespace var headerPhoto
	@Namespace var title

	private let imageHeight: CGFloat = 400
	private let collapsedImageHeight: CGFloat = 75

    var body: some View {
		ScrollView {
			GeometryReader { reader in
				Image("headerphoto")
					.resizable()
					.scaledToFill()
					.frame(width: reader.size.width, height: getHeightForHeaderImage(reader))
					.clipped()
					.offset(x: 0, y: getOffsetForHeaderImage(reader))
					.matchedGeometryEffect(id: "headerPhoto", in: headerPhoto)
			}.frame(height: 400)

			VStack(alignment: .leading, spacing: 10) {
				ProfileInfoHeaderView(name: "Marlon Raskin")

				Text("August 23, 2019 • 5 min read")
					.font(.avenirNextRegular(size: 12))
					.foregroundColor(.secondary)
				Text("How to build a parallax scroll view")
					.font(.avenirNext(size: 28))
					.matchedGeometryEffect(id: "title", in: title)

				Text(String.loremIpsum)
					.lineLimit(nil)
					.font(.avenirNextRegular(size: 17))
			}
			.padding(.horizontal)
			.padding(.vertical, 16)
		}
		.edgesIgnoringSafeArea(.all)
    }


	// MARK: - Offset Methods
	private func getScrollOffset(_ proxy: GeometryProxy) -> CGFloat {
		proxy.frame(in: .global).minY
	}

	private func getOffsetForHeaderImage(_ proxy: GeometryProxy) -> CGFloat {
		let offset = getScrollOffset(proxy)

		// Image was pulled down
		if offset > 0 {
			return -offset
		}

		return 0
	}

	private func getHeightForHeaderImage(_ proxy: GeometryProxy) -> CGFloat {
		let offset = getScrollOffset(proxy)
		let imageHeight = proxy.size.height

		if offset > 0 {
			return imageHeight + offset
		}

		return imageHeight
	}


	// MARK: - Image View Scroll Methods
	private func getBlurRadiusForImage(_ proxy: GeometryProxy) -> CGFloat {
		let offset = proxy.frame(in: .global).maxY
		let height = proxy.size.height
		let blur = (height - max(offset, 0)) / height

		return blur * 6
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		StickyHeaderView()
			.preferredColorScheme(.dark)
    }
}
