# A3XX Switching Panel
# Jonathan Redpath (legoboyvdlp)

# Copyright (c) 2019 Jonathan Redpath (legoboyvdlp)

var SwitchingPanel = {
	Switches: {
		audio: props.globals.getNode("/controls/navigation/switching/audio"),
		airData: props.globals.getNode("/controls/navigation/switching/air-data"),
		attHdg: props.globals.getNode("/controls/navigation/switching/att-hdg"),
		eisDmc: props.globals.getNode("/controls/navigation/switching/eis-dmc"),
	},
	
	doAirData: func(newAirData) {
		if (newAirData < -1 or newAirData > 1) { return; }
		me.Switches.airData.setValue(newAirData);
		atc.transponderPanel.updateAirData();
		if (newAirData == -1) {
			dmc.DMController.DMCs[0].changeActiveADIRS(2);
			dmc.DMController.DMCs[1].changeActiveADIRS(1);
		} elsif (newAirData == 1) {
			dmc.DMController.DMCs[0].changeActiveADIRS(0);
			dmc.DMController.DMCs[1].changeActiveADIRS(2);
		} elsif (newAirData == 0) {
			dmc.DMController.DMCs[0].changeActiveADIRS(0);
			dmc.DMController.DMCs[1].changeActiveADIRS(1);
		}
	},
	doAttHdg: func(newAttHdg) {
		if (newAttHdg < -1 or newAttHdg > 1) { return; }
		
		systems.ADIRS.backupSupply[2][1] = newAttHdg == -1 ? 0 : 1;
		
		me.Switches.attHdg.setValue(newAttHdg);
		foreach (var predicate; keys(canvas_nd.ND_1.NDCpt.predicates)) {
			call(canvas_nd.ND_1.NDCpt.predicates[predicate]);
		}
		foreach (var predicate; keys(canvas_nd.ND_2.NDFo.predicates)) {
			call(canvas_nd.ND_2.NDFo.predicates[predicate]);
		}
	},
	doEisDMC: func(newDMC) {
		if (newDMC < -1 or newDMC > 1) { return; }
		me.Switches.eisDMC.setValue(newDMC);
	},
};