FROM golang:1.26-alpine AS builder

WORKDIR /src
COPY go.mod ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -ldflags="-s -w" -o /node-agent .

FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=builder /node-agent /node-agent

USER nonroot

ENTRYPOINT ["/node-agent"]
