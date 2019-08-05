# Heating System

## POST Reading
> /api/v1/thermostat_readings
### Headers
> Content-Type:	application/json , Token:	value of household_token
### Parameters
> { "reading": {"temperature": 23, "humidity": 45.3, "battery_charge": 50 } }
  

## GET Reading Details
> /api/v1/thermostat_readings/:id
### Headers
> Content-Type:	application/json , Token:	value of household_token



## GET Thermostat Details
> /api/v1/thermostat_readings/stats
### Headers
> Content-Type:	application/json , Token:	value of household_token
