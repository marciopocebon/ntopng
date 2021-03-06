--
-- (C) 2019-20 - ntop.org
--

-- ##############################################

local alert_keys = require "alert_keys"
-- Import the classes library.
local classes = require "classes"
-- Make sure to import the Superclass!
local alert = require "alert"

-- ##############################################

local alert_port_status_change = classes.class(alert)

-- ##############################################

alert_port_status_change.meta = {
   alert_key = alert_keys.ntopng.alert_port_status_change,
   i18n_title = "alerts_dashboard.snmp_port_status_change",
   icon = "fas fa-exclamation",
}

-- ##############################################

-- @brief Prepare an alert table used to generate the alert
-- @param device_ip A string with the ip address of the snmp device
-- @param if_index The index of the port that changed
-- @param interface_name The string with the name of the port that changed
-- @param status A string with the new status
-- @return A table with the alert built
function alert_port_status_change:init(device_ip, if_index, interface_name, status)
   -- Call the paren constructor
   self.super:init()

   self.alert_type_params = {
      device = device_ip,
      interface = if_index,
      interface_name = interface_name,
      status = status,
   }
end

-- #######################################################

-- @brief Format an alert into a human-readable string
-- @param ifid The integer interface id of the generated alert
-- @param alert The alert description table, including alert data such as the generating entity, timestamp, granularity, type
-- @param alert_type_params Table `alert_type_params` as built in the `:init` method
-- @return A human-readable string
function alert_port_status_change.format(ifid, alert, alert_type_params)
  local snmp_consts = require "snmp_consts"

  return(i18n("alerts_dashboard.snmp_port_changed_operational_status",
    {device = alert_type_params.device,
     port = alert_type_params.interface_name or alert_type_params.interface,
     url = snmpDeviceUrl(alert_type_params.device),
     port_url = snmpIfaceUrl(alert_type_params.device, alert_type_params.interface),
     new_op = snmp_consts.snmp_ifstatus(alert_type_params.status)}))
end

-- #######################################################

return alert_port_status_change
