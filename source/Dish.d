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
        string[] hist;
    }

    public {
        Command[string] commands;
    }

    this() {
        this.USER_NAME = environment["USER"];
        this.PATH = environment["PATH"].split(":");

        commands = [
            "prompt": Command("prompt", &this.prompt),
            "ls": Command("ls", &this.ls),
            "echo": Command("echo", &this.echo),
            "pwd": Command("pwd", &this.pwd),
            "cd": Command("cd", &this.cd),
            "exit": Command("exit", &this.exit),
            "hoge": Command("hoge", &this.hoge),
        ];
    }

    int prompt(string[] args) {
        (USER_NAME ~ " > ").write;
        return 1;
    }

    int ls(string[] args) {
        foreach(string e; dirEntries(getcwd, SpanMode.shallow)) {
            e.split("/")[$ - 1].writeln;
        }
        return 1;
    }

    int echo(string[] args) {
        // ex1. args[0] : "echo hoge"
        // ex2. args[0] : "echo $USER"

        string[] args_splited = args[0].split;
        string command = args_splited[0];
        if (args_splited[1][0] == '$') {
            if (args_splited[1][1..$] in environment) {
                environment[args_splited[1][1..$]].writeln;
            }
            else {
                "%s is not found.".writefln(args_splited[1]);
            }
        }
        else {
            foreach (i, e; args_splited[1..$]) {
                if (i != 0) {
                    " ".write;
                }
                e.write;
            }
            writeln;
        }
        return 1;
    }

    int pwd(string[] args) {
        string[] args_splited = args[0].split;
        if (args_splited[0] == "pwd" && args_splited.length == 1) {
            getcwd.writeln;
        }
        else {
            "pwd: expected 0 args. got %d".writefln(args_splited.length - 1);
        }
        return 1;
    }

    int cd(string[] args) {
        string[] args_splited = args[0].split;
        string command = args_splited[0];
        string[] command_args = args_splited[1..$];

        if (command_args.length == 1) {
            string dir_path;
            if (command_args[0][0] == '/') {
                dir_path = command_args[0];
            }
            else if (command_args[0][0] == '~') {
                if (command_args[0].length == 1) {
                    dir_path = "/Users/" ~ environment["USER"];
                }
                else {
                    dir_path = "/Users/" ~ environment["USER"] ~ command_args[0][1..$];
                }
            }
            else {
                dir_path = getcwd ~ "/" ~ command_args[0];
            }

            if (exists(dir_path)) {
                chdir(dir_path);
            }
            else {
                "cd: The directory '%s' does not exist".writefln(dir_path);
            }
        }
        else {
            "cd: expected 0 args. got %d".writefln(args_splited.length - 1);
        }
        return 1;
    }

    int exit(string[] args) {
        "see you again.".writeln;
        return 0;
    }

    int hoge(string[] args) {
        "hoge".writeln;
        return 1;
    }
}