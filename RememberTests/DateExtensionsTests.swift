//
//  DateExtensionsTests.swift
//  RememberTests
//
//  Created by Jan Huber on 17.10.22.
//

import XCTest

@testable
import Remember

class DateExtensionsTests: XCTestCase {

    var subject: Date!

    override func setUp() {
        subject = Date(day: 5, month: 10, year: 2021)
    }

    override func tearDown() {
        subject = nil
    }

    func testDateCanBeInitializedWithISO8601Format() {
        let date = Date(rawValue: "1994-01-31T02:22:40Z")!
        XCTAssert(date.year() == 1994)
    }

    func testDateCanBeFormatedAsISO8601() {
        print(subject.rawValue)
        XCTAssert(subject.rawValue == "2021-10-04T22:00:00Z")
    }

    func testTimeIntervalInDaysCalculatedCorrectly() {
        let intervalDays = subject.timeIntervalInDays(to: Date(day: 10, month: 10, year: 2021))
        XCTAssert(intervalDays == 5)
    }

    func testTimeIntervalInDaysCalculatedCorrectlyWhenTheComparisonDateIsBeforeTheCurrentDateInstance() {
        let intervalDays = subject.timeIntervalInDays(to: Date(day: 1, month: 10, year: 2021))
        XCTAssert(intervalDays == 4)
    }

    func testFirstDayOfYearIsCorrect() {
        let date = Date.firstDayOfYear(year: 2023)

        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)

        XCTAssert(components.year == 2023)
        XCTAssert(components.month == 1)
        XCTAssert(components.day == 1)

    }

    func testLastDayOfYearIsCorrect() {
        let date = Date.lastDayOfYear(year: 2024)
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)

        XCTAssert(components.year == 2024)
        XCTAssert(components.month == 12)
        XCTAssert(components.day == 31)
    }

    func testYearCanBeExtractedFromDate() {
        subject = Date(day: 5, month: 10, year: 1999)
        XCTAssert(subject.year() == 1999)
    }

    func testYearCanBeChanged() {
        subject = Date(day: 5, month: 10, year: 1999)
        subject.changeYear(to: 2023)
        XCTAssert(subject.year() == 2023)
    }

    func testIsInLessThanAYearIsCorrectForTwoDatesThatDifferByMoreThanAYear() {
        let firstDate = Date(day: 5, month: 2, year: 2022)
        let secondDate = Date(day: 5, month: 12, year: 2023)
        XCTAssert(!firstDate.isInLessThanAYear(after: secondDate))
    }

    func testIsInLessThanAYearIsCorrectForTwoDatesThatDifferByLessThanAYear() {
        let firstDate = Date(day: 5, month: 12, year: 2022)
        let secondDate = Date(day: 5, month: 2, year: 2022)
        XCTAssert(firstDate.isInLessThanAYear(after: secondDate))
    }

    func testIsInLessThanAYearIsCorrectForTwoDatesThatDifferByExactlyYear() {
        let firstDate = Date(day: 5, month: 2, year: 2023)
        let secondDate = Date(day: 5, month: 2, year: 2022)
        XCTAssert(!firstDate.isInLessThanAYear(after: secondDate))
    }

    func testIsInLessThanAYearIsFalseIfTheSecondDateIsAfterTheFirstDate() {
        let firstDate = Date(day: 5, month: 1, year: 2022)
        let secondDate = Date(day: 5, month: 2, year: 2022)
        XCTAssert(!firstDate.isInLessThanAYear(after: secondDate))
    }
}
