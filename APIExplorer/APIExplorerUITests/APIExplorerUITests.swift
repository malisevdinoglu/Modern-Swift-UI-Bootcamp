//
//  APIExplorerUITests.swift
//  APIExplorerUITests
//
//  Created by Mehmet Ali Sevdinoğlu on 25.09.2025.
//

import XCTest

final class APIExplorerUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testFavoriEklemeAkisi() throws {
        // 1) Liste yüklensin
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 8), "Liste yüklenmedi")

        // 2) İlk karaktere dokun → Detay açılmalı
        firstCell.tap()

        // 3) Detaydaki favori butonuna bas
        let favToggle = app.buttons["fav_toggle_button"]
        XCTAssertTrue(favToggle.waitForExistence(timeout: 5), "Detayda favori butonu yok")
        favToggle.tap()

        // 4) Geri dön
        app.navigationBars.buttons.element(boundBy: 0).tap()

        // 5) Toolbar’daki Favoriler’e git
        let openFavorites = app.buttons["open_favorites_button"]
        XCTAssertTrue(openFavorites.waitForExistence(timeout: 5), "Favoriler kısayolu bulunamadı")
        openFavorites.tap()

        // 6) Favoriler ekranında en az 1 satır olmalı
        let favCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(favCell.waitForExistence(timeout: 5), "Favoriler ekranı boş")
    }
}
