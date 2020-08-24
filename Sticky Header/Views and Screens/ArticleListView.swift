//
//  ArticleListView.swift
//  Sticky Header
//
//  Created by Marlon Raskin on 8/23/20.
//

import SwiftUI

struct ArticleListView: View {

	@State private var showStickyHeaderView: Bool = false

    var body: some View {
		ScrollView(.vertical, showsIndicators: true, content: {
			VStack {
				ForEach(0..<15) { _ in
					ArticleCell()
						.onTapGesture(perform: {
							showStickyHeaderView = true
						})
						.sheet(isPresented: $showStickyHeaderView, content: {
							StickyHeaderView()
						})
				}
			}
		})
    }
}




struct ArticleListView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleListView()
    }
}
