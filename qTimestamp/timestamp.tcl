#!/usr/bin/tclsh

package provide Qtimestamp 1.0

source "timestamp_helpers.tcl"
source "timestamp_email.tcl"

proc getTimes cfg {
    set log [list]
    set tags [split [lindex $cfg 3] |]
    foreach tag $tags {
	puts -nonewline "> "
	flush stdout
	gets stdin ans
	lappend log [logLine $tag]
	puts $log
    }
    return $log
}

proc setNewLine {idx oldL} {
    set line1 [split [lindex $oldL $idx] |]
    set line2 [split [lindex $oldL [expr $idx + 1]] |]
    set tag   [string cat [lindex $line1 0]]
    set t1    [lindex $line1 1]
    set t2    [lindex $line2 1]
    set start [formatTime $t1]
    set end   [formatTime $t2]
    set diff  [timeDiff $t1 $t2]
    if {[string length $tag] > 7} {set sep \t} else {set sep \t\t}
    return "$tag$sep$start\t$end\t$diff"
}

proc writeLog {root log} {
    set f [setLogFile $root]
    set fp [open $f w]
    set len [expr [llength $log] - 1]
    set header [list [join {Label Start End Duration} \t\t] [string repeat _ 54]]
    puts $fp [join $header \n]
    for {set i 0} {$i < $len} {incr i} {
	set line [setNewLine $i $log]
	puts $fp $line
	flush $fp
    }
    close $fp
    return $f
}

interp alias {} spitLog {} writeLog [lindex $argv 0]

interp alias {} timestamp {} comp spitLog getTimes

namespace eval ::Showrun::Qtimestamp {
    namespace export main
    proc main _argv {
        set root [lindex $_argv 0]
        set cfgLines [splitLines [file join $root .show_config]]
        set fp [timestamp $cfgLines]
        sendEmail $cfgLines $fp
        exit
    }
}