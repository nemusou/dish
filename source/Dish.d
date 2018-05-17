module Dish;

import std.stdio;
import std.conv;
import std.string;
import std.file;
import std.process;
import Command : Command;

class Dish {
    private {
        const string USER_NAME;
        const string[] PATH;
        string current_dir;
    }

    public {
        Command[string] commands;
    }

    this() {
        this.USER_NAME = environment["USER"];
        this.PATH = environment["PATH"].split(":");

        commands = [
            "ls": Command("ls", &this.ls),
        ];
    }

    int ls(string[] args) {
        foreach(string e; dirEntries(getcwd, SpanMode.shallow)) {
            e.split("/")[$ - 1].writeln;
        }
        return 1;
    }
}

void main() {
    Dish dish = new Dish();
    dish.commands["ls"].command([getcwd]);
}