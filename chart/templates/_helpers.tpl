{{- define "demo-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "demo-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "demo-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "demo-app.labels" -}}
helm.sh/chart: {{ include "demo-app.chart" . }}
{{ include "demo-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "demo-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "demo-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "demo-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "demo-app.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "demo-app.image" -}}
{{- $repo := .repository -}}
{{- if not (contains "/" $repo) -}}
{{- $repo = printf "%s/%s" .registry $repo -}}
{{- end -}}
{{- printf "%s:%s" $repo .tag -}}
{{- end -}}

{{- define "demo-app.redisAddr" -}}
{{- printf "%s:%d" (printf "%s-redis" (include "demo-app.fullname" .)) (int .Values.redis.service.port) -}}
{{- end }}
