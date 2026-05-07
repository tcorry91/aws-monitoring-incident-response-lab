# High CPU Alarm Response Runbook

## Purpose

This runbook describes the response process for a CloudWatch alarm triggered by high CPU usage on an EC2 instance.

## Trigger

CloudWatch alarm enters `ALARM` state when EC2 CPU utilisation exceeds the configured threshold.

## Initial Checks

1. Confirm the alarm state in CloudWatch.
2. Identify the affected EC2 instance.
3. Check EC2 instance status checks.
4. Review recent CPU metric history.
5. Confirm whether the load is expected, simulated, or abnormal.
6. Check whether the web service is still responding.

## Investigation Steps

1. Connect to the EC2 instance.
2. Check running processes.
3. Confirm whether a stress/load process is running.
4. Review system logs.
5. Check available memory and disk space.
6. Confirm web server status.

## Response Steps

1. Stop the simulated load process if this is a test.
2. Restart the web service only if required.
3. Continue monitoring CPU usage until it returns to normal.
4. Confirm the CloudWatch alarm returns to `OK`.
5. Record the cause and resolution.

## Escalation Criteria

Escalate if:

- CPU remains high after the load process is stopped.
- The instance becomes unreachable.
- EC2 status checks fail.
- The web service does not recover.
- Logs indicate an unknown or repeated fault.

## Resolution Notes

Record:

- Time alarm triggered
- Affected instance
- Initial symptoms
- Root cause
- Actions taken
- Time service recovered
- Follow-up improvements

## Prevention / Improvement Ideas

- Add more detailed application logging.
- Add memory and disk monitoring.
- Add automated recovery actions.
- Review instance sizing.
- Add dashboard visibility for common operational metrics.