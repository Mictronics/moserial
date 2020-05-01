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
        window.destroy.connect (OnWindowDestroy);

        Entry inp;
        SpinButton cb;
        Switch sw;
        ToggleButton tb;
        Button btn;
        for (int i = 0; i < Macros.maxMacroCount; i++) {
            // Init all text input fields
            inp = (Entry) builder.get_object ("inputMacro%i".printf (i + 1));
            inp.set_tooltip_text (_("Enter macro text and press ENTER to activate your input."));
            inp.set_text (this.macros.GetText (i));
            inp.activate.connect (OnTextChanged);
            // Init all cycle spinners
            cb = (SpinButton) builder.get_object ("cycleMacro%i".printf (i + 1));
            cb.adjustment.lower = 1;
            cb.adjustment.upper = 10000;
            cb.adjustment.step_increment = 1;
            cb.adjustment.page_increment = 100;
            cb.set_value (this.macros.GetCycle (i));
            cb.value_changed.connect (OnCycleButtonChanged);
            // Init all activate switched
            sw = (Switch) builder.get_object ("activateMacro%i".printf (i + 1));
            sw.set_tooltip_text (_("Toggle cyclic macro transmission."));
            sw.set_state (this.macros.GetActive (i));
            sw.set_active (this.macros.GetActive (i));
            sw.state_set.connect (OnActiveSwitchChanged);
            // Init all hex checkboxes
            tb = (ToggleButton) builder.get_object ("isHex%i".printf (i + 1));
            tb.set_active (this.macros.GetHex (i));
            tb.toggled.connect (OnHexToggled);
            // Init all send buttons
            btn = (Button) builder.get_object ("buttonMacro%i".printf (i + 1));
            btn.clicked.connect (OnSendButtonClick);
        }

        window.show_all ();
    }

    public void SetCycleButton (int number, int val) {
        ((SpinButton) builder.get_object ("cycleMacro%i".printf (number))).value = val;
    }

    public void SetActive (int number, bool val) {
        Switch sw = (Switch) builder.get_object ("activeMacro%i".printf (number));
        sw.set_active (val);
        sw.set_state (val);
    }

    private void OnWindowDestroy (Widget w) {
        GLib.print ("Window closing\n\r");
    }

    private void OnCycleButtonChanged (SpinButton btn) {
        this.macros.SetCycle (int.parse (btn.get_name ().splice (0, 10)), btn.get_value_as_int ());
    }

    private bool OnActiveSwitchChanged (Switch sw, bool state) {
        this.macros.SetActive (int.parse (sw.get_name ().splice (0, 13)), state);
        return false;
    }

    private void OnHexToggled (ToggleButton tb) {
        this.macros.SetHex (int.parse (tb.get_name ().splice (0, 5)), tb.get_active ());
    }

    private void OnTextChanged (Entry inp) {
        this.macros.SetText (int.parse (inp.get_name ().splice (0, 10)), inp.get_text ());
    }

    private void OnSendButtonClick (Button btn) {
        GLib.print (btn.get_name ());
    }
}