# A3XX Lower ECAM Canvas

# Copyright (c) 2020 Josh Davidson (Octal450)

var lowerECAM_apu = nil;
var lowerECAM_bleed = nil;
var lowerECAM_cond = nil;
var lowerECAM_crz = nil;
var lowerECAM_door = nil;
var lowerECAM_elec = nil;
var lowerECAM_eng = nil;
var lowerECAM_fctl = nil;
var lowerECAM_fuel = nil;
var lowerECAM_hyd = nil;
var lowerECAM_press = nil;
var lowerECAM_status = nil;
var lowerECAM_wheel = nil;
var lowerECAM_test = nil;
var lowerECAM_display = nil;
var page = "fctl";
var blue_psi = 0;
var green_psi = 0;
var yellow_psi = 0;
var autobrakemode = 0;
var nosegear = 0;
var leftgear = 0;
var rightgear = 0;
var leftdoor = 0;
var rightdoor = 0;
var nosedoor = 0;
var gearlvr = 0;
var elapsedtime = 0;
var tr1_v = 0;
var tr1_a = 0;
var tr2_v = 0;
var tr2_a = 0;
var essTramps = 0;
var essTrvolts = 0;
var elac1Node = 0;
var elac2Node = 0;
var sec1Node = 0;
var sec2Node = 0;
var eng_valve_state = 0;
var bleed_valve_cur = 0;
var hp_valve_state = 0;
var xbleedcmdstate = 0;
var ramAirState = 0;

# Fetch Nodes
var acconfig_weight_kgs = props.globals.getNode("/systems/acconfig/options/weight-kgs", 1);
var rate = props.globals.getNode("/systems/acconfig/options/lecam-rate", 1);
var autoconfig_running = props.globals.getNode("/systems/acconfig/autoconfig-running", 1);
var ecam_page = props.globals.getNode("/ECAM/Lower/page", 1);
var hour = props.globals.getNode("/sim/time/utc/hour", 1);
var minute = props.globals.getNode("/sim/time/utc/minute", 1);
var apu_flap = props.globals.getNode("/controls/apu/inlet-flap/position-norm", 1);
var apu_rpm = props.globals.getNode("/engines/engine[2]/n1", 1);
var apu_egt = props.globals.getNode("/systems/apu/egt-degC", 1);
var door_left = props.globals.getNode("/ECAM/Lower/door-left", 1);
var door_right = props.globals.getNode("/ECAM/Lower/door-right", 1);
var door_nose_left = props.globals.getNode("/ECAM/Lower/door-nose-left", 1);
var door_nose_right = props.globals.getNode("/ECAM/Lower/door-nose-right", 1);
var apu_rpm_rot = props.globals.getNode("/ECAM/Lower/APU-N", 1);
var apu_egt_rot = props.globals.getNode("/ECAM/Lower/APU-EGT", 1);
var oil_qt1 = props.globals.getNode("/ECAM/Lower/Oil-QT[0]", 1);
var oil_qt2 = props.globals.getNode("/ECAM/Lower/Oil-QT[1]", 1);
var oil_psi1 = props.globals.getNode("/ECAM/Lower/Oil-PSI[0]", 1);
var oil_psi2 = props.globals.getNode("/ECAM/Lower/Oil-PSI[1]", 1);
var bleedapu = props.globals.getNode("", 1);
var aileron_ind_left = props.globals.getNode("", 1);
var aileron_ind_right = props.globals.getNode("/ECAM/Lower/aileron-ind-right", 1);
var elevator_ind_left = props.globals.getNode("", 1);
var elevator_ind_right = props.globals.getNode("/ECAM/Lower/elevator-ind-right", 1);
var elevator_trim_deg = props.globals.getNode("", 1);
var final_deg = props.globals.getNode("", 1);
var temperature_degc = props.globals.getNode("/environment/temperature-degc", 1);
var tank3_content_lbs = props.globals.getNode("/fdm/jsbsim/propulsion/tank[2]/contents-lbs", 1);
var ir2_knob = props.globals.getNode("/controls/adirs/ir[1]/knob", 1);
var apuBleedNotOn = props.globals.getNode("/systems/pneumatics/warnings/apu-bleed-not-on", 1);
var apu_valve = props.globals.getNode("/systems/pneumatics/valves/apu-bleed-valve-cmd", 1);
var apu_valve_state = props.globals.getNode("/systems/pneumatics/valves/apu-bleed-valve", 1);
var xbleedcmd = props.globals.getNode("/systems/pneumatics/valves/crossbleed-valve-cmd", 1);
var xbleed = props.globals.getNode("/systems/pneumatics/valves/crossbleed-valve", 1);
var xbleedstate = nil;
var hp_valve1_state = props.globals.getNode("/systems/pneumatics/valves/engine-1-hp-valve", 1);
var hp_valve2_state = props.globals.getNode("/systems/pneumatics/valves/engine-2-hp-valve", 1);
var hp_valve1 = props.globals.getNode("/systems/pneumatics/valves/engine-1-hp-valve-cmd", 1);
var hp_valve2 = props.globals.getNode("/systems/pneumatics/valves/engine-2-hp-valve-cmd", 1);
var eng_valve1 = props.globals.getNode("/systems/pneumatics/valves/engine-1-prv-valve", 1);
var eng_valve2 = props.globals.getNode("/systems/pneumatics/valves/engine-2-prv-valve", 1);
var precooler1_psi = props.globals.getNode("/systems/pneumatics/psi/engine-1-psi", 1);
var precooler2_psi = props.globals.getNode("/systems/pneumatics/psi/engine-2-psi", 1);
var precooler1_temp = props.globals.getNode("/systems/pneumatics/precooler/temp-1", 1);
var precooler2_temp = props.globals.getNode("/systems/pneumatics/precooler/temp-2", 1);
var precooler1_ovht = props.globals.getNode("/systems/pneumatics/precooler/ovht-1", 1);
var precooler2_ovht = props.globals.getNode("/systems/pneumatics/precooler/ovht-2", 1);
var bmc1working = props.globals.getNode("/systems/pneumatics/indicating/bmc1-working", 1);
var bmc2working = props.globals.getNode("/systems/pneumatics/indicating/bmc2-working", 1);
var bmc1 = 0;
var bmc2 = 0;
var gs_kt = props.globals.getNode("/velocities/groundspeed-kt", 1);
var switch_wing_aice = props.globals.getNode("/controls/ice-protection/wing", 1);
var pack1_bypass = props.globals.getNode("/systems/pneumatics/pack-1-bypass", 1);
var pack2_bypass = props.globals.getNode("/systems/pneumatics/pack-2-bypass", 1);
var oil_qt1_actual = props.globals.getNode("", 1);
var oil_qt2_actual = props.globals.getNode("/engines/engine[1]/oil-qt-actual", 1);
var fuel_used_lbs1 = props.globals.getNode("", 1);
var gLoad = props.globals.getNode("", 1);

# Hydraulic
var blue_psi = 0;
var green_psi = 0;
var yellow_psi = 0;
var rat_deployed = props.globals.getNode("/controls/hydraulic/rat-deployed", 1);
var y_resv_ovht = props.globals.getNode("/systems/hydraulic/yellow-resv-ovht", 1);
var b_resv_ovht = props.globals.getNode("/systems/hydraulic/blue-resv-ovht", 1);
var g_resv_ovht = props.globals.getNode("/systems/hydraulic/green-resv-ovht", 1);
var askidsw = 0;
var brakemode = 0;
var accum = 0;
var L1BrakeTempc = props.globals.getNode("/gear/gear[1]/L1brake-temp-degc", 1);
var L2BrakeTempc = props.globals.getNode("/gear/gear[1]/L2brake-temp-degc", 1);
var R3BrakeTempc = props.globals.getNode("/gear/gear[2]/R3brake-temp-degc", 1);
var R4BrakeTempc = props.globals.getNode("/gear/gear[2]/R4brake-temp-degc", 1);

