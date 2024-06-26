IMPORT os
IMPORT util

PRIVATE DEFINE webContext DICTIONARY ATTRIBUTE (WSContext) OF STRING

PUBLIC FUNCTION ping()
	ATTRIBUTES (WSGet, WSPath="/ping", WSDescription="Ping method to return Request Context")
	RETURNS util.JSONObject

	VAR jsonContext = util.JSONObject.create()

	VAR keys = webContext.getKeys()
	VAR idx = 0
	FOR idx = 1 TO keys.getLength()
		VAR keyName = keys[idx]
		VAR keyValue = webContext[keyName]
		LET keyValue = keyValue.replaceAll('"', "'")
		CALL jsonContext.put(keyName, keyValue)
	END FOR

	RETURN jsonContext

END FUNCTION #ping

PUBLIC FUNCTION securePing()
	ATTRIBUTES (
		WSGet,
		WSPath="/secure/ping",
		WSScope="Role.ServiceUser",
		WSDescription="Secure Ping method to return Request Context"
	) RETURNS util.JSONObject

	RETURN ping()

END FUNCTION #securePing

PUBLIC FUNCTION envVars()
	ATTRIBUTES (WSGet, WSPath="/env", WSDescription="Environment get the system environment variables")
	RETURNS util.JSONObject

	CONSTANT cWindowsCmd = "set"
	CONSTANT cBashCmd = "env"
	DEFINE outputLine STRING

	VAR jsonContext = util.JSONObject.create()
	VAR envOutput = base.Channel.create()
	VAR osCmd = IIF(os.Path.separator() == "/", cBashCmd, cWindowsCmd)

	CALL envOutput.openPipe(osCmd, "r")
	WHILE (outputLine := envOutput.readLine()) IS NOT NULL
		VAR parts = outputLine.split("=")
		IF parts.getLength() == 2 THEN
			CALL jsonContext.put(parts[1], parts[2])
		ELSE
			IF parts.getLength() > 2 THEN
				VAR keyName = parts[1]
				VAR idx = 0
				VAR keyValue STRING = NULL
				FOR idx = 2 TO parts.getLength()
					IF idx == 2 THEN
						LET keyValue = parts[idx]
					ELSE
						LET keyValue ,= "=", parts[idx]
					END IF
				END FOR
				CALL jsonContext.put(keyName, keyValue)
			END IF
		END IF
	END WHILE

	RETURN jsonContext

END FUNCTION #envVars

PUBLIC FUNCTION secureEnvVars()
	ATTRIBUTES (
		WSGet,
		WSPath="/secure/env",
		WSScope="Role.ServiceUser",
		WSDescription="Secure Environment method to return system environment variables"
	) RETURNS util.JSONObject

	RETURN envVars()

END FUNCTION #secureEnvVars



