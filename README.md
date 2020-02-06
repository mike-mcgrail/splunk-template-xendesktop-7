Splunk Template for XenDesktop 7
================================

The Template for Citrix XenDesktop 7 includes several "out-of-the-box" use cases including:

* High-level overviews supporting multiple farms
* Alerting
* ICA latency reporting
* User experience investigation
* User logon time details
* Performance visualization and monitoring
* Application usage
* Critical service monitoring

This Template is meant to be customized for your environment.

Information on this fork:
-This Template was forked from the original (https://github.com/splunk/splunk-template-xendesktop-7) to be used along with Splunk_TA_windows & SAI and metrics index for PerfMon
-This fork is compatible with the Splunk App for Infrastructure; entities can be filtered by the dimension virtualization: Citrix
-This fork allows a Deployment Server to whitelist all Windows hosts to receive Splunk_TA_windows, then also add the Citrix TAs to specific hosts.
-The add-ons have been renamed to Splunk_TA_Citrix-XD7* to allow inputs.conf to take precedence over the Splunk_TA_windows inputs.
-The Enhanced Dashboards have not been added yet, this is planned soon.

Pre-Requisites: 
-Splunk_TA_windows (https://splunkbase.splunk.com/app/742/) version 5.0.1+)
-Metric index for perfmon data (default set as index=em_metrics)
-Splunk TA Infrastructure on the indexing layer.  The following props.conf needs to go on the parsing/indexing layer (along with the indexes.conf on the indexing layer):

#For SAI Windows Metrics
[PerfmonMetrics:Citrix]
TRANSFORMS-_value_for_perfmon_metrics_store_sai = value_for_perfmon_metrics_store_sai
TRANSFORMS-metric_name_for_perfmon_metrics_store_sai = metric_name_for_perfmon_metrics_store_sai
TRANSFORMS-object_for_perfmon_metrics_store_sai = object_for_perfmon_metrics_store_sai
TRANSFORMS-instance_for_perfmon_metrics_store_sai = instance_for_perfmon_metrics_store_sai
TRANSFORMS-collection_for_perfmon_metrics_store_sai = collection_for_perfmon_metrics_store_sai
EVAL-metric_type = "gauge"
SEDCMD-remove-whitespace = s/ /_/g s/\s/ /g


Example of Splunk_TA_windows inputs.conf is below.  The add-on inputs.conf assumes this is already in place and appends additional PerfMon counters to populate the dashboards. It also adds a _meta dimension to help distinguish Citrix machines from other Windows hosts, which is important in a large-scale environment feeding PerfMon data to a metrics index.

###### Host monitoring ######
[WinHostMon://Service]
interval = 300
disabled = 0
type = Service
index = windows

###### Splunk 5.0+ Performance Counters ######
## CPU
[perfmon://CPU]
counters = % Processor Time; % User Time;% Privileged Time;Interrupts/sec;% Idle Time;
disabled = 0
instances = _Total
interval = 60
mode = single
object = Processor
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:CPU
index = em_metrics

## Logical Disk
[perfmon://LogicalDisk]
counters = % Free Space;Free Megabytes
disabled = 0
instances = *
interval = 60
mode = single
object = LogicalDisk
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:LogicalDisk
index = em_metrics

## Physical Disk
[perfmon://PhysicalDisk]
counters = % Disk Read Time;% Disk Write Time;Current Disk Queue Length;% Disk Time;% Idle Time;Avg. Disk sec/Read; Avg. Disk sec/Write
disabled = 0
instances = *
interval = 60
mode = single
object = PhysicalDisk
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:PhysicalDisk
index = em_metrics

## Memory
[perfmon://Memory]
counters = Available Bytes;Commit Limit;Cache Faults/sec;Cache Bytes;System Cache Resident Bytes;% Committed Bytes In Use;Page Reads/sec;Pages Input/sec;Pages Output/sec;Committed Bytes
disabled = 0
interval = 60
mode = single
object = Memory
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:Memory
index = em_metrics

## Network
[perfmon://Network]
counters = Bytes Total/sec; Current Bandwidth; Bytes Received/sec; Packets Received Errors; Bytes Sent/sec; Packets Outbound Errors; Output Queue Length; Packets Received/sec; Packets Sent/sec
disabled = 0
instances = *
interval = 60
mode = single
object = Network Interface
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:Network
index = em_metrics

## System
[perfmon://System]
counters = Processor Queue Length; System Up Time; Threads
disabled = 0
instances = *
interval = 60
mode = single
object = System
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:System
index = em_metrics

## Process
[perfmon://Process]
counters = % Processor Time; Private Bytes; Thread Count
disabled = 0
instances = *
interval = 60
mode = single
object = Process Information
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:Process
index = em_metrics

## Paging File
[perfmon://PagingFile]
counters = % Usage
disabled = 0
instances = *
interval = 60
mode = single
object = Paging File
useEnglishOnly=true
_meta =  os::"Microsoft Windows" entity_type::Windows_Host
sourcetype = PerfmonMetrics:PagingFile
index = em_metrics