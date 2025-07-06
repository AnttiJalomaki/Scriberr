#!/bin/bash
# Docker-based development script for Scriberr

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[DEV]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if .env file exists
if [ ! -f .env ]; then
    print_error ".env file not found. Creating from env.example..."
    cp env.example .env
    print_warning "Please edit .env file with your configuration"
    exit 1
fi

# Parse command
case "$1" in
    start)
        print_status "Starting Scriberr with GPU support..."
        docker compose -f compose.yml -f compose.gpu.yml up -d
        print_status "Application starting at http://localhost:3000"
        print_status "Use './dev-docker.sh logs' to view logs"
        ;;
    
    stop)
        print_status "Stopping Scriberr..."
        docker compose down
        ;;
    
    restart)
        print_status "Restarting Scriberr with rebuild..."
        docker compose -f compose.yml -f compose.gpu.yml down
        docker compose -f compose.yml -f compose.gpu.yml up -d --build
        print_status "Application restarted at http://localhost:3000"
        ;;
    
    rebuild)
        print_status "Rebuilding Scriberr..."
        docker compose -f compose.yml -f compose.gpu.yml build --no-cache
        docker compose -f compose.yml -f compose.gpu.yml up -d
        ;;
    
    logs)
        print_status "Showing logs (Ctrl+C to exit)..."
        docker compose logs -f app
        ;;
    
    logs-worker)
        print_status "Showing worker logs (Ctrl+C to exit)..."
        docker compose logs -f app | grep -i -E "(worker|transcription|queue)"
        ;;
    
    shell)
        print_status "Opening shell in app container..."
        docker compose exec app sh
        ;;
    
    db)
        print_status "Opening PostgreSQL shell..."
        docker compose exec db psql -U root -d local
        ;;
    
    status)
        print_status "Container status:"
        docker compose ps
        ;;
    
    clean)
        print_warning "This will remove all containers and volumes!"
        read -p "Are you sure? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            docker compose down -v
            print_status "All containers and volumes removed"
        fi
        ;;
    
    *)
        echo "Usage: $0 {start|stop|restart|rebuild|logs|logs-worker|shell|db|status|clean}"
        echo
        echo "Commands:"
        echo "  start       - Start Scriberr with GPU support"
        echo "  stop        - Stop all containers"
        echo "  restart     - Stop and start with rebuild"
        echo "  rebuild     - Full rebuild with no cache"
        echo "  logs        - Show application logs"
        echo "  logs-worker - Show worker/transcription logs"
        echo "  shell       - Open shell in app container"
        echo "  db          - Open PostgreSQL shell"
        echo "  status      - Show container status"
        echo "  clean       - Remove all containers and volumes"
        exit 1
        ;;
esac