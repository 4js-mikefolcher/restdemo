# restdemo
Simple REST Web Services Demo using an IdP

## Simple RESTful Web Service Demo
The project contains 4 endpoints.
 - /ping ** Returns Request header information in key/value format **
 - /secure/ping ** Same as the /ping endpoint, but requires the Role.ServiceUser scope **
 - /env ** Returns all the backend environment variables in key/value format **
 - /secure/env ** Same as the /env endpoint, but requires the Role.ServiceUser scope **
