proc comp {f g x} { $f [$g $x] }

proc splitLines f { return [split [read [open $f r]] \n] }

proc formatTime t { return [clock format [set t] -format "%T"] }

proc lzero n { return [format %02i $n] }

proc map {fun list} {
    set res {}
    foreach element $list {lappend res [$fun $element]}
    set res
}

proc convertSecs secs {
    set t [expr $secs % (24 * 60 * 60)]
    set h [expr ($t / (60 * 24)) % 24]
    set m [expr ($t / 60) % 60]
    set s [expr $t % 60]
    return [join [list [lzero $h] [lzero $m] [lzero $s]] :]
}

proc timeDiff {t1 t2} { return [convertSecs [expr $t2 - $t1]] }

proc setLogFile root {
    set d [clock format [clock seconds] -format "%D"]
    set dt [regsub -all {/} $d -]
    return [string cat $root /Times/Times_ $dt .txt]
}

proc logLine tag {
    set t [clock seconds]
    return [join [list $tag $t] |]
}