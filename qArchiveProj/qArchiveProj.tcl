#!/usr/bin/tclsh
#
# ARCHIVEPROJECT
#
# arg : root of Project
#

package provide qArchiveProj 1.0

proc filter {lst script} {
    set res {}
    foreach e $lst {if {[uplevel 1 $script $e]} {lappend res $e}}
    set res
}

proc map {fun list} {
    set res {}
    foreach element $list {lappend res [$fun $element]}
    set res
}

proc getFiles dir {
    set files ""
    set contents [glob -nocomplain -directory $dir *]
    foreach item $contents {
        if { [file isdirectory $item] } {
            getfiles $item
        } elseif { [file isfile $item]} {
            append f [format "%s\n" $item]
        }
    }
}

proc stripExt fp { return [string replace $fp end-5 end ""] }
proc fsrepl str { return [expr [string index $str end] == 0] }
proc addExt p { return [append $p .cues] }

proc cleanPatches root {
    set files [getFiles [file join $root sessions/previousSessions]]
    set lst [map stripExt $files]
    set patches [map addExt [filter $lst fsrepl]]
    foreach p $patches { file delete -force $p }
    return 0
}

# Main

namespace eval ::Showrun::Qarchiveproj {
    namespace export main
    proc main _argv {
        set root [lindex $_argv 0]
        set archive [string cat [file tail $root] .tar.gz]
        cleanPatches $root
        exec tar -cvzf $archive $root
        return 0
    }
}