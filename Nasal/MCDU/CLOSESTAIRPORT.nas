var closestAirportPage = {
	title: nil,
	arrowsMatrix: [[0, 0, 0, 0, 0, 0],[0, 0, 0, 0, 0, 0]],
	arrowsColour: [["ack", "ack", "ack", "ack", "ack", "ack"],["ack", "ack", "ack", "ack", "ack", "ack"]],
	L1: [nil, nil, "ack"], # content, title, colour
	L2: [nil, nil, "ack"],
	L3: [nil, nil, "ack"],
	L4: [nil, nil, "ack"],
	L5: [nil, nil, "ack"],
	L6: [nil, nil, "ack"],
	C1: [nil, nil, "ack"],
	C2: [nil, nil, "ack"],
	C3: [nil, nil, "ack"],
	C4: [nil, nil, "ack"],
	C5: [nil, nil, "ack"],
	C6: [nil, nil, "ack"],
	R1: [nil, nil, "ack"],
	R2: [nil, nil, "ack"],
	R3: [nil, nil, "ack"],
	R4: [nil, nil, "ack"],
	R5: [nil, nil, "ack"],
	R6: [nil, nil, "ack"],
	computer: nil,
	new: func(computer) {
		var ap = {parents:[closestAirportPage]};
		ap.computer = computer;
		ap.frozen = 0;
		ap.listPopulated = 0;
		ap._range = 10;
		ap.manAirport = nil;
		ap.cdVector = [nil, nil, nil, nil];
		ap._setupPageWithData();
		return ap;
	},
	del: func() {
		return nil;
	},
	_setupPageWithData: func() {
		me.title = "CLOSEST AIRPORTS";
		me.C1[1] = " BRG   DIST";
		me.R1[1] = "UTC  ";
		me.L5 = ["[   ]", nil, "blu"];
		me.C5 = [nil, me.frozen ? "LIST FROZEN" : nil, "grn"];
		me.R5 = [nil, nil, "grn"];
		me.L6 = [" FREEZE", nil, "blu"];
		me.R6 = ["EFOB/WIND ", nil, "wht"];
		me.arrowsMatrix = [[0, 0, 0, 0, 0, 1], [0, 0, 0, 0, 0, 1]];
		me.arrowsColour = [["ack", "ack", "ack", "ack", "ack", "blu"], ["ack", "ack", "ack", "ack", "ack", "wht"]];
		canvas_mcdu.pageSwitch[me.computer].setBoolValue(0);
		me.update();
		me.updateBrgDist();
	},
	freeze: func() {
		me.frozen = !me.frozen;
		if (me.frozen) {
			me.L6 = [" UNFREEZE", nil, "blu"];
		} else {
			me.L6 = [" FREEZE", nil, "blu"];
		}
	},
	update: func() {
		if (me.frozen) { return; }
		me._range = 10;
		me.airports = findAirportsWithinRange(me._range);
		while (size(me.airports) < 4 and me._range < 1500) {
			me.airports = findAirportsWithinRange(me._range);
			if (me._range < 100) {
				me._range += 10;
			} elsif (me._range < 500) {
				me._range += 50;
			} elsif (me._range < 1000) {
				me._range += 100;
			} else {
				me._range += 250;
			}
		}
		if (size(me.airports) >= 1) {
			me.L1 = [me.airports[0].id, nil, "grn"];
			me.R1 = ["----", "UTC  ", "grn"];
		}
		if (size(me.airports) >= 2) {
			me.L2 = [me.airports[1].id, nil, "grn"];
			me.R2 = ["----", nil, "grn"];
		}
		if (size(me.airports) >= 3) {
			me.L3 = [me.airports[2].id, nil, "grn"];
			me.R3 = ["----", nil, "grn"];
		}
		if (size(me.airports) >= 4) {
			me.L4 = [me.airports[3].id, nil, "grn"];
			me.R4 = ["----", nil, "grn"];
		}
		me.listPopulated = 1;
		canvas_mcdu.pageSwitch[me.computer].setBoolValue(0);
	},
	updateBrgDist: func() {
		if (!me.listPopulated) { return; }
		var magvarLocal = magvar();
		if (size(me.airports) >= 1) {
			me.cdVector[0] = courseAndDistance(me.airports[0]);
			me.brg = me.cdVector[0][0] - magvarLocal;
			if (me.brg > 360) {
				me.brg -= 360;
			} else if (me.brg < 0) {
				me.brg += 360;
			}
			
			me.C1 = [sprintf("%03d°",me.brg) ~ " " ~ sprintf("%4d",math.round(me.cdVector[0][1])), " BRG   DIST", "grn"];
		}
		if (size(me.airports) >= 2) {
			me.cdVector[1] = courseAndDistance(me.airports[1]);
			me.brg = me.cdVector[1][0] - magvarLocal;
			if (me.brg > 360) {
				me.brg -= 360;
			} else if (me.brg < 0) {
				me.brg += 360;
			}
			
			me.C2 = [sprintf("%03d°",me.brg) ~ " " ~ sprintf("%4d",math.round(me.cdVector[1][1])), nil, "grn"];
		}
		if (size(me.airports) >= 3) {
			me.cdVector[2] = courseAndDistance(me.airports[2]);
			me.brg = me.cdVector[2][0] - magvarLocal;
			if (me.brg > 360) {
				me.brg -= 360;
			} else if (me.brg < 0) {
				me.brg += 360;
			}
			
			me.C3 = [sprintf("%03d°",me.brg) ~ " " ~ sprintf("%4d",math.round(me.cdVector[2][1])), nil, "grn"];
		}
		if (size(me.airports) >= 4) {
			me.cdVector[3] = courseAndDistance(me.airports[3]);
			me.brg = me.cdVector[3][0] - magvarLocal;
			if (me.brg > 360) {
				me.brg -= 360;
			} else if (me.brg < 0) {
				me.brg += 360;
			}
			
			me.C4 = [sprintf("%03d°",me.brg) ~ " " ~ sprintf("%4d",math.round(me.cdVector[3][1])), nil, "grn"];
		}
		if (me.manAirport != nil) {
			me.brg = courseAndDistance(me.manAirport)[0] - magvarLocal;
			if (me.brg > 360) {
				me.brg -= 360;
			} else if (me.brg < 0) {
				me.brg += 360;
			}
			
			me.C5 = [sprintf("%03d°",me.brg) ~ " " ~ sprintf("%4d",math.round(courseAndDistance(me.manAirport)[1])), me.frozen ? "LIST FROZEN" : nil, "grn"];
		}
		canvas_mcdu.pageSwitch[me.computer].setBoolValue(0);
	},
	manAirportCall: func(id) {
		if (id == "CLR") {
			me.manAirport = nil;
			me._setupPageWithData();
			return;
		}
		if (size(id) > 4) {
			mcdu_message(me.computer, "NOT ALLOWED");
		} elsif (airportinfo(id) == nil) {
			mcdu_message(me.computer, "NOT IN DATA BASE");
		} else {
			me.manAirport = airportinfo(id);
			me.fontMatrix[0][4] = 0;
			me.L5 = [id, nil, "grn"];
			me.R5 = ["----", nil, "grn"];
			mcdu_scratchpad.scratchpads[me.computer].empty();
		}
		canvas_mcdu.pageSwitch[me.computer].setBoolValue(0);
	}
};