var eng1_running = props.globals.getNode("/engines/engine[0]/running", 1);
var eng2_running = props.globals.getNode("/engines/engine[1]/running", 1);
var switch_cart = props.globals.getNode("/controls/electrical/ground-cart", 1);
var fuel_flow1 = props.globals.getNode("/engines/engine[0]/fuel-flow_actual", 1);
var fuel_flow2 = props.globals.getNode("/engines/engine[1]/fuel-flow_actual", 1);
var cutoff_switch1 = props.globals.getNode("/controls/engines/engine[0]/cutoff-switch", 1);
var cutoff_switch2 = props.globals.getNode("/controls/engines/engine[1]/cutoff-switch", 1);
var autobreak_mode = props.globals.getNode("/controls/autobrake/mode", 1);
var gear1_pos = props.globals.getNode("/gear/gear[0]/position-norm", 1);
var gear2_pos = props.globals.getNode("/gear/gear[1]/position-norm", 1);
var gear3_pos = props.globals.getNode("/gear/gear[2]/position-norm", 1);
var gear_door_L = props.globals.getNode("/systems/hydraulic/gear/door-left", 1);
var gear_door_R = props.globals.getNode("/systems/hydraulic/gear/door-right", 1);
var gear_door_N = props.globals.getNode("/systems/hydraulic/gear/door-nose", 1);
var gear_down = props.globals.getNode("/controls/gear/gear-down", 1);
var press_vs_norm = props.globals.getNode("", 1);
var cabinalt = props.globals.getNode("", 1);
var gear0_wow = props.globals.getNode("/gear/gear[0]/wow", 1);

# Create Nodes:

