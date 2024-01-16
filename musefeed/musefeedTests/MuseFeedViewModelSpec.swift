//
//  MuseFeedViewModelSpec.swift
//  musefeedTests
//
//  Created by Morris Uhlenbrauck on 1/14/24.
//

import Quick
import Nimble
import Combine
@testable import musefeed
import Foundation

class MuseFeedViewModelSpec: AsyncSpec {
    override class func spec() {
        var cancellables = Set<AnyCancellable>()
        var mockSession: MockSession!
        var viewModel: MuseFeedViewModel!
        
        beforeEach {
            mockSession = MockSession()
            viewModel = MuseFeedViewModel(selectedOptions: [.rijks, .artInstitute], session: mockSession)
        }
        
        describe("Subscribe") {
            context("First Feed Items") {
                it("Should update subscribed item") {
                    var expectedItems: [MuseItem] = []
                    let rijksItem = RijksArtObject(id: "", title: "", objectNumber: "", principalOrFirstMaker: "", hasImage: true, webImage: RijksWebImage(guid: "", width: 0, height: 0, url: ""))
                    let rijksObjects = RijksArtObjects(artObjects: [rijksItem, rijksItem])
                    let museItem = MuseItem(id: "", title: "", detailId: "", maker: "", feed: .rijks)
                    
                    viewModel.$firstFeedItems.dropFirst().sink { items in
                        expect(items.count).to(equal(2))
                        expectedItems.append(contentsOf: items)
                    }.store(in: &cancellables)
                    
                    do {
                        mockSession.results = try [.success(JSONEncoder().encode(rijksObjects))]
                    } catch {}
                    
                    await viewModel.setItemsFor(feedOption: .rijks, in: .firstFeed)
                    expect(expectedItems.count).to(equal(2))
                }
            }
            
            context("Second Feed Items") {
                it("Should update subscribed item") {
                    let artItem = ArtInstituteArtwork(id: 100, title: "", artist: "", description: nil)
                    let artConfig = ArtInstituteImageConfig(imageBaseUrl: "")
                    let artItems = ArtInstituteArtworks(data: [artItem, artItem, artItem], config: artConfig)
                    var expectedItems: [MuseItem] = []
                    viewModel.$secondFeedItems.dropFirst().sink { items in
                        expectedItems.append(contentsOf: items)
                        expect(items.count).to(equal(3))
                    }.store(in: &cancellables)
                    
                    do {
                        mockSession.results = try [.success(JSONEncoder().encode(artItems))]
                    } catch {}
                    
                    await viewModel.setItemsFor(feedOption: .artInstitute, in: .secondFeed)
                    expect(expectedItems.count).to(equal(3))
                }
            }
            
            context("Refresh feed") {
                it("Should update subscribed feed item") {
                    let item = RijksArtObject(id: "", title: "", objectNumber: "", principalOrFirstMaker: "", hasImage: true, webImage: RijksWebImage(guid: "", width: 0, height: 0, url: ""))
                    let objects = RijksArtObjects(artObjects: [item, item])
                    let refreshObjects = RijksArtObjects(artObjects: [item, item, item, item])
                    do {
                        mockSession.results = try [.success(JSONEncoder().encode(objects)),
                                                   .success(JSONEncoder().encode(refreshObjects))]
                    } catch {}
                    
                    await viewModel.setItemsFor(feedOption: .rijks, in: .firstFeed)
                    expect(viewModel.firstFeedItems.count).to(equal(2))

                    
                    await viewModel.refreshItems(in: .firstFeed, feedOption: .rijks)
                    await expect(viewModel.firstFeedItems.count).toEventually(equal(4))
                }
            }
        }
    }
}
