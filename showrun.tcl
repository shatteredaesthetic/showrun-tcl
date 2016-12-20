package require qSessions
package require qCleanAssets
package require qArchiveProj
package require qNewProj
package require qTimestamp

proc subcommands {cmd content} {
   array set a $content
   if [info exists a($cmd)] {
       return [uplevel 1 $a($cmd)]
   } else {
       set cmds [join [lsort [array names a]] ", "]
       set cmds [linsert $cmds end-1 or]
       return -code error "Bad option \"$cmd\": must be $cmds"
   }
}

namespace eval Showrun {
   