setlistener("/MCDU[0]/page", func() {
	if (getprop("/MCDU[0]/page") == "CLOSESTAIRPORT") {
		updateClosestAirport1T.start();
		updateClosestAirport1BT.start();
	} else {
		if (updateClosestAirport1T.isRunning) {
			updateClosestAirport1T.stop();
			updateClosestAirport1BT.stop();
		}
	}
}, 0, 0);

setlistener("/MCDU[1]/page", func() {
	if (getprop("/MCDU[1]/page") == "CLOSESTAIRPORT") {
		updateClosestAirport2T.start();
		updateClosestAirport2BT.start();
	} else {
		if (updateClosestAirport2T.isRunning) {
			updateClosestAirport2T.stop();
			updateClosestAirport2BT.stop();
		}
	}
}, 0, 0);


var updateClosestAirport1 = func() {
	if (canvas_mcdu.myClosestAirport[0] != nil) {
		if (getprop("MCDU[0]/page") == "CLOSESTAIRPORT") {
			canvas_mcdu.myClosestAirport[0].update();
		}
	}
};

var updateClosestAirport2 = func() {
	if (canvas_mcdu.myClosestAirport[1] != nil) {
		if (getprop("MCDU[1]/page") == "CLOSESTAIRPORT") {
			canvas_mcdu.myClosestAirport[1].update();
		}
	}
};

var updateClosestAirport1B = func() {
	if (canvas_mcdu.myClosestAirport[0] != nil) {
		if (getprop("MCDU[0]/page") == "CLOSESTAIRPORT") {
			canvas_mcdu.myClosestAirport[0].updateBrgDist();
		}
	}
};

var updateClosestAirport2B = func() {
	if (canvas_mcdu.myClosestAirport[1] != nil) {
		if (getprop("MCDU[1]/page") == "CLOSESTAIRPORT") {
			canvas_mcdu.myClosestAirport[1].updateBrgDist();
		}
	}
};

var updateClosestAirport1T = maketimer(30, updateClosestAirport1);
var updateClosestAirport2T = maketimer(30, updateClosestAirport2);
var updateClosestAirport1BT = maketimer(0.5, updateClosestAirport1B);
var updateClosestAirport2BT = maketimer(0.5, updateClosestAirport2B);