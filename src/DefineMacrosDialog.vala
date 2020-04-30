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

    public DefineMacrosDialog (Window parent) {
        this.parent = parent;
        var builder = new Gtk.Builder.from_resource (Config.UIROOT + "macro_dialog.ui");
        var window = (Window) builder.get_object ("macro_window");
        window.set_transient_for (parent);
        window.show_all ();
    }
}