package bootstrap;

import js.html.EventListener;
import bootstrap.Button;
import thx.culture.Culture;
using Lambda;
using thx.core.Dates;
using thx.format.DateFormat;
using Detox;

class DatePicker extends dtx.widget.Widget
{
	public var pickerOpen(default,null) = false;
	public var currentView(default,set):DatePickerView;

	public var date(default,set):Date;

	/** Start day of week.  Sunday=0, Saturday=6 */
	public var startDOW:Weekday;

	/** Do we close the datepicker after a date has been selected? */
	public var closeOnSelect = true;

	private var viewDate(default,set):Date;
	private var dateBtns:Map<String, DOMNode>;

	public function new(?d:Date)
	{
		super();
		startDOW = Sunday;
		hidePicker();
		fillDOWHeaders();
		fillMonths();
		dateBtns = getDateButtons();
		currentView = Month;
		date = if (d!=null) d else Date.now();
		
		//
		// Set up open / close events
		//
		
		// Toggle on clicking the input field
		field.children().click(function (e) {
			if (pickerOpen) hidePicker() else showPicker();
		});

		// Close on click away
		Detox.document.click(function (e) {
			// If they click on any element not inside this dropdown widget, ie - they click outside
			var n:dtx.DOMNode = cast e.target;
			var ancestors = n.ancestors();
			if (ancestors.has(field) == false && ancestors.has(picker) == false)
			{
				hidePicker();
			}
		});

		// 
		// Set up the left / right events
		//

		nextMonth.click(function (e) viewDate = viewDate.jump(Month,1));
		prevMonth.click(function (e) viewDate = viewDate.jump(Month,-1));
		nextYear.click(function (e) viewDate = viewDate.jump(Year,1));
		prevYear.click(function (e) viewDate = viewDate.jump(Year,-1));
		nextDecade.click(function (e) viewDate = viewDate.jump(Year,10));
		prevDecade.click(function (e) viewDate = viewDate.jump(Year,-10));

		//
		// Set up the view changing events
		//

		monthTitle.click(function (e) currentView = Year);
		yearTitle.click(function (e) currentView = Decade);

		// Choose a new month
		monthCont.click(".month", function (e) {
			var n:DOMNode = cast e.target;
			var newMonth = n.index();
			viewDate = new Date(viewDate.getFullYear(), newMonth, viewDate.getDate(), viewDate.getHours(), viewDate.getMinutes(), viewDate.getSeconds());
			switchToDayPicker();
		});
		// Choose a new year
		yearCont.click(".year", function (e) {
			var n:DOMNode = cast e.target;
			var newYear = Std.parseInt(n.text());
			viewDate = new Date(newYear, viewDate.getMonth(), viewDate.getDate(), viewDate.getHours(), viewDate.getMinutes(), viewDate.getSeconds());
			switchToMonthPicker();
		});
		// When a date is selected
		monthView.click(".day", function (e) {
			var n:DOMNode = cast e.target;
			var newDayOfMonth = Std.parseInt(n.text());
			var newMonth = viewDate.getMonth();
			var newYear = viewDate.getFullYear();
			if (n.hasClass("old")) 
			{
				newMonth--;
				if (newMonth < 0) { newMonth = newMonth + 12; newYear--; }
			}
			if (n.hasClass("new")) 
			{
				newMonth++;
				if (newMonth > 11) { newMonth = newMonth - 12; newYear++; }
			}
			date = new Date(newYear, newMonth, newDayOfMonth, viewDate.getHours(), viewDate.getMinutes(), viewDate.getSeconds());
			if (closeOnSelect) hidePicker();
		});
	}

	public function showPicker()
	{
		var iPos = field.pos();

		var top = iPos.top + iPos.height; 
		var left = iPos.left;

		picker.setAttr("style", 'left: ${left}px; top: ${top}px; position: absolute; display: block;');
		pickerOpen = true;
	}

	public function hidePicker()
	{
		picker.setAttr("style", "");
		pickerOpen = false;
	}

	public function switchToYearPicker() { currentView = Decade; return this; }
	public function switchToMonthPicker() { currentView = Year; return this; }
	public function switchToDayPicker() { currentView = Month; return this; }

