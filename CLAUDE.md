# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development
```bash
npm run dev          # Start development server (default: http://localhost:5173)
npm run build        # Build for production
npm run preview      # Preview production build
```

### Code Quality
```bash
npm run check        # Type-check TypeScript and Svelte files
npm run check:watch  # Type-check in watch mode
npm run lint         # Run Prettier and ESLint checks
npm run format       # Auto-format code with Prettier
```

### Database
```bash
npm run db:start     # Start PostgreSQL in Docker
npm run db:push      # Push schema changes to database
npm run db:migrate   # Run database migrations
npm run db:studio    # Open Drizzle Studio GUI
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

1. **Environment Setup**: Copy `env.example` to `.env` and configure required variables (database URL, API keys)

2. **Python Dependencies**: The application includes a Python runtime for WhisperX. Docker deployment is recommended for consistent environment.

3. **Background Jobs**: Transcription runs as background jobs using pg-boss. Monitor job queue for debugging transcription issues.

4. **No Test Suite**: Currently no automated tests. Be careful when refactoring core functionality.

5. **Breaking Changes**: Project is pre-1.0. Check migration guides when updating between versions.

6. **GPU Support**: For optimal transcription performance, use `docker compose.gpu.yml` with NVIDIA GPU support.