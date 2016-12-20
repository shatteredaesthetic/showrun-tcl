#!/usr/bin/tclsh
#
# QCLEANASSETS
#
# arg 1 : flag, where flag is
#       -A, -P
# arg 2 : root of Project
#

package provide qCleanAssets 1.0

# Utilities

proc comp {f g x} { $f [$g $x] }

proc fst tup { return [lindex $tup 0] }
proc snd tup { return [lindex $tup 1] }

proc ldiff {a b} {
    set result [list]
    foreach e $a {
        if {$e ni $b} { lappend result $e }
    }
    return $result
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

# Getting Asset List

proc getScript _args {
    set root [snd $_args]
    switch [fst $_args] {
	-A { set path "Audio" }
	-P { set path "Proj" }
    }
    set name [join [list make $path List_qlab.scpt] ""]
    set fp [file join $root .scripts $name]
    exec osascript $fp
    return [list $root $path]
}

proc getAssetList tup {
    set name [join [list q [snd $tup] List.txt] ""]
    set fp [file join [fst $tup] .tmp $name]
    return [split [read [open $fp r]] \n]
}

interp alias {} getQlabList {} comp getAssetList getScript

# Getting Files List

proc getFolderFiles _args {
    set root [snd $_args]
    switch [fst $_args] {
	-A { set path "sound" }
	-P { set path "projections" }
    }
    return [getFiles [file join $root $path]]
}

# Main

namespace eval ::Showrun::Qcleanassets {
    namespace export main
    proc main _args {
        set dir [file mkdir [file join ~/Desktop/toArchive sounds]]
        set ffiles [getFolderFiles $_args]
        set qfiles [getQlabList $_args]
        set diffs [ldiffs $ffiles $qfiles]
        foreach f $diffs {
	    file rename $f [file join $dir [file tail $f]]
        }
    }
}
