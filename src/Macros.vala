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

    private bool isActive;
    public bool IsActive {
        get {
            return isActive;
        }
        set {
            isActive = value;
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
            Text = value;
        }
    }

    public Macro () {
        text = "";
        isHex = false;
        cycle = 1000;
        isActive = false;
    }
}

public class moserial.Macros : GLib.Object {
    public const int maxMacroCount = 24;
    private List<Macro> macros;

    public Macros () {
        macros = new List<Macro>();
        for (int i = 0; i < maxMacroCount; i++) {
            macros.append (new Macro ());
        }
    }

    public void SetActive (int index, bool active) {
        macros.nth_data (index).IsActive = active;
    }

    public bool GetActive (int index) {
        return macros.nth_data (index).IsActive;
    }

    public void SetHex (int index, bool hex) {
        macros.nth_data (index).IsHex = hex;
    }

    public bool GetHex (int index) {
        return macros.nth_data (index).IsHex;
    }

    public void SetCycle (int index, int cycle) {
        macros.nth_data (index).Cycle = cycle;
    }

    public int GetCycle (int index) {
        return macros.nth_data (index).Cycle;
    }

    public void SetText (int index, string text) {
        macros.nth_data (index).Text = text;
    }

    public string GetText (int index) {
        return macros.nth_data (index).Text;
    }
}