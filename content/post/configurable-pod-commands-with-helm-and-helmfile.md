---
title: "Configurable Pod Commands With Helm and Helmfile"
date: 2020-07-12T17:15:46-07:00
draft: false
tags: helm, helmfile, k8s
---

##### Enable launching a Pod with different commands
Here's a snippet and overview of how I used helm template functions &
helmfile to make pod manifest that supports multiple commands passed during
deployment.

I have a [Kubernetes
Job](https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/#writing-a-job-spec) that launches a pod to run some simple scripts.

The app exposes a simple API that supports performing different 
actions based on the args (or docker `CMD`) list passed during deploy.

**example**

for example I want run a cleanup job on the `user_table`
```bash
python -m cleanupscript --table user_table
```

Additionally I want to be able to run this same job to do a backup as a CronJob and put some data to S3.

```bash
python -m backupscript --table analytics --output s3://backupscript-data
```

##### Job template
The template in the charts repo:

**charts/demo/templates/job.yaml**
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Values.job }}
spec:
  ttlSecondsAfterFinished: 100
  template:
    spec:
      containers:
      - name: {{ .Values.job }}
        image: alpine
        args:
{{- range $cmd:= .Values.cmd | split " " }}
          - {{ $cmd }}
{{- end }}
      restartPolicy: Never
```

#####  chart values file

the chart's values file where we render the command via `helmfile`
**charts/demo/values.yaml**
```yaml
job: backup-job
cmd: "rendered_from_helmfile"
```

##### helmfile

the helmfile for this demo chart release
**helmfiles/releases/demo.yaml**
```yaml
repositories:
  - name: jafow
    url: git+https://github.com/jafow/charts@stable/demo?ref=demo

helmDefaults:
  wait: true
  timeout: 300
  createNamespace: true

releases:
  - name: demo
    namespace: jobs
    chart: "jafow/demo"
    labels:
      job: demo
      stage: dev
    values:
      - job: demo
      - cmd: python -m backupscript --table analytics --output s3://backupscript-data
```

### the result

🎉 The rendered result looks like this:

```bash
Update Complete. ⎈ Happy Helming!⎈

Building dependency release=demo, chart=../../charts/stable/demo
Templating release=demo, chart=../../charts/stable/demo
---
# Source: demo/templates/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: demo
spec:
  ttlSecondsAfterFinished: 100
  template:
    spec:
      containers:
      - name: demo
        image: alpine
        args:
          - python
          - -m
          - backupscript
          - --table
          - analytics
          - --output
          - s3://backupscript-data
      restartPolicy: Never
```
