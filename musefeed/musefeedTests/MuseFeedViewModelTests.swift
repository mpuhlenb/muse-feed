//
//  MuseFeedViewModelTests.swift
//  musefeedTests
//
//  Created by Morris Uhlenbrauck on 1/13/24.
//

import XCTest
import Combine
@testable import musefeed

final class MuseFeedViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    let mockItems: [MuseItem] = [MuseItem(), MuseItem()]
    var viewModel = MuseFeedViewModel(selectedOptions: [.artInstitute, .rijks])
    let mockSession = MockSession()
    
    func testFirstFeedItemsCanBeSubscribed() {
        
        let expectation = XCTestExpectation(description: "2 items added to first feed")
        var expectedItems: [MuseItem] = []
        
        viewModel.$firstFeedItems.dropFirst().sink { items in
            XCTAssertEqual(items.count, 2)
            expectedItems.append(contentsOf: items)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.firstFeedItems.append(contentsOf: mockItems)
        XCTAssertEqual(expectedItems.count, 2)
        wait(for: [expectation], timeout: 1)
    }
    
    func testSecondFeedItemsCanBeSubscribed() {
        let expectation = XCTestExpectation(description: "2 items added to second feed")
        var expectedItems: [MuseItem] = []
        viewModel.$secondFeedItems.dropFirst().sink { items in
            XCTAssertEqual(items.count, 2)
            expectedItems.append(contentsOf: items)
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.secondFeedItems.append(contentsOf: mockItems)
        XCTAssertEqual(expectedItems.count, 2)
        wait(for: [expectation], timeout: 1)
    }

    func testFirstFeedIsRefreshingCanBeSubscribed() {
        XCTAssertEqual(viewModel.firstFeedIsRefreshing, false)
        let expectation = XCTestExpectation(description: "First feed refreshing is true")
        var expectedIsRefreshing: Bool = false

        viewModel.$firstFeedIsRefreshing.dropFirst().sink { isRefreshing in
            XCTAssertEqual(isRefreshing, true)
            expectedIsRefreshing = isRefreshing
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.firstFeedIsRefreshing = true
        
        XCTAssertEqual(expectedIsRefreshing, true)
        wait(for: [expectation], timeout: 1)
    }
    
    func testSecondFeedIsRefreshingCanBeSubsribed() {
        XCTAssertEqual(viewModel.secondFeedIsRefreshing, false)
        let expectation = XCTestExpectation(description: "Second feed refreshing is true")
        var expectedIsRefreshing: Bool = false
        viewModel.$secondFeedIsRefreshing.dropFirst().sink { isRefreshing in
            XCTAssertEqual(isRefreshing, true)
            expectedIsRefreshing = isRefreshing
            expectation.fulfill()
        }.store(in: &cancellables)
        
        viewModel.secondFeedIsRefreshing = true
        
        XCTAssertEqual(expectedIsRefreshing, true)
        wait(for: [expectation], timeout: 1)
    }
    
    func testSetItemsForRijks() async {
        viewModel = MuseFeedViewModel(selectedOptions: [.rijks, .artInstitute], session: mockSession)
        let item = RijksArtObject(id: "", title: "", objectNumber: "", principalOrFirstMaker: "", hasImage: true, webImage: RijksWebImage(guid: "", width: 0, height: 0, url: ""))
        let objects = RijksArtObjects(artObjects: [item, item])
        do {
            mockSession.results = try [.success(JSONEncoder().encode(objects))]
        } catch {}
        await viewModel.setItemsFor(feedOption: .rijks, in: .firstFeed)
        
        XCTAssertEqual(viewModel.firstFeedItems.count, 2)
    }
    
    func testSetItemsForChicago() async {
        viewModel = MuseFeedViewModel(selectedOptions: [.artInstitute, .nymet], session: mockSession)
        let mockItem = ArtInstituteArtwork(id: 0, title: "", artist: "", description: "")
        let mockConfig = ArtInstituteImageConfig(imageBaseUrl: "")
        let mockItems = ArtInstituteArtworks(data: [mockItem, mockItem], config: mockConfig)
        do {
            mockSession.results = try [.success(JSONEncoder().encode(mockItems))]
        } catch {}
        
        await viewModel.setItemsFor(feedOption: .artInstitute, in: .secondFeed)
        XCTAssertEqual(viewModel.secondFeedItems.count, 2)
    }
    
    func testSetItemsForNYMet() async {
        viewModel = MuseFeedViewModel(selectedOptions: [.artInstitute, .nymet], session: mockSession)
        let mockItem = NYMetObject(objectID: 100, title: "", artistDisplayName: "", primaryImage: "testUrl", additionalImages: [], primaryImageSmall: "")
        let mockIds = NYMetObjectIds(objectIDs: [100])
        do {
            mockSession.results = try [.success(JSONEncoder().encode(mockIds)), .success(JSONEncoder().encode(mockItem))]
        } catch {}
        
        await viewModel.setItemsFor(feedOption: .nymet, in: .secondFeed)
        XCTAssertEqual(viewModel.secondFeedItems.count, 1)
        guard let item = viewModel.secondFeedItems.first else { return XCTFail("Failed to set item") }
        XCTAssertEqual(item.id, "100")
    }
    
    func testRefreshItems() async {
        viewModel = MuseFeedViewModel(selectedOptions: [.rijks, .artInstitute], session: mockSession)
        let item = RijksArtObject(id: "", title: "", objectNumber: "", principalOrFirstMaker: "", hasImage: true, webImage: RijksWebImage(guid: "", width: 0, height: 0, url: ""))
        let objects = RijksArtObjects(artObjects: [item, item])
        let refreshObjects = RijksArtObjects(artObjects: [item, item, item, item])
        let expectation = XCTestExpectation(description: "Items refreshed")
        do {
            mockSession.results = try [.success(JSONEncoder().encode(objects)),
                                       .success(JSONEncoder().encode(refreshObjects))]
        } catch {}
        
        await viewModel.setItemsFor(feedOption: .rijks, in: .firstFeed)
        
        XCTAssertEqual(viewModel.firstFeedItems.count, 2)
        
        viewModel.$firstFeedIsRefreshing.dropFirst().sink { isRefreshing in
            if !isRefreshing {
                expectation.fulfill()
            }
        }.store(in: &cancellables)
        
        await viewModel.refreshItems(in: .firstFeed, feedOption: .rijks)
        await fulfillment(of: [expectation])
        
        XCTAssertEqual(viewModel.firstFeedItems.count, 4)
    }
}