	function set_currentView(v)
	{
		dayPicker.setCSS("display", "");
		monthPicker.setCSS("display", "");
		yearPicker.setCSS("display", "");
		switch (v)
		{
			case Month: dayPicker.setCSS("display", "block");
			case Year: monthPicker.setCSS("display", "block");
			case Decade: yearPicker.setCSS("display", "block");
		}
		return currentView = v;
	}

	function set_date(v:Date)
	{
		date = v;

		// Update the input to show the new date
		input.setVal(formatDate(v));

		// Update the view too
		viewDate = v;

		input.change();

		return date;
	}

	public dynamic function formatDate(d:Date):String
	{
		return d.format("ddd") + " " + d.dateShort();
	}

	function set_viewDate(v:Date)
	{
		// Update titles
		var year = v.getFullYear();
		var startOfDecade = year - (year % 10);
		var endOfDecade = startOfDecade + 9;
		decadeTitle.setText('$startOfDecade - $endOfDecade');
		yearTitle.setText(v.format("yyyy"));
		monthTitle.setText(v.format("MMMM yyyy"));

		// Update Decade view
		fillYears(startOfDecade, endOfDecade);

		// Update Month view
		var daysInMonth = v.numDaysInThisMonth();
		var firstDayOfM = v.snapPrev(Month);
		var firstDayToDraw:Date = 
			if (firstDayOfM.getDay() == startDOW) 
				// go back one week, so we have a row full of last weeks options
				firstDayOfM.jump(Week,-1);
			else 
				// snap to the first Day Of Week, and let the snap function know that that happens to be the 1st DOW.
				Date.fromTime( firstDayOfM.getTime().snapPrevWeekDay(startDOW) );

		// Unhighlight previous ".active" for selected date
		monthView.find(".active").removeClass("active");

		// loop rows
		var c = firstDayToDraw;
		var vMonth = v.getFullYear()*12 + v.getMonth();
		for (w in 0...6)
		{
			// Loop days
			for (d in 0...7)
			{
				var td = dateBtns.get('$w,$d');
				td.setText(""+c.getDate());

				// If this month is ahead of 
				var cMonth = c.getFullYear()*12 + c.getMonth();
				if (cMonth < vMonth) td.addClass("old");
				else if (cMonth > vMonth) td.addClass("new");
				else td.removeClass("old new");

				// If this is the selected date, highlight it
				if (c.getFullYear() == date.getFullYear() && c.getMonth() == date.getMonth() && c.getDate() == date.getDate())
				{
					td.addClass("active");
				}

				c = c.nextDay();
			}
		}


		return viewDate = v;
	}



	//
	//
	//

	// fill the days of week headers
	function fillDOWHeaders()
	{
		var i:Int = startDOW;
		var names = Culture.invariant.dateTime.nameDaysAbbreviated;
		var days = new StringBuf();
		for (t in 0...7)
		{
			if (i > 6) i = 0;
			days.add('<th class="dow">${names[i]}</th>');
			i++;
		}
		dowCont.setInnerHTML(days.toString());
	}

	// fill the month picker
	function fillMonths()
	{
		var months = new StringBuf();
		for (m in Culture.invariant.dateTime.nameMonthsAbbreviated)
		{
			if (m != "") months.add('<span class="month">$m</span>');
		}
		monthCont.setInnerHTML(months.toString());
	}

	// fill the year picker with the current decade
	function fillYears(first, last)
	{
		var year = first - 1;
		for (link in yearCont.children())
		{
			link.setText('$year');
			if (year == date.getFullYear()) link.addClass("active") else link.removeClass("active");
			year++;
		}
	}
		
	// create 6 weeks, holding 7 days each
	// don't fill them in yet... that'll happen as viewDate is updated.
	function getDateButtons()
	{
		var dB = new Map<String, DOMNode>();
		for (w in 0...6)
		{
			var tr = "tr".create();
			for (d in 0...7)
			{
				var td = "td".create().addClass("day").appendTo(tr);
				dB.set('$w,$d', td);
			}
			tr.appendTo(this.monthView);
		}
		return dB;
	}

}

enum DatePickerView {
	Decade;
	Year;
	Month;
}