var canvas_lowerECAM_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		var elapsedtime = pts.Sim.Time.elapsedSec.getValue();
		
		if (systems.ELEC.Bus.ac2.getValue() >= 110 and lighting_du4.getValue() > 0.01) {
			if (du4_test_time.getValue() + du4_test_amount.getValue() >= elapsedtime) {
				lowerECAM_apu.page.hide();
				lowerECAM_bleed.page.hide();
				lowerECAM_cond.page.hide();
				lowerECAM_crz.page.hide();
				lowerECAM_door.page.hide();
				lowerECAM_elec.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
				lowerECAM_fuel.page.hide();
				lowerECAM_press.page.hide();
				lowerECAM_status.page.hide();
				lowerECAM_wheel.page.hide();
				lowerECAM_test.page.show();
				lowerECAM_test.update();
			} else {
				lowerECAM_test.page.hide();
				page = ecam_page.getValue();
				if (page == "apu") {
					lowerECAM_apu.page.show();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_apu.update();
				} else if (page == "bleed") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.show();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_bleed.update();
				} else if (page == "cond") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.show();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_cond.update();
				} else if (page == "cruise") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.show();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_crz.update();
				} else if (page == "door") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.show();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_door.update();
				} else if (page == "elec") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.show();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_elec.update();
				} else if (page == "eng") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.show();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_eng.update();
				} else if (page == "fctl") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.show();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_fctl.update();
				} else if (page == "fuel") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.show();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_fuel.update();
				} else if (page == "press") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.show();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_press.update();
				} else if (page == "sts") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.show();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
					lowerECAM_status.update();
				} else if (page == "hyd") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.show();
					lowerECAM_wheel.page.hide();
					lowerECAM_hyd.update();
				} else if (page == "wheel") {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.show();
					lowerECAM_wheel.update();
				} else {
					lowerECAM_apu.page.hide();
					lowerECAM_bleed.page.hide();
					lowerECAM_cond.page.hide();
					lowerECAM_crz.page.hide();
					lowerECAM_door.page.hide();
					lowerECAM_elec.page.hide();
					lowerECAM_eng.page.hide();
					lowerECAM_fctl.page.hide();
					lowerECAM_fuel.page.hide();
					lowerECAM_press.page.hide();
					lowerECAM_status.page.hide();
					lowerECAM_hyd.page.hide();
					lowerECAM_wheel.page.hide();
				}
			}
		} else {
			lowerECAM_test.page.hide();
			lowerECAM_apu.page.hide();
			lowerECAM_bleed.page.hide();
			lowerECAM_cond.page.hide();
			lowerECAM_crz.page.hide();
			lowerECAM_door.page.hide();
			lowerECAM_elec.page.hide();
			lowerECAM_eng.page.hide();
			lowerECAM_fctl.page.hide();
			lowerECAM_fuel.page.hide();
			lowerECAM_press.page.hide();
			lowerECAM_status.page.hide();
			lowerECAM_hyd.page.hide();
			lowerECAM_wheel.page.hide();
		}
	},
	updateBottomStatus: func() {
		
		
		
		
	},
};
var canvas_lowerECAM_bleed = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_bleed, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","UTCh","UTCm","GLoad","GW-weight-unit", "BLEED-XFEED", "BLEED-Ram-Air", "BLEED-APU-CIRCLE", "BLEED-HP-Valve-1",
		"BLEED-APU-LINES","BLEED-ENG-1", "BLEED-HP-Valve-2", "BLEED-ENG-2", "BLEED-Precooler-1-Inlet-Press", "BLEED-Precooler-1-Outlet-Temp",
		"BLEED-Precooler-2-Inlet-Press", "BLEED-Precooler-2-Outlet-Temp", "BLEED-ENG-1-label", "BLEED-ENG-2-label",
		"BLEED-GND", "BLEED-Pack-1-Flow-Valve", "BLEED-Pack-2-Flow-Valve", "BLEED-Pack-1-Out-Temp","BLEED-APU-connectionTop",
		"BLEED-Pack-1-Comp-Out-Temp", "BLEED-Pack-1-Packflow-needle", "BLEED-Pack-1-Bypass-needle", "BLEED-Pack-2-Out-Temp",
		"BLEED-Pack-2-Bypass-needle", "BLEED-Pack-2-Comp-Out-Temp", "BLEED-Pack-2-Packflow-needle", "BLEED-Anti-Ice-Left",
		"BLEED-Anti-Ice-Right", "BLEED-HP-2-connection", "BLEED-HP-1-connection", "BLEED-ANTI-ICE-ARROW-LEFT", "BLEED-ANTI-ICE-ARROW-RIGHT",
		"BLEED-xbleedLeft","BLEED-xbleedCenter","BLEED-xbleedRight","BLEED-cond-1","BLEED-cond-2","BLEED-cond-3","BLEED-Ram-Air-connection"];
	},
	update: func() {
		# X BLEED
		xbleedstate = xbleed.getValue();
		xbleedcmdstate = xbleedcmd.getBoolValue();
		if (xbleedcmdstate != xbleedstate) {
			me["BLEED-XFEED"].setColor(0.7333,0.3803,0);
		} else {
			me["BLEED-XFEED"].setColor(0.0509,0.7529,0.2941);
		}
		
		if (xbleedcmdstate == xbleedstate) {
			if (xbleedcmdstate) {
				me["BLEED-XFEED"].setRotation(0);
			} else {
				me["BLEED-XFEED"].setRotation(90 * D2R);
			}
		} else {
			me["BLEED-XFEED"].setRotation(45 * D2R);
		}
		
		if (xbleedstate == 1) {
			me["BLEED-xbleedCenter"].show();
			me["BLEED-xbleedRight"].show();
		} else {
			me["BLEED-xbleedCenter"].hide();
			me["BLEED-xbleedRight"].hide();
		}

		# HP valve 1
		hp_valve_state = hp_valve1_state.getValue();

		if (hp_valve_state == 1) {
			me["BLEED-HP-Valve-1"].setRotation(90 * D2R);
			me["BLEED-HP-1-connection"].show();
		} else {
			me["BLEED-HP-Valve-1"].setRotation(0);
			me["BLEED-HP-1-connection"].hide();
		}
		
		if (hp_valve_state == hp_valve1.getValue()) {
			me["BLEED-HP-Valve-1"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["BLEED-HP-Valve-1"].setColor(0.7333,0.3803,0);
		}

		# HP valve 2
		hp_valve_state = hp_valve2_state.getValue();
		
		if (hp_valve_state == 1) {
			me["BLEED-HP-Valve-2"].setRotation(90 * D2R);
			me["BLEED-HP-2-connection"].show();
		} else {
			me["BLEED-HP-Valve-2"].setRotation(0);
			me["BLEED-HP-2-connection"].hide();
		}
		
		if (hp_valve_state == hp_valve2.getValue()) {
			me["BLEED-HP-Valve-2"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["BLEED-HP-Valve-2"].setColor(0.7333,0.3803,0);
		}

		# ENG BLEED valve 1
		eng_valve_state = systems.PNEU.Switch.bleed1.getValue();
		bleed_valve_cur = eng_valve1.getValue();

		if (bleed_valve_cur == 0) {
			me["BLEED-ENG-1"].setRotation(0);
		} else {
			me["BLEED-ENG-1"].setRotation(90 * D2R);
		}
		
		if (eng_valve_state == bleed_valve_cur) {
			me["BLEED-ENG-1"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["BLEED-ENG-1"].setColor(0.7333,0.3803,0);
		}
		
		# APU BLEED valve
		var apu_valve_state2 = apu_valve_state.getValue();
		
		if (systems.APUNodes.Controls.master.getValue()) {
			me["BLEED-APU-LINES"].show();
			if (apu_valve_state2 == 1) {
				me["BLEED-APU-CIRCLE"].setRotation(0);
				me["BLEED-APU-connectionTop"].show();
				me["BLEED-xbleedLeft"].show();
			} else {
				me["BLEED-APU-CIRCLE"].setRotation(90 * D2R);
				me["BLEED-APU-connectionTop"].hide();
				if (xbleed.getValue() != 1) {
					me["BLEED-xbleedLeft"].hide();
				} else {
					me["BLEED-xbleedLeft"].show();
				}
			}
			if (apuBleedNotOn.getValue() != 1) {
				me["BLEED-APU-CIRCLE"].setColor(0.0509,0.7529,0.2941);
			} else {
				me["BLEED-APU-CIRCLE"].setColor(0.7333,0.3803,0);
			}
		} else {
			if (xbleed.getValue() != 1) {
				me["BLEED-xbleedLeft"].hide();
			} else {
				me["BLEED-xbleedLeft"].show();
			}
			me["BLEED-APU-LINES"].hide();
			me["BLEED-APU-connectionTop"].hide();
		}
			
		# ENG BLEED valve 2
		eng_valve_state = systems.PNEU.Switch.bleed2.getValue();
		bleed_valve_cur = eng_valve2.getValue();
		
		if (bleed_valve_cur == 0) {
			me["BLEED-ENG-2"].setRotation(0);
		} else {
			me["BLEED-ENG-2"].setRotation(90 * D2R);
		}
		
		if (eng_valve_state == bleed_valve_cur) {
			me["BLEED-ENG-2"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["BLEED-ENG-2"].setColor(0.7333,0.3803,0);
		}

		# Precooler inlet 1
		bmc1 = bmc1working.getValue();
		bmc2 = bmc2working.getValue();
		
		if (bmc1) {
			var precooler_psi = precooler1_psi.getValue();
			me["BLEED-Precooler-1-Inlet-Press"].setText(sprintf("%s", math.round(precooler_psi)));
			if (precooler_psi < 4 or precooler_psi > 57) {
				me["BLEED-Precooler-1-Inlet-Press"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-Precooler-1-Inlet-Press"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-Precooler-1-Inlet-Press"].setText(sprintf("%s", "XX"));
			me["BLEED-Precooler-1-Inlet-Press"].setColor(0.7333,0.3803,0);
		}

		# Precooler inlet 2
		if (bmc2) {
			var precooler_psi = precooler2_psi.getValue();
			me["BLEED-Precooler-2-Inlet-Press"].setText(sprintf("%s", math.round(precooler_psi)));
			if (precooler_psi < 4 or precooler_psi > 57) {
				me["BLEED-Precooler-2-Inlet-Press"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-Precooler-2-Inlet-Press"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-Precooler-2-Inlet-Press"].setText(sprintf("%s", "XX"));
			me["BLEED-Precooler-2-Inlet-Press"].setColor(0.7333,0.3803,0);
		}

		# Precooler outlet 1
		if (bmc1) {
			var precooler_temp = precooler1_temp.getValue();
			me["BLEED-Precooler-1-Outlet-Temp"].setText(sprintf("%s", math.round(precooler_temp, 5)));
			if (systems.PNEU.Switch.bleed1.getValue() and (precooler_temp < 150 or precooler1_ovht.getValue())) {
				me["BLEED-Precooler-1-Outlet-Temp"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-Precooler-1-Outlet-Temp"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-Precooler-1-Outlet-Temp"].setText(sprintf("%s", "XX"));
			me["BLEED-Precooler-1-Outlet-Temp"].setColor(0.7333,0.3803,0);
		}

		# Precooler outlet 2
		if (bmc2) {
			var precooler_temp = precooler2_temp.getValue();
			me["BLEED-Precooler-2-Outlet-Temp"].setText(sprintf("%s", math.round(precooler_temp, 5)));
			if (systems.PNEU.Switch.bleed2.getValue() and (precooler_temp < 150 or precooler2_ovht.getValue())) {
				me["BLEED-Precooler-2-Outlet-Temp"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-Precooler-2-Outlet-Temp"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-Precooler-2-Outlet-Temp"].setText(sprintf("%s", "XX"));
			me["BLEED-Precooler-2-Outlet-Temp"].setColor(0.7333,0.3803,0);
		}

		# GND air
		if (pts.Gear.wow[1].getValue()) {
			me["BLEED-GND"].show();
		} else {
			me["BLEED-GND"].hide();
		}

		# WING ANTI ICE
		if (switch_wing_aice.getValue()) {
			me["BLEED-Anti-Ice-Left"].show();
			me["BLEED-Anti-Ice-Right"].show();
		} else {
			me["BLEED-Anti-Ice-Left"].hide();
			me["BLEED-Anti-Ice-Right"].hide();
		}

		# ENG 1 label
		if (pts.Engines.Engine.n2Actual[0].getValue() >= 59) {
			me["BLEED-ENG-1-label"].setColor(0.8078,0.8039,0.8078);
		} else {
			me["BLEED-ENG-1-label"].setColor(0.7333,0.3803,0);
		}

		# ENG 2 label
		if (pts.Engines.Engine.n2Actual[1].getValue() >= 59) {
			me["BLEED-ENG-2-label"].setColor(0.8078,0.8039,0.8078);
		} else {
			me["BLEED-ENG-2-label"].setColor(0.7333,0.3803,0);
		}

		# PACK 1 -----------------------------------------
		packValveState = systems.PNEU.Valves.pack1.getValue();
		me["BLEED-Pack-1-Out-Temp"].setText(sprintf("%s", math.round(systems.PNEU.Packs.pack1OutTemp.getValue(), 5)));
		me["BLEED-Pack-1-Comp-Out-Temp"].setText(sprintf("%s", math.round(systems.PNEU.Packs.pack1OutletTemp.getValue(), 5)));

		if (systems.PNEU.Packs.pack1OutTemp.getValue() > 90) {
			me["BLEED-Pack-1-Out-Temp"].setColor(0.7333,0.3803,0);
		} else {
			me["BLEED-Pack-1-Out-Temp"].setColor(0.0509,0.7529,0.2941);
		}

		# `-50` cause the middel position from where we move the needle is at 50
		me["BLEED-Pack-1-Bypass-needle"].setRotation((pack1_bypass.getValue() - 50) * D2R);

		if (systems.PNEU.Packs.pack1OutletTemp.getValue() > 230) {
			me["BLEED-Pack-1-Comp-Out-Temp"].setColor(0.7333,0.3803,0);
		} else {
			me["BLEED-Pack-1-Comp-Out-Temp"].setColor(0.0509,0.7529,0.2941);
		}

		me["BLEED-Pack-1-Packflow-needle"].setRotation(systems.PNEU.Packs.packFlow1.getValue() * D2R);

		if (packValveState == 0) {
			me["BLEED-Pack-1-Packflow-needle"].setColorFill(0.7333,0.3803,0);
			me["BLEED-Pack-1-Flow-Valve"].setRotation(90 * D2R);
		} else {
			me["BLEED-Pack-1-Packflow-needle"].setColorFill(0.0509,0.7529,0.2941);
			me["BLEED-Pack-1-Flow-Valve"].setRotation(0);
		}

		if (packValveState == systems.PNEU.Switch.pack1.getValue()) {
			me["BLEED-Pack-1-Flow-Valve"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["BLEED-Pack-1-Flow-Valve"].setColor(0.7333,0.3803,0);
		}

		# PACK 2 -----------------------------------------
		packValveState = systems.PNEU.Valves.pack2.getValue();
		me["BLEED-Pack-2-Out-Temp"].setText(sprintf("%s", math.round(systems.PNEU.Packs.pack2OutTemp.getValue(), 5)));
		me["BLEED-Pack-2-Comp-Out-Temp"].setText(sprintf("%s", math.round(systems.PNEU.Packs.pack2OutletTemp.getValue(), 5)));

		if (systems.PNEU.Packs.pack2OutTemp.getValue() > 90) {
			me["BLEED-Pack-2-Out-Temp"].setColor(0.7333,0.3803,0);
		} else {
			me["BLEED-Pack-2-Out-Temp"].setColor(0.0509,0.7529,0.2941);
		}

		me["BLEED-Pack-2-Bypass-needle"].setRotation((pack2_bypass.getValue() - 50) * D2R);

		if (systems.PNEU.Packs.pack2OutletTemp.getValue() > 230) {
			me["BLEED-Pack-2-Comp-Out-Temp"].setColor(0.7333,0.3803,0);
		} else {
			me["BLEED-Pack-2-Comp-Out-Temp"].setColor(0.0509,0.7529,0.2941);
		}

		me["BLEED-Pack-2-Packflow-needle"].setRotation(systems.PNEU.Packs.packFlow2.getValue() * D2R);

		if (packValveState == 0) {
			me["BLEED-Pack-2-Packflow-needle"].setColorFill(0.7333,0.3803,0);
			me["BLEED-Pack-2-Flow-Valve"].setRotation(90 * D2R);
		} else {
			me["BLEED-Pack-2-Packflow-needle"].setColorFill(0.0509,0.7529,0.2941);
			me["BLEED-Pack-2-Flow-Valve"].setRotation(0);
		}

		if (packValveState == systems.PNEU.Switch.pack2.getValue()) {
			me["BLEED-Pack-2-Flow-Valve"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["BLEED-Pack-2-Flow-Valve"].setColor(0.7333,0.3803,0);
		}

		# Ram Air
		ramAirState = systems.PNEU.Valves.ramAir.getValue();
		if (ramAirState == 0) {
			me["BLEED-Ram-Air"].setRotation(90 * D2R);
			me["BLEED-Ram-Air"].setColor(0.0509,0.7529,0.2941);
			me["BLEED-Ram-Air"].setColorFill(0.0509,0.7529,0.2941);
			me["BLEED-Ram-Air-connection"].hide();
		} elsif (ramAirState) {
			me["BLEED-Ram-Air"].setRotation(0);
			if (pts.Gear.wow[1].getValue()) {
				me["BLEED-Ram-Air"].setColor(0.7333,0.3803,0);
				me["BLEED-Ram-Air"].setColorFill(0.7333,0.3803,0);
			} else {
				me["BLEED-Ram-Air"].setColor(0.0509,0.7529,0.2941);
				me["BLEED-Ram-Air"].setColorFill(0.0509,0.7529,0.2941);
			}
			me["BLEED-Ram-Air-connection"].show();
		} else {
			me["BLEED-Ram-Air"].setRotation(45 * D2R);
			me["BLEED-Ram-Air"].setColor(0.7333,0.3803,0);
			me["BLEED-Ram-Air"].setColorFill(0.7333,0.3803,0);
			me["BLEED-Ram-Air-connection"].show();
		}
		
		# Triangles
		if (systems.PNEU.Valves.pack1.getValue() == 0 and systems.PNEU.Valves.pack2.getValue() == 0) {
			if (pts.Gear.wow[1].getValue() or ramAirState != 1) {
				me["BLEED-cond-1"].setColor(0.7333,0.3803,0);
				me["BLEED-cond-2"].setColor(0.7333,0.3803,0);
				me["BLEED-cond-3"].setColor(0.7333,0.3803,0);
			} else {
				me["BLEED-cond-1"].setColor(0.0509,0.7529,0.2941);
				me["BLEED-cond-2"].setColor(0.0509,0.7529,0.2941);
				me["BLEED-cond-3"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["BLEED-cond-1"].setColor(0.0509,0.7529,0.2941);
			me["BLEED-cond-2"].setColor(0.0509,0.7529,0.2941);
			me["BLEED-cond-3"].setColor(0.0509,0.7529,0.2941);
		}
		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_elec = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_elec, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","UTCh","UTCm","GLoad","GW-weight-unit","BAT1-label","Bat1Volt","Bat1Ampere","BAT2-label","Bat2Volt","Bat2Ampere","BAT1-charge","BAT1-discharge","BAT2-charge","BAT2-discharge","ELEC-Line-DC1-DCBAT","ELEC-Line-DC1-DCESS","ELEC-Line-DC2-DCBAT",
		"ELEC-Line-DC1-DCESS_DCBAT","ELEC-Line-DC2-DCESS_DCBAT","ELEC-Line-TR1-DC1","ELEC-Line-TR2-DC2","Shed-label","ELEC-Line-ESSTR-DCESS","TR1-label","TR1Volt","TR1Ampere","TR2-label","TR2Volt","TR2Ampere","EMERGEN-group","EmergenVolt","EmergenHz",
		"ELEC-Line-Emergen-ESSTR","EMERGEN-Label-off","Emergen-Label","EMERGEN-out","ELEC-Line-ACESS-TRESS","ELEC-Line-AC1-TR1","ELEC-Line-AC2-TR2","ELEC-Line-AC1-ACESS","ELEC-Line-AC2-ACESS","ACESS-SHED","ACESS","AC1-in","AC2-in","ELEC-Line-GEN1-AC1","ELEC-Line-GEN2-AC2",
		"ELEC-Line-APU-AC1","ELEC-Line-APU-EXT","ELEC-Line-EXT-AC2","APU-out","EXT-out","EXTPWR-group","ExtVolt","ExtHz","APU-content","APU-border","APUGentext","APUGenLoad","APUGenVolt","APUGenHz","APUGEN-off","GEN1-label","Gen1Load","Gen1Volt","Gen1Hz",
		"GEN2-label","Gen2Load","GEN2-off","Gen2Volt","Gen2Hz","ELEC-IDG-1-label","ELEC-IDG-1-num-label","ELEC-IDG-1-Temp","IDG1-LOPR","IDG1-DISC","IDG1-RISE-Value","IDG1-RISE-label","GalleyShed","ELEC-IDG-2-Temp","ELEC-IDG-2-label","ELEC-IDG-2-num-label","IDG2-RISE-label","IDG2-RISE-Value","IDG2-LOPR",
		"IDG2-DISC","ESSTR-group","ESSTR","ESSTR-Volt","ESSTR-Ampere","BAT1-content","BAT2-content","BAT1-OFF","BAT2-OFF","GEN1-content","GEN2-content","GEN-1-num-label","GEN-2-num-label","GEN1-off","GEN2-off","GEN1-num-label","GEN2-num-label","EXTPWR-label",
		"ELEC-ACESS-SHED-label","ELEC-DCBAT-label","ELEC-DCESS-label","ELEC-DC2-label","ELEC-DC1-label","ELEC-AC1-label","ELEC-AC2-label","ELEC-ACESS-label","ELEC-Line-ESSTR-DCESS-off","ELEC-Line-Emergen-ESSTR-off"];
	},
	update: func() {

		# BAT1
		if (systems.ELEC.Switch.bat1.getValue() == 0) {
			me["BAT1-OFF"].show();
			me["BAT1-content"].hide();
			me["BAT1-discharge"].hide();
			me["BAT1-charge"].hide();
		} else {
			me["BAT1-OFF"].hide();
			me["BAT1-content"].show();
			me["Bat1Ampere"].setText(sprintf("%s", math.round(systems.ELEC.Source.Bat1.amps.getValue())));
			me["Bat1Volt"].setText(sprintf("%s", math.round(systems.ELEC.Source.Bat1.volt.getValue())));

			if (systems.ELEC.Source.Bat1.volt.getValue() >= 24.95 and systems.ELEC.Source.Bat1.volt.getValue() <= 31.05) {
				me["Bat1Volt"].setColor(0.0509,0.7529,0.2941);
			} else {
				me["Bat1Volt"].setColor(0.7333,0.3803,0);
			}

			if (systems.ELEC.Source.Bat1.amps.getValue() > 5) {
				me["Bat1Ampere"].setColor(0.7333,0.3803,0);
			} else {
				me["Bat1Ampere"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.Bat1.direction.getValue() == 0) {
				me["BAT1-discharge"].hide();
				me["BAT1-charge"].hide();
			} else {
				if (systems.ELEC.Source.Bat1.direction.getValue() == -1) {
					me["BAT1-charge"].show();
					me["BAT1-discharge"].hide();
				} else {
					me["BAT1-discharge"].show();
					me["BAT1-charge"].hide();
				}
			}
		}

		if (systems.ELEC.Light.bat1Fault.getValue() or systems.ELEC.Source.Bat1.volt.getValue() < 25 or systems.ELEC.Source.Bat1.volt.getValue() > 31 or systems.ELEC.Source.Bat1.amps.getValue() > 5) {
			me["BAT1-label"].setColor(0.7333,0.3803,0);
		} else {
			me["BAT1-label"].setColor(0.8078,0.8039,0.8078);
		}

		# BAT2
		if (systems.ELEC.Switch.bat2.getValue() == 0) {
			me["BAT2-OFF"].show();
			me["BAT2-content"].hide();
			me["BAT2-discharge"].hide();
			me["BAT2-charge"].hide();
		} else {
			me["BAT2-OFF"].hide();
			me["BAT2-content"].show();
			me["Bat2Ampere"].setText(sprintf("%s", math.round(systems.ELEC.Source.Bat2.amps.getValue())));
			me["Bat2Volt"].setText(sprintf("%s", math.round(systems.ELEC.Source.Bat2.volt.getValue())));

			if (systems.ELEC.Source.Bat2.volt.getValue() >= 24.95 and systems.ELEC.Source.Bat2.volt.getValue() <= 31.05) {
				me["Bat2Volt"].setColor(0.0509,0.7529,0.2941);
			} else {
				me["Bat2Volt"].setColor(0.7333,0.3803,0);
			}

			if (systems.ELEC.Source.Bat2.amps.getValue() > 5) {
				me["Bat2Ampere"].setColor(0.7333,0.3803,0);
			} else {
				me["Bat2Ampere"].setColor(0.0509,0.7529,0.2941);
			}
			
			if (systems.ELEC.Source.Bat2.direction.getValue() == 0) {
				me["BAT2-discharge"].hide();
				me["BAT2-charge"].hide();
			} else {
				if (systems.ELEC.Source.Bat2.direction.getValue() == -1) {
					me["BAT2-charge"].show();
					me["BAT2-discharge"].hide();
				} else {
					me["BAT2-discharge"].show();
					me["BAT2-charge"].hide();
				}
			}
		}

		if (systems.ELEC.Light.bat2Fault.getValue() or systems.ELEC.Source.Bat2.volt.getValue() < 25 or systems.ELEC.Source.Bat2.volt.getValue() > 31 or systems.ELEC.Source.Bat2.amps.getValue() > 5) {
			me["BAT2-label"].setColor(0.7333,0.3803,0);
		} else {
			me["BAT2-label"].setColor(0.8078,0.8039,0.8078);
		}

		# TR1
		# is only powered when ac1 has power
		tr1_v = systems.ELEC.Source.tr1.outputVolt.getValue();
		tr1_a = systems.ELEC.Source.tr1.outputAmp.getValue();

		me["TR1Volt"].setText(sprintf("%s", math.round(tr1_v)));
		me["TR1Ampere"].setText(sprintf("%s", math.round(tr1_a)));

		if (tr1_v < 25 or tr1_v > 31 or tr1_a < 5) {
			me["TR1-label"].setColor(0.7333,0.3803,0);
		} else {
			me["TR1-label"].setColor(0.8078,0.8039,0.8078);
		}

		if (tr1_v < 25 or tr1_v > 31) {
			me["TR1Volt"].setColor(0.7333,0.3803,0);
		} else {
			me["TR1Volt"].setColor(0.0509,0.7529,0.2941);
		}

		if (tr1_a < 5) {
			me["TR1Ampere"].setColor(0.7333,0.3803,0);
		} else {
			me["TR1Ampere"].setColor(0.0509,0.7529,0.2941);
		}

		# TR2
		# is only powered when ac2 has power
		tr2_v = systems.ELEC.Source.tr2.outputVolt.getValue();
		tr2_a = systems.ELEC.Source.tr2.outputAmp.getValue();

		me["TR2Volt"].setText(sprintf("%s", math.round(tr2_v)));
		me["TR2Ampere"].setText(sprintf("%s", math.round(tr2_a)));

		if (tr2_v < 25 or tr2_v > 31 or tr2_a < 5) {
			me["TR2-label"].setColor(0.7333,0.3803,0);
		} else {
			me["TR2-label"].setColor(0.8078,0.8039,0.8078);
		}

		if (tr2_v < 25 or tr2_v > 31) {
			me["TR2Volt"].setColor(0.7333,0.3803,0);
		} else {
			me["TR2Volt"].setColor(0.0509,0.7529,0.2941);
		}

		if (tr2_a < 5) {
			me["TR2Ampere"].setColor(0.7333,0.3803,0);
		} else {
			me["TR2Ampere"].setColor(0.0509,0.7529,0.2941);
		}

		# ESS TR
		essTrvolts = systems.ELEC.Source.trEss.outputVoltRelay.getValue();
		essTramps = systems.ELEC.Source.trEss.outputAmpRelay.getValue();
		if (systems.ELEC.Relay.essTrContactor.getValue()) {
			me["ESSTR-group"].show();
			me["ESSTR-Volt"].setText(sprintf("%s", math.round(essTrvolts)));
			me["ESSTR-Ampere"].setText(sprintf("%s", math.round(essTramps)));
			
			if (essTrvolts < 25 or essTrvolts > 31 or essTramps < 5) {
				me["ESSTR"].setColor(0.7333,0.3803,0);
			} else {
				me["ESSTR"].setColor(0.8078,0.8039,0.8078);
			}
			
			if (essTrvolts < 25 or essTrvolts > 31) {
				me["ESSTR-Volt"].setColor(0.7333,0.3803,0);
			} else {
				me["ESSTR-Volt"].setColor(0.0509,0.7529,0.2941);
			}
			
			if (essTramps < 5) {
				me["ESSTR-Ampere"].setColor(0.7333,0.3803,0);
			} else {
				me["ESSTR-Ampere"].setColor(0.0509,0.7529,0.2941);
			}
		} else {
			me["ESSTR-group"].hide();
		}

		# EMER GEN
		if (systems.ELEC.Source.EmerGen.volts.getValue() == 0) {
			me["EMERGEN-group"].hide();
			me["ELEC-Line-Emergen-ESSTR"].hide();
			me["ELEC-Line-Emergen-ESSTR-off"].show();
			me["EMERGEN-Label-off"].show();
		} else {
			me["EMERGEN-group"].show();
			me["ELEC-Line-Emergen-ESSTR"].show();
			me["ELEC-Line-Emergen-ESSTR-off"].hide();
			me["EMERGEN-Label-off"].hide();
			
			me["EmergenVolt"].setText(sprintf("%s", math.round(systems.ELEC.Source.EmerGen.voltsRelay.getValue())));
			me["EmergenHz"].setText(sprintf("%s", math.round(systems.ELEC.Source.EmerGen.hertz.getValue())));
			
			if (systems.ELEC.Source.EmerGen.voltsRelay.getValue() > 120 or systems.ELEC.Source.EmerGen.voltsRelay.getValue() < 110 or systems.ELEC.Source.EmerGen.hertz.getValue() > 410 or systems.ELEC.Source.EmerGen.hertz.getValue() < 390) {
				me["Emergen-Label"].setColor(0.7333,0.3803,0);
			} else {
				me["Emergen-Label"].setColor(0.8078,0.8039,0.8078);
			}

			if (systems.ELEC.Source.EmerGen.voltsRelay.getValue() > 120 or systems.ELEC.Source.EmerGen.voltsRelay.getValue() < 110) {
				me["EmergenVolt"].setColor(0.7333,0.3803,0);
			} else {
				me["EmergenVolt"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.EmerGen.hertz.getValue() > 410 or systems.ELEC.Source.EmerGen.hertz.getValue() < 390) {
				me["EmergenHz"].setColor(0.7333,0.3803,0);
			} else {
				me["EmergenHz"].setColor(0.0509,0.7529,0.2941);
			}
		}
		
		# IDG 1
		if (!systems.ELEC.Switch.idg1Disc.getBoolValue()) {
			me["IDG1-DISC"].show();
			me["ELEC-IDG-1-label"].setColor(0.7333,0.3803,0);
		} else {
			me["IDG1-DISC"].hide();
			me["ELEC-IDG-1-label"].setColor(0.8078,0.8039,0.8078);
		}

		if (eng1_running.getValue() == 0) {
			me["ELEC-IDG-1-num-label"].setColor(0.7333,0.3803,0);
		} else {
			me["ELEC-IDG-1-num-label"].setColor(0.8078,0.8039,0.8078);
		}
		
		if (eng2_running.getValue() == 0) {
			me["ELEC-IDG-2-num-label"].setColor(0.7333,0.3803,0);
		} else {
			me["ELEC-IDG-2-num-label"].setColor(0.8078,0.8039,0.8078);
		}
			
		# IDG 2
		if (!systems.ELEC.Switch.idg2Disc.getBoolValue()) {
			me["IDG2-DISC"].show();
			me["ELEC-IDG-2-label"].setColor(0.7333,0.3803,0);
		} else {
			me["IDG2-DISC"].hide();
			me["ELEC-IDG-2-label"].setColor(0.8078,0.8039,0.8078);
		}
		
		# GEN1
		if (systems.ELEC.Switch.gen1.getValue() == 0) {
			me["GEN1-content"].hide();
			me["GEN1-off"].show();
			if (systems.ELEC.Source.IDG1.gcrRelay.getValue()) {
				me["GEN1-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN1-label"].setColor(0.8078,0.8039,0.8078);
			}

			if (eng1_running.getValue() == 0) {
				me["GEN1-num-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN1-num-label"].setColor(0.8078,0.8039,0.8078);
			}
		} else {
			me["GEN1-content"].show();
			me["GEN1-off"].hide();
			# me["Gen1Load"].setText(sprintf("%s", math.round(gen1_load.getValue())));
			me["Gen1Volt"].setText(sprintf("%s", math.round(systems.ELEC.Source.IDG1.volts.getValue())));

			if (systems.ELEC.Source.IDG1.hertz.getValue() == 0) {
				me["Gen1Hz"].setText(sprintf("XX"));
			} else {
				me["Gen1Hz"].setText(sprintf("%s", math.round(systems.ELEC.Source.IDG1.hertz.getValue())));
			}

			if (eng1_running.getValue() == 0) {
				me["GEN1-num-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN1-num-label"].setColor(0.8078,0.8039,0.8078);
			}

			if (systems.ELEC.Source.IDG1.volts.getValue() > 120 or systems.ELEC.Source.IDG1.volts.getValue() < 110 or systems.ELEC.Source.IDG1.hertz.getValue() > 410 or systems.ELEC.Source.IDG1.hertz.getValue() < 390 or gen1_load.getValue() >= 110) {
				me["GEN1-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN1-label"].setColor(0.8078,0.8039,0.8078);
			}

			if (gen1_load.getValue() >= 110) {
				me["Gen1Load"].setColor(0.7333,0.3803,0);
			} else {
				me["Gen1Load"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.IDG1.volts.getValue() > 120 or systems.ELEC.Source.IDG1.volts.getValue() < 110) {
				me["Gen1Volt"].setColor(0.7333,0.3803,0);
			} else {
				me["Gen1Volt"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.IDG1.hertz.getValue() > 410 or systems.ELEC.Source.IDG1.hertz.getValue() < 390) {
				me["Gen1Hz"].setColor(0.7333,0.3803,0);
			} else {
				me["Gen1Hz"].setColor(0.0509,0.7529,0.2941);
			}
		}

		# GEN2
		if (systems.ELEC.Switch.gen2.getValue() == 0) {
			me["GEN2-content"].hide();
			me["GEN2-off"].show();
			if (systems.ELEC.Source.IDG2.gcrRelay.getValue()) {
				me["GEN2-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN2-label"].setColor(0.8078,0.8039,0.8078);
			}

			if (eng2_running.getValue() == 0) {
				me["GEN2-num-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN2-num-label"].setColor(0.8078,0.8039,0.8078);
			}
		} else {
			me["GEN2-content"].show();
			me["GEN2-off"].hide();
			# me["Gen2Load"].setText(sprintf("%s", math.round(gen2_load.getValue())));
			me["Gen2Volt"].setText(sprintf("%s", math.round(systems.ELEC.Source.IDG2.volts.getValue())));
			if (systems.ELEC.Source.IDG2.hertz.getValue() == 0) {
				me["Gen2Hz"].setText(sprintf("XX"));
			} else {
				me["Gen2Hz"].setText(sprintf("%s", math.round(systems.ELEC.Source.IDG2.hertz.getValue())));
			}

			if (eng2_running.getValue() == 0) {
				me["GEN2-num-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN2-num-label"].setColor(0.8078,0.8039,0.8078);
			}

			if (systems.ELEC.Source.IDG2.volts.getValue() > 120 or systems.ELEC.Source.IDG2.volts.getValue() < 110 or systems.ELEC.Source.IDG2.hertz.getValue() > 410 or systems.ELEC.Source.IDG2.hertz.getValue() < 390 or gen2_load.getValue() >= 110) {
				me["GEN2-label"].setColor(0.7333,0.3803,0);
			} else {
				me["GEN2-label"].setColor(0.8078,0.8039,0.8078);
			}

			if (gen2_load.getValue() >= 110) {
				me["Gen2Load"].setColor(0.7333,0.3803,0);
			} else {
				me["Gen2Load"].setColor(0.0509,0.7529,0.2941);
			}


			if (systems.ELEC.Source.IDG2.volts.getValue() > 120 or systems.ELEC.Source.IDG2.volts.getValue() < 110) {
				me["Gen2Volt"].setColor(0.7333,0.3803,0);
			} else {
				me["Gen2Volt"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.IDG2.hertz.getValue() > 410 or systems.ELEC.Source.IDG2.hertz.getValue() < 390) {
				me["Gen2Hz"].setColor(0.7333,0.3803,0);
			} else {
				me["Gen2Hz"].setColor(0.0509,0.7529,0.2941);
			}
		}

		# APU
		if (systems.APUNodes.Controls.master.getValue() == 0) {
			me["APU-content"].hide();
			me["APUGEN-off"].hide();
			me["APU-border"].hide();
			me["APUGentext"].setColor(0.8078,0.8039,0.8078);
		} else {
			me["APU-border"].show();
			if (systems.ELEC.Source.APU.contact.getValue() == 0) {
				me["APU-content"].hide();
				me["APUGEN-off"].show();
				me["APUGentext"].setColor(0.7333,0.3803,0);
			} else {
				me["APU-content"].show();
				me["APUGEN-off"].hide();
				# me["APUGenLoad"].setText(sprintf("%s", math.round(apu_load.getValue())));
				me["APUGenVolt"].setText(sprintf("%s", math.round(systems.ELEC.Source.APU.volts.getValue())));

				if (systems.ELEC.Source.APU.hertz.getValue() == 0) {
					me["APUGenHz"].setText(sprintf("XX"));
				} else {
					me["APUGenHz"].setText(sprintf("%s", math.round(systems.ELEC.Source.APU.hertz.getValue())));
				}

				if (systems.ELEC.Source.APU.volts.getValue() > 120 or systems.ELEC.Source.APU.volts.getValue() < 110 or systems.ELEC.Source.APU.hertz.getValue() > 410 or systems.ELEC.Source.APU.hertz.getValue() < 390 or apu_load.getValue() >= 110) {
					me["APUGentext"].setColor(0.7333,0.3803,0);
				} else {
					me["APUGentext"].setColor(0.8078,0.8039,0.8078);
				}

				if(apu_load.getValue() >= 110) {
					me["APUGenLoad"].setColor(0.7333,0.3803,0);
				} else {
					me["APUGenLoad"].setColor(0.0509,0.7529,0.2941);
				}

				if (systems.ELEC.Source.APU.volts.getValue() > 120 or systems.ELEC.Source.APU.volts.getValue() < 110) {
					me["APUGenVolt"].setColor(0.7333,0.3803,0);
				} else {
					me["APUGenVolt"].setColor(0.0509,0.7529,0.2941);
				}

				if (systems.ELEC.Source.APU.hertz.getValue() > 410 or systems.ELEC.Source.APU.hertz.getValue() < 390) {
					me["APUGenHz"].setColor(0.7333,0.3803,0);
				} else {
					me["APUGenHz"].setColor(0.0509,0.7529,0.2941);
				}
			}
		}

		# EXT PWR

		if (switch_cart.getValue() == 0) {
			me["EXTPWR-group"].hide();
		} else {
			me["EXTPWR-group"].show();
			me["ExtVolt"].setText(sprintf("%s", math.round(systems.ELEC.Source.Ext.volts.getValue())));
			me["ExtHz"].setText(sprintf("%s", math.round(systems.ELEC.Source.Ext.hertz.getValue())));

			if (systems.ELEC.Source.Ext.hertz.getValue() > 410 or systems.ELEC.Source.Ext.hertz.getValue() < 390 or systems.ELEC.Source.Ext.volts.getValue() > 120 or systems.ELEC.Source.Ext.volts.getValue() < 110) {
				me["EXTPWR-label"].setColor(0.7333,0.3803,0);
			} else {
				me["EXTPWR-label"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.Ext.hertz.getValue() > 410 or systems.ELEC.Source.Ext.hertz.getValue() < 390) {
				me["ExtHz"].setColor(0.7333,0.3803,0);
			} else {
				me["ExtHz"].setColor(0.0509,0.7529,0.2941);
			}

			if (systems.ELEC.Source.Ext.volts.getValue() > 120 or systems.ELEC.Source.Ext.volts.getValue() < 110) {
				me["ExtVolt"].setColor(0.7333,0.3803,0);
			} else {
				me["ExtVolt"].setColor(0.0509,0.7529,0.2941);
			}
		}

		if (systems.ELEC.SomeThing.galley.getValue()) {
			me["GalleyShed"].show();
		} else {
			me["GalleyShed"].hide();
		}

		# Bus indicators
		if (systems.ELEC.Switch.bat1.getValue() or systems.ELEC.Switch.bat2.getValue()) {
			me["ELEC-DCBAT-label"].setText("DC BAT");
			if (systems.ELEC.Bus.dcBat.getValue() > 25) {
				me["ELEC-DCBAT-label"].setColor(0.0509,0.7529,0.2941);
			} else {
				me["ELEC-DCBAT-label"].setColor(0.7333,0.3803,0);
			}
		} else {
			me["ELEC-DCBAT-label"].setText("XX"); # BCL not powered hence no voltage info supplied from BCL
			me["ELEC-DCBAT-label"].setColor(0.7333,0.3803,0);
		}

		if (systems.ELEC.Bus.dc1.getValue() > 25) {
			me["ELEC-DC1-label"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ELEC-DC1-label"].setColor(0.7333,0.3803,0);
		}

		if (systems.ELEC.Bus.dc2.getValue() > 25) {
			me["ELEC-DC2-label"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ELEC-DC2-label"].setColor(0.7333,0.3803,0);
		}

		if (systems.ELEC.Bus.dcEss.getValue() > 25) {
			me["ELEC-DCESS-label"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ELEC-DCESS-label"].setColor(0.7333,0.3803,0);
		}

		if (systems.ELEC.Bus.acEss.getValue() >= 110) {
			me["ELEC-ACESS-label"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ELEC-ACESS-label"].setColor(0.7333,0.3803,0);
		}

		if (systems.ELEC.Bus.acEssShed.getValue() >= 110) {
			me["ACESS-SHED"].hide();
		} else {
			me["ACESS-SHED"].show();
		}

		if (systems.ELEC.Bus.ac1.getValue() >= 110) {
			me["ELEC-AC1-label"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ELEC-AC1-label"].setColor(0.7333,0.3803,0);
		}

		if (systems.ELEC.Bus.ac2.getValue() >= 110) {
			me["ELEC-AC2-label"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["ELEC-AC2-label"].setColor(0.7333,0.3803,0);
		}


		# Managment of the connecting lines between the components
		if (systems.ELEC.Relay.apuGlc.getValue() and (systems.ELEC.Relay.acTie1.getValue() or systems.ELEC.Relay.acTie2.getValue())) {
			me["APU-out"].show();
		} else {
			me["APU-out"].hide();
		}

		if (systems.ELEC.Relay.extEpc.getValue() and (systems.ELEC.Relay.acTie1.getValue() or systems.ELEC.Relay.acTie2.getValue())) {
			me["EXT-out"].show();
		} else {
			me["EXT-out"].hide();
		}

		if (systems.ELEC.Source.IDG1.volts.getValue() >= 110 and systems.ELEC.Relay.glc1.getValue()) {
			me["ELEC-Line-GEN1-AC1"].show();
		} else {
			me["ELEC-Line-GEN1-AC1"].hide();
		}

		if (systems.ELEC.Source.IDG2.volts.getValue() >= 110 and systems.ELEC.Relay.glc2.getValue()) {
			me["ELEC-Line-GEN2-AC2"].show();
		} else {
			me["ELEC-Line-GEN2-AC2"].hide();
		}

		if (systems.ELEC.Bus.ac1.getValue() >= 110) {
			me["AC1-in"].show();
		} else {
			me["AC1-in"].hide();
		}

		if (systems.ELEC.Bus.ac2.getValue() >= 110) {
			me["AC2-in"].show();
		} else {
			me["AC2-in"].hide();
		}

		if (systems.ELEC.Relay.acTie1.getValue() and systems.ELEC.Relay.acTie2.getValue()) {
			me["ELEC-Line-APU-AC1"].show();
			me["ELEC-Line-APU-EXT"].show();
			me["ELEC-Line-EXT-AC2"].show();
		} else {
			if (systems.ELEC.Relay.acTie1.getValue()) {
				me["ELEC-Line-APU-AC1"].show();
			} else {
				me["ELEC-Line-APU-AC1"].hide();
			}
			
			if ((systems.ELEC.Relay.acTie2.getValue() and systems.ELEC.Relay.apuGlc.getValue() and !systems.ELEC.Relay.glc2.getValue()) or (systems.ELEC.Relay.acTie1.getValue() and systems.ELEC.Relay.extEpc.getValue() and !systems.ELEC.Relay.glc1.getValue())) {
				me["ELEC-Line-APU-EXT"].show();
			} else {
				me["ELEC-Line-APU-EXT"].hide();
			}
			
			if (systems.ELEC.Relay.acTie2.getValue()) {
				me["ELEC-Line-EXT-AC2"].show();
			} else {
				me["ELEC-Line-EXT-AC2"].hide();
			}
		}

		if (systems.ELEC.Relay.acEssFeed1.getValue()) {
			if (systems.ELEC.Bus.ac1.getValue() >= 110) {
				me["ELEC-Line-AC1-ACESS"].show();
			} else {
				me["ELEC-Line-AC1-ACESS"].hide();
			}
			me["ELEC-Line-AC2-ACESS"].hide();
		} elsif (systems.ELEC.Relay.acEssFeed2.getValue()) {
			me["ELEC-Line-AC1-ACESS"].hide();
			if (systems.ELEC.Bus.ac2.getValue() >= 110) {
				me["ELEC-Line-AC2-ACESS"].show();
			} else {
				me["ELEC-Line-AC2-ACESS"].hide();
			}
		} else {
			me["ELEC-Line-AC1-ACESS"].hide();
			me["ELEC-Line-AC2-ACESS"].hide();
		}

		if (systems.ELEC.Relay.tr1Contactor.getValue()) {
			if (systems.ELEC.Bus.ac1.getValue() < 110) {
				me["ELEC-Line-AC1-TR1"].setColorFill(0.7333,0.3803,0);
			} else {
				me["ELEC-Line-AC1-TR1"].setColorFill(0.0509,0.7529,0.2941);
			}
			me["ELEC-Line-AC1-TR1"].show();
			me["ELEC-Line-TR1-DC1"].show();
		} else {
			me["ELEC-Line-AC1-TR1"].hide();
			me["ELEC-Line-TR1-DC1"].hide();
		}

		if (systems.ELEC.Relay.tr2Contactor.getValue()) {
			if (systems.ELEC.Bus.ac2.getValue() < 110) {
				me["ELEC-Line-AC2-TR2"].setColorFill(0.7333,0.3803,0);
			} else {
				me["ELEC-Line-AC2-TR2"].setColorFill(0.0509,0.7529,0.2941);
			}
			me["ELEC-Line-AC2-TR2"].show();
			me["ELEC-Line-TR2-DC2"].show();
		} else {
			me["ELEC-Line-AC2-TR2"].hide();
			me["ELEC-Line-TR2-DC2"].hide();
		}
		
		if (systems.ELEC.Relay.dcTie1.getValue()) {
			me["ELEC-Line-DC1-DCESS_DCBAT"].show();
		} else {
			me["ELEC-Line-DC1-DCESS_DCBAT"].hide();
		}
		
		if (systems.ELEC.Relay.dcEssFeedBat.getValue()) {
			me["ELEC-Line-DC1-DCESS"].show();
		} else {
			me["ELEC-Line-DC1-DCESS"].hide();
		}
		
		if (systems.ELEC.Relay.dcEssFeedBat.getValue() or systems.ELEC.Relay.dcTie1.getValue()) {
			me["ELEC-Line-DC1-DCBAT"].show();
		} else {
			me["ELEC-Line-DC1-DCBAT"].hide();
		}
		
		if (systems.ELEC.Relay.dcTie2.getValue()) {
			me["ELEC-Line-DC2-DCBAT"].show();
			me["ELEC-Line-DC2-DCESS_DCBAT"].show();
		} else {
			me["ELEC-Line-DC2-DCBAT"].hide();
			me["ELEC-Line-DC2-DCESS_DCBAT"].hide();
		}
		
		if (systems.ELEC.Relay.acEssEmerGenFeed.getValue()) {
			me["EMERGEN-out"].show();
			me["ELEC-Line-Emergen-ESSTR"].show();
		} else {
			me["EMERGEN-out"].hide();
			me["ELEC-Line-Emergen-ESSTR"].hide();
		}
		
		if (systems.ELEC.Bus.acEss.getValue() >= 110 and !systems.ELEC.Relay.acEssEmerGenFeed.getValue() and (!systems.ELEC.Relay.tr1Contactor.getValue() or !systems.ELEC.Relay.tr2Contactor.getValue())) {
			me["ELEC-Line-ACESS-TRESS"].show();
		} else {
			me["ELEC-Line-ACESS-TRESS"].hide();
		}
		
		if (systems.ELEC.Relay.essTrContactor.getValue()) {
			me["ELEC-Line-ESSTR-DCESS"].show();
		} else {
			me["ELEC-Line-ESSTR-DCESS"].hide();
		}
		
		# hide not yet implemented items
		me["IDG1-LOPR"].hide();
		me["IDG2-LOPR"].hide();
		me["Shed-label"].hide();
		me["IDG2-RISE-label"].hide();
		me["IDG2-RISE-Value"].hide();
		me["IDG1-RISE-label"].hide();
		me["IDG1-RISE-Value"].hide();

		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_eng = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_eng, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","UTCh","UTCm","GLoad","GW-weight-unit",];
	},
	update: func() {
		# Oil Quantity
		

		# Oil Pressure
		

		# Fuel Used
		if (acconfig_weight_kgs.getValue()) {
		} else {
		}
		
		me.updateBottomStatus();
	},
};
		