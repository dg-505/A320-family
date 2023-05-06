var latRev = {
	title: [nil, nil, nil],
	titleColour: "wht",
	subtitle: [nil, nil],
	arrowsMatrix: [[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0]],
	arrowsColour: [["ack", "ack", "ack", "ack", "ack", "ack"],["ack", "ack", "ack", "ack", "ack", "ack"]],
	L1: [nil, nil, "ack"], # content, title, colour
	L2: [nil, nil, "ack"],
	L3: [nil, nil, "ack"],
	L4: [nil, nil, "ack"],
	L5: [nil, nil, "ack"],
	L6: [nil, nil, "ack"],
	R1: [nil, nil, "ack"],
	R2: [nil, nil, "ack"],
	R3: [nil, nil, "ack"],
	R4: [nil, nil, "ack"],
	R5: [nil, nil, "ack"],
	R6: [nil, nil, "ack"],
	depAirport: nil,
	arrAirport: nil,
	index: nil,
	computer: nil,
	new: func(type, wpt, index, computer) {
		var lr = {parents:[latRev]};
		lr.type = type; # 0 = origin 1 = destination 2 = ppos (from waypoint) 3 = generic wpt, 4 = discon
		lr.wpt = wpt;
		lr.index = index;
		lr.computer = computer;
		lr._setupPageWithData();
		lr._checkTmpy();
		return lr;
	},
	del: func() {
		return nil;
	},
	_checkTmpy: func() {
		if (fmgc.flightPlanController.temporaryFlag[me.computer]) {
			me.L6 = [" F-PLN", " TMPY", "yel"];
			me.titleColour = "yel";
			me.arrowsColour[0][5] = "yel";
			me.R2[2] = "yel";
			me.R3[2] = "yel";
			me.R4[2] = "yel";
			canvas_mcdu.pageSwitch[me.computer].setBoolValue(0);
		}
	},
	_setupPageWithData: func() {
		if (me.type == 2) { 
			me.title = ["LAT REV", " FROM ", "PPOS"];
			var acPos = geo.aircraft_position();
			me.subtitle = [dmsToString(sprintf(acPos.lat()), "lat"), dmsToString(sprintf(acPos.lon()), "lon")];
			me.L2 = [" OFFSET", nil, "wht"];
			me.L3 = [" HOLD", nil, "wht"];
			me.L6 = [" RETURN", nil, "wht"];
			me.R1 = ["FIX INFO ", nil, "wht"];
			me.R2 = ["[  ]°/[]°/[]", "LL XING/INCR/NO", "blu"];
			me.arrowsMatrix = [[0, 1, 1, 0, 0, 1], [1, 0, 0, 0, 0, 0]];
			me.arrowsColour = [["ack", "wht", "wht", "ack", "ack", "wht"], ["wht", "ack", "ack", "ack", "ack", "ack"]];
		} elsif (me.type == 4) { 
			me.title = ["LAT REV", " FROM ", "DISCON"];
			me.R3 = ["[   ]", "NEXT WPT ", "blu"];
			me.R4 = ["[   ]", "NEW DEST ", "blu"];
			me.L6 = [" RETURN", nil, "wht"];
			me.arrowsMatrix = [[0, 0, 0, 0, 0, 1], [0, 0, 0, 0, 0, 0]];
			me.arrowsColour = [["ack", "ack", "ack", "ack", "ack", "wht"], ["ack", "ack", "ack", "ack", "ack", "ack"]];
		} else {
			if (me.type == 0) {	
				me.title = ["LAT REV", " FROM ", left(me.wpt.wp_name, 4)];
				if (size(me.wpt.wp_name) > 4) {
					me.depAirport = findAirportsByICAO(left(me.wpt.wp_name, 4));
				} else {
					me.depAirport = findAirportsByICAO(me.wpt.wp_name);
				}
				if (size(me.depAirport) > 0) {
					me.subtitle = [dmsToString(sprintf(me.depAirport[0].lat), "lat"), dmsToString(sprintf(me.depAirport[0].lon), "lon")];
				}
				me.L1 = [" DEPARTURE", nil, "wht"];
				me.L2 = [" OFFSET", nil, "wht"];
				me.L6 = [" RETURN", nil, "wht"];
				me.R1 = ["FIX INFO ", nil, "wht"];
				me.R2 = ["[  ]°/[]°/[]", "LL XING/INCR/NO", "blu"];
				me.R3 = ["[   ]", "NEXT WPT ", "blu"];
				me.R4 = ["[   ]", "NEW DEST ", "blu"];
				me.arrowsMatrix = [[1, 1, 0, 0, 0, 1], [1, 0, 0, 0, 0, 0]];
				me.arrowsColour = [["wht", "wht", "ack", "ack", "ack", "wht"], ["wht", "ack", "ack", "ack", "ack", "ack"]];
			} elsif (me.type == 1) {
				me.title = ["LAT REV", " FROM ", left(me.wpt.wp_name, 4)];
				me.arrowsMatrix = [[0, 0, 1, 1, 0, 1], [1, 0, 0, 0, 0, 0]];
				me.arrowsColour = [["ack", "ack", "wht", "blu", "ack", "wht"], ["wht", "ack", "ack", "ack", "ack", "ack"]];
				if (size(me.wpt.wp_name) > 4) {
					me.arrAirport = findAirportsByICAO(left(me.wpt.wp_name, 4));
				} else {
					me.arrAirport = findAirportsByICAO(me.wpt.wp_name);
				}
				if (size(me.arrAirport) > 0) {
					me.subtitle = [dmsToString(sprintf(me.arrAirport[0].lat), "lat"), dmsToString(sprintf(me.arrAirport[0].lon), "lon")];
				}
				me.L3 = [" ALTN", nil, "wht"];
				if (fmgc.FMGCInternal.altAirportSet) {
					me.L4 = [" ALTN", " ENABLE", "blu"];
					me.arrowsMatrix[0][3] = 1;
				} else {
					me.arrowsMatrix[0][3] = 0;
				}
				me.L6 = [" RETURN", nil, "wht"];
				me.R1 = ["ARRIVAL ", nil, "wht"];
				me.R3 = ["[   ]", "NEXT WPT ", "blu"];
			} elsif (me.type == 3) {
				me.title = ["LAT REV", " FROM ", me.wpt.wp_name];
				me.arrowsMatrix = [[0, 0, 1, 1, 0, 1], [1, 0, 0, 0, 1, 0]];
				me.arrowsColour = [["ack", "ack", "wht", "blu", "ack", "wht"], ["wht", "ack", "ack", "ack", "wht", "ack"]];
				
				if (me.wpt != nil) {
					me.subtitle = [dmsToString(sprintf(me.wpt.lat), "lat"), dmsToString(sprintf(me.wpt.lon), "lon")];
				}
				me.L3 = [" HOLD", nil, "wht"];
				if (fmgc.FMGCInternal.altAirportSet) {
					me.L4 = [" ALTN", " ENABLE", "blu"];
					me.arrowsMatrix[0][3] = 1;
				} else {
					me.arrowsMatrix[0][3] = 0;
				}
				me.L6 = [" RETURN", nil, "wht"];
				me.R1 = ["FIX INFO ", nil, "wht"];
				me.R3 = ["[   ]", "NEXT WPT ", "blu"];
				me.R4 = ["[   ]", "NEW DEST ", "blu"];
				me.R5 = ["AIRWAYS ", nil, "wht"];
			}
		}
	},
	makeTmpy: func() {
		if (!fmgc.flightPlanController.temporaryFlag[me.computer]) {
			if (!dirToFlag) {
				fmgc.flightPlanController.createTemporaryFlightPlan(me.computer);
			} else {
				mcdu_message(me.computer, "DIR TO IN PROGRESS");
			}
			me._checkTmpy();
		}
	},
	nextWpt: func() {
		me.makeTmpy();
		
		var returny = fmgc.flightPlanController.scratchpad(mcdu_scratchpad.scratchpads[me.computer].scratchpad, me.index + 1, me.computer);
		if (returny == 0) {
			mcdu_message(me.computer, "NOT IN DATA BASE");
		} elsif (returny == 1) {
			mcdu_message(me.computer, "NOT ALLOWED");
		} else {
			mcdu_scratchpad.scratchpads[me.computer].empty();
			fmgc.flightPlanController.flightPlanChanged(me.computer);
			if (getprop("/MCDU[" ~ me.computer ~ "]/page") != "DUPLICATENAMES") {
				setprop("/MCDU[" ~ me.computer ~ "]/page", "F-PLNA");
			}
		}
	},
};

var dmsToString = func(dms, type) {
	var degrees = int(dms);
	var minutes = sprintf("%.1f",abs((dms - degrees) * 60));
	if (type == "lat") {
		var sign = degrees >= 0 ? "N" : "S";
	} else {
		var sign = degrees >= 0 ? "E" : "W";
	}
	return abs(degrees) ~ "°" ~ minutes ~ sign;
}


var stringToDegrees = func(string, type) {
	var splitString = split(".", string);
	
	var degrees = left(splitString[0], size(splitString[0]) - 2);
	var minutes = right(splitString[0], 2);
	var secondsSign = splitString[1];
	
	var minutesStr = minutes + (left(secondsSign, 1) / 10);
	var sign = right(secondsSign, 1);
	var decimal = degrees + (minutesStr / 60);
	if (type == "lat") {
		if (sign == "N") {
			return decimal;
		} else {
			return -decimal;
		}
	} else {
		if (sign == "E") {
			return decimal;
		} else {
			return -decimal;
		}
	}
}