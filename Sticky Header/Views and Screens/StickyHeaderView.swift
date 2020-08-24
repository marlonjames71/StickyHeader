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

	@ObservedObject private var articleContent: ViewFrame = ViewFrame()

	@State private var titleRect: CGRect = .zero
	@State private var headerImageRect: CGRect = .zero

	private let imageHeight: CGFloat = 400
	private let collapsedImageHeight: CGFloat = 75

    var body: some View {
		ScrollView {
			VStack {
				VStack(alignment: .leading, spacing: 10) {
					ProfileInfoHeaderView(name: "Marlon Raskin")

					Text("August 23, 2019 • 5 min read")
						.font(.avenirNextRegular(size: 12))
						.foregroundColor(.secondary)
					Text("How to build a parallax scroll view")
						.font(.avenirNext(size: 28))
						.background(GeometryGetter(rect: $titleRect))

					Text(String.loremIpsum)
						.lineLimit(nil)
						.font(.avenirNextRegular(size: 17))
				}
				.padding(.horizontal)
				.padding(.vertical, 16)
			}
			.offset(y: imageHeight + 16)
			.background(GeometryGetter(rect: $articleContent.frame))

			
			GeometryReader { proxy in
				ZStack(alignment: .bottom) {
					Image("headerphoto")
						.resizable()
						.scaledToFill()
						.frame(width: proxy.size.width, height: getHeightForHeaderImage(proxy))
						.blur(radius: getBlurRadiusForImage(proxy))
						.clipped()
						.background(GeometryGetter(rect: $headerImageRect))

					Text("How to build a parallax scroll view")
						.font(.avenirNext(size: 17))
						.foregroundColor(.white)
						.offset(x: 0, y: getHeaderTitleOffset())
				}
				.clipped()
				.offset(x: 0, y: getOffsetForHeaderImage(proxy))
			}
			.frame(height: imageHeight)
			.offset(x: 0, y: -(articleContent.startingRect?.maxY ?? UIScreen.main.bounds.height))
		}
		.edgesIgnoringSafeArea(.all)
    }


	// MARK: - Offset Methods
	private func getScrollOffset(_ proxy: GeometryProxy) -> CGFloat {
		proxy.frame(in: .global).minY
	}

	private func getOffsetForHeaderImage(_ proxy: GeometryProxy) -> CGFloat {
		let offset = getScrollOffset(proxy)
		let sizeOffScreen = imageHeight - collapsedImageHeight

		// if our offset is roughly less than -325 (the amount scrolled / amount off screen)
		if offset < -sizeOffScreen {
			// Since we want 75 px fixed on the screen, we get our offset of -325 or anything less
			// than that. Take the abs value of
			let imageOffset = abs(min(-sizeOffScreen, offset))

			// Now we have the amount of offset above our size off screen. So if we've scrolled
			// -325px our size  offscreen is -325px - we offset our image by an additional 25 px
			// to put it back at the amount needed to remain offscreen/amount on screen.
			return imageOffset - sizeOffScreen
		}

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

	private func getHeaderTitleOffset() -> CGFloat {
		let currentYPos = titleRect.midY

		// (x - min) / (max - min) -> Normalize our values between 0 and 1

		// If our Title has surpassed the bottom of our image at the top
		// Current Y POS will start at 75 in the beginning. We essentially only want to offset
		// our 'Title' about 30px.
		if currentYPos < headerImageRect.maxY {
			let minYValue: CGFloat = 50.0 // What we consider our min for our scroll offset
			let maxYValue: CGFloat = collapsedImageHeight // WHat we start at for our scroll offset (75)
			let currentYValue = currentYPos

			// Normalize our values from 75 - 50 to be between 0 to -1. If scrolled past that,
			// just default to -1
			let percentage = max(-1, (currentYValue - maxYValue) / (maxYValue - minYValue))
			// We want our final offset to be -30 from the bottom of the image headerview
			let finalOffset: CGFloat = -30.0

			// We will start at 20 pixels from the bottom (under our sticky header)
			// At the beginning, our percentage will be 0, with this resulting in 20 - (x * -30)
			// As x increases, our offset will go from 20 to 0 to -30, thus translating our title from 20px to -30px

			return 20 - (percentage * finalOffset)
		}

		return .infinity
	}


	// MARK: - Image View Scroll Methods
	// at 0 offset our blur will be 0
	// at 300 offset our blur will be 6
	private func getBlurRadiusForImage(_ proxy: GeometryProxy) -> CGFloat {
		let offset = proxy.frame(in: .global).maxY
		let height = proxy.size.height
		let blur = (height - max(offset, 0)) / height // (values will range from 0 - 1)

		return blur * 6 // Values will range from 0 - 6
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
		GeometryReader { reader in
			AnyView(Color.clear)
				.preference(key: RectanglePreferenceKey.self, value: reader.frame(in: .global))
		}
		.onPreferenceChange(RectanglePreferenceKey.self) { value in
			self.rect = value
		}
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
