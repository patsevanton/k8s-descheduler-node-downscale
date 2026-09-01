package main

import (
	"context"
	"log"
	"os"
	"time"

	"github.com/redis/go-redis/v9"
)

func envOr(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}

func main() {
	redisAddr := envOr("REDIS_ADDR", "demo-redis:6379")

	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	rdb := redis.NewClient(&redis.Options{Addr: redisAddr})
	defer rdb.Close()

	key := "cronjob:last_run"
	if err := rdb.Set(ctx, key, time.Now().Format(time.RFC3339), 0).Err(); err != nil {
		log.Printf("cron-job: ошибка записи в redis: %v", err)
		os.Exit(1)
	}

	val, err := rdb.Get(ctx, key).Result()
	if err != nil {
		log.Printf("cron-job: ошибка чтения из redis: %v", err)
		os.Exit(1)
	}

	log.Printf("cron-job: успешно записано и прочитано из redis: %s=%s", key, val)
}
