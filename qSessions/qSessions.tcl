#!/usr/bin/tclsh
#
#  QSESSIONS
#
# arg 1 : flag, where flag is
#       -P , -a , -b , -c, or 0
# arg 2 : root of Project
#

package provide qSessions 1.0

# Utilities

proc comp {f g x} {$f [$g $x]}
proc splitLines f { return [split [read [open $f r]] \n] }

proc fileCompare {f1 f2} {
    set t1 [file mtime $f1]
    set t2 [file mtime $f2]
    return [expr $t1 >= $t2 ? -1: 1]
}

# Getting/Sorting Sessions

proc getSessions {path} { return [glob -directory $path *.cues] }

proc getLaterSessions {lst} {
    return [lrange [lsort -command fileCompare $lst] 1 end]
}

interp alias {} sortSessions {} comp getLaterSessions getSessions

proc setDestination {_args} {
    switch [lindex $_args 0] {
	-P {set path "<1.0.0"}
	-a {set path "Tech/1"}
	-b {set path "Tech/2"}
	-c {set path "Tech/3"}
	-0 {set path ""}
    }
    return [file join [lindex $_args 1] "sessions/previousSessions" $path]
}

# Main

namespace eval ::Showrun::Qsessions {
    namespace export main
    proc main _args {
        set dest [setDestination $_args]
        set oldSs [sortSessions [file join [lindex $_args 1] sessions]]
        foreach sess $oldSs {
	    file rename $sess [file join $dest [file tail $sess]]
        }
    }
}