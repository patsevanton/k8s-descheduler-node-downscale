FROM golang:1.26-alpine AS builder

WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /cron-job .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /cron-job /cron-job

USER nonroot

ENTRYPOINT ["/cron-job"]
