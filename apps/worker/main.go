package main

import (
	"context"
	"log"
	"os"
	"os/signal"
	"strconv"
	"syscall"
	"time"

	"github.com/redis/go-redis/v9"
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
	redisAddr := envOr("REDIS_ADDR", "demo-redis:6379")
	interval := time.Duration(envIntOr("INTERVAL_SECONDS", 5)) * time.Second

	rdb := redis.NewClient(&redis.Options{Addr: redisAddr})
	defer rdb.Close()

	ctx, stop := signal.NotifyContext(context.Background(), syscall.SIGINT, syscall.SIGTERM)
	defer stop()

	log.Printf("worker: старт, redis=%s, обработка задания каждые %s", redisAddr, interval)

	t := time.NewTicker(interval)
	defer t.Stop()

	for {
		select {
		case now := <-t.C:
			counter, err := rdb.Incr(ctx, "worker:processed_total").Result()
			if err != nil {
				log.Printf("worker: ошибка INCR: %v", err)
				continue
			}
			log.Printf("worker: обработано задание #%d ts=%s", counter, now.Format(time.RFC3339))
		case <-ctx.Done():
			log.Printf("worker: получен сигнал завершения — останавливаемся")
			return
		}
	}
}
