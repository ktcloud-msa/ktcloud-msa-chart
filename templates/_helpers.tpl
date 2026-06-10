{{/*
Common helpers for the shared KtCloudMarket MSA chart.

The historical selector for every workload is `app: {{ .Release.Name }}`.
That label is immutable on an existing Deployment, so it MUST stay exactly as
it was. New, richer labels are emitted only on object metadata / pod template
labels (never folded into the selector).
*/}}

{{/* The service / release name (Deployment, Service, pod label all share it). */}}
{{- define "ktcloud.name" -}}
{{- .Release.Name -}}
{{- end -}}

{{/*
Immutable selector labels. Do not add keys here without a Deployment recreate.
*/}}
{{- define "ktcloud.selectorLabels" -}}
app: {{ .Release.Name }}
{{- end -}}

{{/*
Common metadata labels (safe to extend — not part of any selector).
*/}}
{{- define "ktcloud.labels" -}}
app: {{ .Release.Name }}
app.kubernetes.io/name: {{ .Release.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: ktcloud-market-msa
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
{{- end -}}

{{/*
ServiceAccount name actually used by the workload.
*/}}
{{- define "ktcloud.serviceAccountName" -}}
{{- if (default dict .Values.serviceAccount).create -}}
{{- default .Release.Name .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" (default dict .Values.serviceAccount).name -}}
{{- end -}}
{{- end -}}

{{/*
HTTP container port (Spring Boot server.port).
*/}}
{{- define "ktcloud.httpPort" -}}
{{- .Values.appConfig.server.port | default 8080 -}}
{{- end -}}
