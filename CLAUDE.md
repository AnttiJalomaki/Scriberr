# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Workflow

**IMPORTANT**: Due to network configuration complexities with the local dev server, we use Docker for all development work. This ensures consistent behavior between development and production.

### Starting Development Environment (GPU)
```bash
# Start the application with GPU support
docker compose -f compose.yml -f compose.gpu.yml up -d

# View logs
docker compose logs -f app

# Rebuild after code changes
docker compose -f compose.yml -f compose.gpu.yml up -d --build
```

### Starting Development Environment (CPU only)
```bash
# Start the application
docker compose up -d

# View logs
docker compose logs -f app

# Rebuild after code changes
docker compose up -d --build
```

### Quick Development Commands

**Use the `dev-docker.sh` script for easier development:**
```bash
./dev-docker.sh start       # Start with GPU support
./dev-docker.sh stop        # Stop all containers
./dev-docker.sh restart     # Restart with rebuild
./dev-docker.sh logs        # View logs
./dev-docker.sh logs-worker # View worker/transcription logs
./dev-docker.sh shell       # Access container shell
./dev-docker.sh db          # Access PostgreSQL
./dev-docker.sh status      # Check container status
```

**Manual commands:**
```bash
# Stop all containers
docker compose down

# Restart with rebuild (GPU)
docker compose -f compose.yml -f compose.gpu.yml down && docker compose -f compose.yml -f compose.gpu.yml up -d --build

# Check container status
docker compose ps

# Access container shell
docker compose exec app sh
```

### Code Quality (run inside container or locally)
```bash
npm run check        # Type-check TypeScript and Svelte files
npm run lint         # Run Prettier and ESLint checks
npm run format       # Auto-format code with Prettier
```

### Database Operations
```bash
# Database is automatically started with docker compose
# To run migrations or access the database:
docker compose exec db psql -U root -d local
```

## Architecture

Scriberr is an AI-powered transcription application built with SvelteKit, using WhisperX for speech-to-text and PyAnnote for speaker diarization.

### Tech Stack
- **Frontend**: Svelte 5, SvelteKit, TypeScript, Tailwind CSS
- **Backend**: SvelteKit server with Node.js
- **Database**: PostgreSQL with Drizzle ORM
- **AI/ML**: WhisperX (transcription), PyAnnote (diarization), OpenAI/Ollama (summarization)
- **Mobile**: Capacitor for iOS/Android support
- **Job Queue**: pg-boss for background processing

### Key Modules

**Frontend Routes** (`/src/routes/`):
- `+page.svelte`: Main transcription interface
- `components/`: UI components for audio recording, file upload, transcript display
- `api/`: Backend API endpoints for transcription, summarization, and file management

**Server Logic** (`/src/lib/server/`):
- `auth.ts`: Authentication and session management
- `transcription.ts`: WhisperX integration and transcription pipeline
- `worker.ts`: Background job processing for transcription tasks
- `db/`: Database schema definitions and connection management

**State Management** (`/src/lib/stores/`):
- Svelte stores for managing transcription state, user preferences, and UI state

### Database Schema

The application uses Drizzle ORM with PostgreSQL. Key tables include:
- Users and authentication
- Transcription jobs and results
- Audio file metadata
- Templates for summarization prompts

### Development Notes

1. **Environment Setup**: 
   - Copy `env.example` to `.env` and configure required variables
   - Set `HARDWARE_ACCEL=gpu` if you have an NVIDIA GPU
   - Default admin credentials: `admin` / `password`

2. **Development Cycle**:
   - Make code changes in your editor
   - Run `docker compose -f compose.yml -f compose.gpu.yml down && docker compose -f compose.yml -f compose.gpu.yml up -d --build`
   - Access the app at http://localhost:3000 (or your configured port)
   - Check logs with `docker compose logs -f app`

3. **Python Dependencies**: 
   - WhisperX and PyAnnote run inside the Docker container
   - No need to install Python dependencies locally

4. **Background Jobs**: 
   - Transcription jobs are processed by pg-boss worker
   - Monitor with: `docker compose logs -f app | grep -i worker`

5. **No Test Suite**: Currently no automated tests. Test thoroughly in Docker environment.

6. **GPU Support**: 
   - Requires NVIDIA GPU with CUDA support
   - Install NVIDIA Container Toolkit first
   - Use `compose.gpu.yml` for GPU acceleration