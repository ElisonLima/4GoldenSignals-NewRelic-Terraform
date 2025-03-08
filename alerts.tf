resource "newrelic_alert_policy" "golden_signals" {
  name = "Golden Signals Alerts"
  incident_preference = "PER_POLICY"
} 

resource "newrelic_alert_condition" "latency" {
  policy_id  = newrelic_alert_policy.golden_signals.id
  name       = "High Response Time"
  type       = "apm_app_metric"
  entities   = ["YOUR_APPLICATION_ID"]
  metric     = "response_time_web"
  condition_scope = "application"
  
  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = 2000  # 2 seconds
    time_function = "all"
  }
} 

resource "newrelic_alert_condition" "traffic" {
  policy_id  = newrelic_alert_policy.golden_signals.id
  name       = "Low Traffic"
  type       = "apm_app_metric"
  entities   = ["YOUR_APPLICATION_ID"]
  metric     = "throughput_web"
  condition_scope = "application"
  
  term {
    duration      = 5
    operator      = "below"
    priority      = "critical"
    threshold     = 10  # Alert if traffic drops below 10 RPM
    time_function = "all"
  }
} 

resource "newrelic_alert_condition" "errors" {
  policy_id  = newrelic_alert_policy.golden_signals.id
  name       = "High Error Rate"
  type       = "apm_app_metric"
  entities   = ["YOUR_APPLICATION_ID"]
  metric     = "error_percentage"
  condition_scope = "application"
  
  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = 5  # Alert if errors exceed 5%
    time_function = "all"
  }
} 

resource "newrelic_alert_condition" "saturation" {
  policy_id  = newrelic_alert_policy.golden_signals.id
  name       = "High CPU Utilization"
  type       = "infra_metric"
  entities   = ["YOUR_INFRASTRUCTURE_ENTITY_ID"]
  metric     = "cpuPercent"
  
  term {
    duration      = 5
    operator      = "above"
    priority      = "critical"
    threshold     = 90  # Alert if CPU usage exceeds 90%
    time_function = "all"
  }
} 

resource "newrelic_alert_channel" "foo" {
  name = "foo"
  type = "email"

  config {
    recipients              = "foo@example.com"
    include_json_attachment = "true"
    url = "<YOUR_SLACK_WEBHOOK>"
  }
}

resource "newrelic_alert_policy_channel" "golden_signals_slack" {
  policy_id  = newrelic_alert_policy.golden_signals.id
  channel_ids = [newrelic_notification_channel.slack.id]
} 
