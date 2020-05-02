/*
 *  Copyright (C) 2020 Michael Wolf.
 *
 *  This file is part of moserial.
 *
 *  moserial is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  moserial is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with moserial.  If not, see <http://www.gnu.org/licenses/>.
 */

using Gtk;
public class moserial.DefineMacrosDialog : GLib.Object {

    private Window parent;
    private Gtk.Builder builder;
    private Macros macros;

    public DefineMacrosDialog (Window parent, Macros macros) {
        this.parent = parent;
        this.macros = macros;
        builder = new Gtk.Builder.from_resource (Config.UIROOT + "macro_dialog.ui");
        var window = (Window) builder.get_object ("macro_window");
        window.set_transient_for (parent);

        Entry inp;
        SpinButton cb;
        Switch sw;
        ToggleButton tb;
        Button btn;
        for (int i = 0; i < Macros.maxMacroCount; i++) {
            // Init all text input fields
            inp = (Entry) builder.get_object ("inputMacro%i".printf (i + 1));
            inp.set_tooltip_text (_("Enter macro text and press ENTER to activate your input."));
            inp.set_text (this.macros.getText (i));
            inp.activate.connect (onTextChanged);
            // Init all cycle spinners
            cb = (SpinButton) builder.get_object ("cycleMacro%i".printf (i + 1));
            cb.adjustment.lower = 1;
            cb.adjustment.upper = 10000;
            cb.adjustment.step_increment = 1;
            cb.adjustment.page_increment = 100;
            cb.set_value (this.macros.getCycle (i));
            cb.value_changed.connect (onCycleButtonChanged);
            // Init all activate switched
            sw = (Switch) builder.get_object ("activateMacro%i".printf (i + 1));
            sw.set_tooltip_text (_("Toggle cyclic macro transmission."));
            sw.set_state (this.macros.getActive (i));
            sw.set_active (this.macros.getActive (i));
            sw.state_set.connect (onActiveSwitchChanged);
            // Init all hex checkboxes
            tb = (ToggleButton) builder.get_object ("isHex%i".printf (i + 1));
            tb.set_active (this.macros.getHex (i));
            tb.toggled.connect (onHexToggled);
            // Init all send buttons
            btn = (Button) builder.get_object ("buttonMacro%i".printf (i + 1));
            btn.clicked.connect (onSendButtonClick);
        }

        window.show_all ();
    }

    public void setCycleButton (int number, int val) {
        ((SpinButton) builder.get_object ("cycleMacro%i".printf (number))).value = val;
    }

    public void setActive (int number, bool val) {
        Switch sw = (Switch) builder.get_object ("activeMacro%i".printf (number));
        sw.set_active (val);
        sw.set_state (val);
    }

    private void onCycleButtonChanged (SpinButton btn) {
        this.macros.setCycle (int.parse (btn.get_name ().splice (0, 10)) - 1, btn.get_value_as_int ());
    }

    private bool onActiveSwitchChanged (Switch sw, bool state) {
        this.macros.setActive (int.parse (sw.get_name ().splice (0, 13)) - 1, state);
        return false;
    }

    private void onHexToggled (ToggleButton tb) {
        this.macros.setHex (int.parse (tb.get_name ().splice (0, 5)) - 1, tb.get_active ());
    }

    private void onTextChanged (Entry inp) {
        this.macros.setText (int.parse (inp.get_name ().splice (0, 10)) - 1, inp.get_text ());
    }

    private void onSendButtonClick (Button btn) {
        this.macros.send (int.parse (btn.get_name ().splice (0, 11)) - 1);
    }
}