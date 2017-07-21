import Foundation

extension Date {
	
	public static func ==(lhs: Date, rhs: Date) -> Bool {
		if lhs.day == rhs.day && lhs.month == rhs.month && lhs.year == rhs.year {
			// 年月日一樣即相等
			return true
		}
		return false
	}
	
}

extension Date {
	public static func calendarStartDate() -> Date {
		return Date.create(dateOnYear: 2010, month: 1, day: 1)!
	}
	
	public static func calendarEndDate() -> Date {
		return Date.create(dateOnYear: 2030, month: 12, day: 31)!
	}
	
	public func daysToDate(_ date: Date) -> Int {
		let seconds = self.timeIntervalSince(date)
		let secondsPerDay: TimeInterval = 86400
		// 60 * 60 * 24 seconds per day = 86400
		return Int(ceil(seconds / secondsPerDay))
	}
	
	public static func get50000DaysStartingFrom1970() -> [Date] {
		var dates = [Date]()
		guard let baseDate = Date.create(dateOnYear: 1970, month: 1, day: 1) else { return [] }
		for days in 0...49999 {
			if let date = baseDate.dateByAddingDay(days) {
				dates.append(date)
			}
		}
		return dates
	}

	public var rruleFormatString: String {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.string(from: self)
	}
	
	public static func dateFromRRuleString(_ rruleString: String) -> Date? {
		let formatter = DateFormatter()
		formatter.timeZone = TimeZone(abbreviation: "UTC")
		formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
		return formatter.date(from: rruleString)
	}
	
	public func isBefore(_ date: Date) -> Bool {
		return compare(date) == .orderedAscending
	}
	
	public func isSame(with date: Date) -> Bool {
		return compare(date) == .orderedSame
	}
	
	public func isSameDay(with date: Date) -> Bool {
		return year == date.year && month == date.month && day == date.day
	}
	
	public func isAfter(_ date: Date) -> Bool {
		return compare(date) == .orderedDescending
	}
	
	public func isAfterOrSame(with date: Date) -> Bool {
		return isSame(with: date) || isAfter(date)
	}
	
	public func isBeforeOrSame(with date: Date) -> Bool {
		return isSame(with: date) || isBefore(date)
	}
	
	public func isBetween(date a: Date, and b: Date) -> Bool {
		let from = a.isBefore(b) ? a : b
		let to = b.isAfterOrSame(with: a) ? b : a
		return self.isAfterOrSame(with: from) && self.isBeforeOrSame(with: to)
	}

	public var iso8601String: String {
		let formatter = DateFormatter()
		let currentLocale = Locale.current
		formatter.locale = currentLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		return formatter.string(from: self)
	}
	
	public static func dateFrom(iso8601 iso8601String: String?) -> Date? {
		guard let iso8601String = iso8601String else { return nil }
		let formatter = DateFormatter()
		let currentLocale = Locale.current
		formatter.locale = currentLocale
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
		return formatter.date(from: iso8601String)
	}

	public func isEqual(_ object: Any?) -> Bool {
		if let date = object as? Date {
			if date.day == self.day && date.month == self.month && date.year == self.year {
				// 年月日一樣即相等
				return true
			}
		}
		return false
	}
	
	/// Creating a specific date.
	///
	/// year, month, day is required, and must larger than 0. If not, will fail to create.
	///
	/// Creating date like 1970 10 32 0 0 0, will create date like 1970 11 2 0 0 0
	///
	/// **You should not pass in 0 to year, month, day.**
	static func create(dateOnYear year: Int, month: Int, day: Int) -> Date? {
		return create(dateOnYear: year, month: month, day: day, hour: 0, minute: 0, second: 0)
	}
	
	/// Creating a specific date.
	///
	/// year, month, day is required, and must larger than 0. If not, will fail to create.
	///
	/// Creating date like 1970 10 32 0 0 0, will create date like 1970 11 2 0 0 0
	///
	/// **You should not pass in 0 to year, month, day.**
	static func create(dateOnYear year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
		
		guard year > 0 else { return nil }
		guard month > 0 else { return nil }
		guard day > 0 else { return nil }
		
		var components = DateComponents()
		components.year = year
		components.month = month
		components.day = day
		components.hour = hour
		components.minute = minute
		components.second = second
		return Calendar.current.date(from: components)
	}
	
	/// Create a max date of calendar.
	///
	/// Value is 2030/12/31 23:59:59
	static func createMaxDate() -> Date {
		return Date.create(dateOnYear: 2030, month: 12, day: 31, hour: 23, minute: 59, second: 59)!
	}
	
	var daysInItsMonth: Int {
		return (Calendar.current as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: self).length
	}
	
	var tomorrow: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		guard component.day != nil else { return nil }
		component.day! += 1
		return Calendar.current.date(from: component)
	}
	
	var yesterday: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		guard component.day != nil else { return nil }
		component.day! -= 1
		return Calendar.current.date(from: component)
	}
	
	var beginingDateOfItsMonth: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		component.day = 1
		return Calendar.current.date(from: component)
	}
	
	var endDateOfItsMonth: Date? {
		var component = (Calendar.current as NSCalendar).components([.year, .month, .day, .hour], from: self)
		guard component.month != nil else { return nil }
		component.month! += 1
		component.day = 0
		return Calendar.current.date(from: component)
	}
	
	var year: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: self).year!
	}
  
  var yearOfRepublicEra: Int {
    return year - 1911
  }
	
	var month: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: self).month!
	}
	
	var day: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: self).day!
	}
	
	var hour: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: self).hour!
	}
	
	var minute: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: self).minute!
	}
	
	var second: Int {
		return (Calendar.current as NSCalendar).components(NSCalendar.Unit.second, from: self).second!
	}
	
	func dateByAddingYear(_ year: Int) -> Date? {
		var components = DateComponents()
		components.year = year
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingYear(_ year: Int) -> Date? {
		return self.dateByAddingYear(-year)
	}
	
	func dateByAddingMonth(_ month: Int) -> Date? {
		var components = DateComponents()
		components.month = month
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingMonth(_ month: Int) -> Date? {
		return self.dateByAddingMonth(-month)
	}
	
	func dateByAddingWeek(_ week: Int) -> Date? {
		var components = DateComponents()
		components.weekOfYear = week
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingWeek(_ week: Int) -> Date? {
		return self.dateByAddingWeek(-week)
	}
	
	func dateByAddingDay(_ day: Int) -> Date? {
		var components = DateComponents()
		components.day = day
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingDay(_ day: Int) -> Date? {
		return self.dateByAddingDay(-day)
	}
	
	func dateByAddingHour(_ hour: Int) -> Date? {
		var components = DateComponents()
		components.hour = hour
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingHour(_ hour: Int) -> Date? {
		return self.dateByAddingHour(-hour)
	}
	
	func dateByAddingMinute(_ minute: Int) -> Date? {
		var components = DateComponents()
		components.minute = minute
		return (Calendar.current as NSCalendar).date(byAdding: components, to: self, options: [])
	}
	
	func dateBySubtractingMinute(_ minute: Int) -> Date? {
		return self.dateByAddingMinute(-minute)
	}
}
