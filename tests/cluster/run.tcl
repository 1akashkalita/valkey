# Cluster test suite. Copyright (C) 2014 Redis Ltd.
# This software is released under the BSD License. See the COPYING file for
# more information.

cd tests/cluster
source cluster.tcl
source ../instances.tcl
source ../../support/cluster.tcl ; # Cluster client.

set ::instances_count 20 ; # How many instances we use at max.
set ::tlsdir "../../tls"

# Keep client ports and their default cluster-bus ports below Linux's
# default ephemeral-port range, including when a node is restarted.
set ::valkey_base_port 18000

proc main {} {
    parse_options
    spawn_instance valkey $::valkey_base_port $::instances_count {
        "cluster-enabled yes"
        "appendonly yes"
        "enable-protected-configs yes"
        "enable-debug-command yes"
        "save ''"
    }
    run_tests
    cleanup
    end_tests
}

if {[catch main e]} {
    puts $::errorInfo
    if {$::pause_on_error} pause_on_error
    cleanup
    exit 1
}
