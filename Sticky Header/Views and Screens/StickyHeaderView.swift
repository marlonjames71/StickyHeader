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

	@ObservedObject private var content: ViewFrame = ViewFrame()
	@State private var titleRect: CGRect = .zero
	@State private var headerImageRect: CGRect = .zero
	@State private var showSmallHeaderTitle: Bool = false

    var body: some View {
		ScrollView {
			GeometryReader { proxy in
				ZStack(alignment: .bottom) {
					Image("headerphoto")
						.resizable()
						.scaledToFill()
						.frame(width: proxy.size.width, height: getHeightForHeaderImage(proxy))
						.blur(radius: getBlurRadiusForImage(proxy))
						.clipped()
						.background(GeometryGetter(rect: $headerImageRect))
						.matchedGeometryEffect(id: "headerPhoto", in: headerPhoto)

					Text("How to build a parallax scroll view")
						.font(.avenirNext(size: 17))
						.foregroundColor(.white)
						.offset(x: 0, y: getHeaderTitleOffset())
//						.opacity(showSmallHeaderTitle ? 1 : 0)
				}
				.clipped()
				.offset(x: 0, y: getOffsetForHeaderImage(proxy))
			}
			.frame(height: 400)
			.zIndex(1)

			VStack(alignment: .leading, spacing: 10) {
				ProfileInfoHeaderView(name: "Marlon Raskin")

				Text("August 23, 2019 • 5 min read")
					.font(.avenirNextRegular(size: 12))
					.foregroundColor(.secondary)
				Text("How to build a parallax scroll view")
					.font(.avenirNext(size: 28))
					.background(GeometryGetter(rect: $headerImageRect))
					.matchedGeometryEffect(id: "title", in: title)

				Text(String.loremIpsum)
					.lineLimit(nil)
					.font(.avenirNextRegular(size: 17))
			}
			.background(GeometryGetter(rect: $content.frame))
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
		let sizeOffscreen = imageHeight - collapsedImageHeight

		if offset < -sizeOffscreen {
			let imageOffset = abs(min(-sizeOffscreen, offset))
//			showSmallHeaderTitle = true
			return imageOffset - sizeOffscreen
		}

		// Image was pulled down
		if offset > 0 {
			return -offset
		}

//		showSmallHeaderTitle = false
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

	private func getHeaderTitleOffset() -> CGFloat {
		let currentYPos = titleRect.maxY

		if currentYPos < headerImageRect.maxY {
			let minYValue: CGFloat = 50.0
			let maxYValue: CGFloat = collapsedImageHeight
			let currentYValue = currentYPos

			let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue))
			let finalOffset: CGFloat = -30.0

//			showSmallHeaderTitle = true
			return 20 - (percentage * finalOffset)
		}

//		showSmallHeaderTitle = false
		return .infinity
	}


	// MARK: - Image View Scroll Methods
	private func getBlurRadiusForImage(_ proxy: GeometryProxy) -> CGFloat {
		let offset = proxy.frame(in: .global).maxY
		let height = proxy.size.height
		let blur = (height - max(offset, 0)) / height

		return blur * 6
	}
}


class ViewFrame: ObservableObject {
	var startingRect: CGRect?

	@Published var frame: CGRect {
		willSet {
			if startingRect == nil {
				startingRect = newValue
			}
		}
	}

	init() {
		self.frame = .zero
	}
}

struct GeometryGetter: View {
	@Binding var rect: CGRect

	var body: some View {
		GeometryReader { proxy in
			AnyView(Color.clear)
				.preference(key: RectanglePreferenceKey.self, value: proxy.frame(in: .global))
		}
		.onPreferenceChange(RectanglePreferenceKey.self, perform: { value in
			rect = value
		})
	}
}

struct RectanglePreferenceKey: PreferenceKey {
	static var defaultValue: CGRect = .zero

	static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
		value = nextValue()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		StickyHeaderView()
			.preferredColorScheme(.dark)
    }
}
