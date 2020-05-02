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

public class moserial.Macro : GLib.Object {
    private int index;
    private bool isActive;
    public bool IsActive {
        get {
            return isActive;
        }
        set {
            isActive = value;
            if (isActive) {
                GLib.Timeout.add (cycle, (GLib.SourceFunc)onCycleTimeout, Priority.DEFAULT);
            }
        }
    }

    private bool isHex;
    public bool IsHex {
        get {
            return isHex;
        }
        set {
            isHex = value;
        }
    }

    private int cycle;
    public int Cycle {
        get {
            return cycle;
        }
        set {
            cycle = value;
        }
    }

    private string text;
    public string Text {
        get {
            return text;
        }
        set {
            if (value == null) {
                text = "";
            } else {
                text = value;
            }
        }
    }

    public signal void sendMacro (int index);

    public Macro (int index) {
        this.index = index;
        text = "";
        isHex = false;
        cycle = 1000;
        isActive = false;
    }

    private bool onCycleTimeout () {
        // Trigger sending macro and keep cyclic timeout running.
        sendMacro (index);
        return isActive;
        // Returning false will cancel and destroy the timeout.
    }
}

public class moserial.Macros : GLib.Object {
    public const int maxMacroCount = 24;
    private List<Macro> macros;

    public Macros () {
        macros = new List<Macro>();
        for (int i = 0; i < maxMacroCount; i++) {
            macros.append (new Macro (i));
        }
    }

    public Macro getMacro (int index) {
        return macros.nth_data (index);
    }

    public void setActive (int index, bool active) {
        macros.nth_data (index).IsActive = active;
    }

    public bool getActive (int index) {
        return macros.nth_data (index).IsActive;
    }

    public void setHex (int index, bool hex) {
        macros.nth_data (index).IsHex = hex;
    }

    public bool getHex (int index) {
        return macros.nth_data (index).IsHex;
    }

    public void setCycle (int index, int cycle) {
        macros.nth_data (index).Cycle = cycle;
    }

    public int getCycle (int index) {
        return macros.nth_data (index).Cycle;
    }

    public void setText (int index, string text) {
        macros.nth_data (index).Text = text;
    }

    public string getText (int index) {
        return macros.nth_data (index).Text;
    }

    public void send (int index) {
        macros.nth_data (index).sendMacro (index);
    }

    public void saveToProfile (Profile profile) {
        for (int i = 0; i < maxMacroCount; i++) {
            string g = "macro%u".printf (i);
            profile.keyFile.set_boolean (g, "is_hex", macros.nth_data (i).IsHex);
            profile.keyFile.set_integer (g, "cycle", macros.nth_data (i).Cycle);
            profile.keyFile.set_string (g, "text", macros.nth_data (i).Text);
            // We don't save isActive here because macros shall be deactivated by default when application is loaded.
        }
    }

    public void loadFromProfile (Profile profile) {
        for (int i = 0; i < maxMacroCount; i++) {
            string g = "macro%u".printf (i);
            macros.nth_data (i).IsHex = MoUtils.getKeyBoolean (profile, g, "is_hex", false);
            macros.nth_data (i).Cycle = MoUtils.getKeyInteger (profile, g, "cycle", 1000);
            macros.nth_data (i).Text = MoUtils.getKeyString (profile, g, "text");
        }
    }
}