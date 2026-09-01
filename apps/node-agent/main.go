package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"
)

func envOr(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}

func envIntOr(key string, def int) int {
	if v := os.Getenv(key); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			return n
		}
	}
	return def
}

func main() {
	nodeName := envOr("NODE_NAME", "unknown")
	interval := time.Duration(envIntOr("INTERVAL_SECONDS", 10)) * time.Second

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	log.Printf("node-agent: старт на ноде %s (heartbeat каждые %s)", nodeName, interval)

	t := time.NewTicker(interval)
	defer t.Stop()

	for {
		select {
		case now := <-t.C:
			log.Printf("node-agent: alive node=%s ts=%s", nodeName, now.Format(time.RFC3339))
		case <-ctx.Done():
			log.Printf("node-agent: получен сигнал завершения — останавливаемся (нода %s)", nodeName)
			return
		}
	}
}
