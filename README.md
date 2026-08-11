# Content Marketing Orchestrator SaaS

SocialFlow is a powerful multi-tenant platform for agencies and brands to manage social media campaigns. It includes a Laravel scheduler, a Flutter approval dashboard, and n8n automation for AI-driven content generation and multi-platform posting.

## Product surface

| Capability | Implementation |
|---|---|
| Multi-tenancy | Workspace isolation for different brands or agency clients |
| Scheduling | Advanced post scheduling with status transitions (Draft -> Scheduled -> Published) |
| Approval Flow | Client-facing approval mechanism for scheduled social media content |
| Channel Management | Support for multiple social channels (Facebook, Instagram, etc.) per workspace |
| Mobile Dashboard | Flutter Material 3 client for on-the-go post approval and campaign monitoring |
| AI Automation | n8n integration for generating post ideas and automated cross-platform delivery |

## Run the backend

```bash
cd backend
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan serve --host=0.0.0.0 --port=8000
```

Seeded credentials:

| User | Email | Password | Role |
|---|---|---|---|
| Agency Owner | `owner@marketing.test` | `password` | Admin |

The seeded workspace `Brand Agency` includes pre-configured Facebook and Instagram channels and a sample scheduled post.

## Run the Flutter mobile app

```bash
cd frontend
flutter pub get
flutter test
flutter analyze
flutter run
```

The app is configured for an Android emulator (`10.0.2.2`). It allows workspace members to view upcoming campaigns, inspect post content, and approve drafts for publication.

## AI Generation & Posting (n8n)

Import `workflows/marketing_orchestrator.json` into n8n. This workflow handles:
1. **AI Creation**: Uses OpenAI to generate high-engagement post content based on topics.
2. **Multi-Posting**: Connects to social platform APIs (e.g., Facebook Graph API) for delivery.
3. **Status Feedback**: Reports successful publication back to the Laravel control plane.

## API surface

| Method | Endpoint | Purpose |
|---|---|---|
| `POST` | `/api/v1/auth/register` | Create an agency workspace and owner account |
| `POST` | `/api/v1/auth/login` | Issue an API token for the mobile dashboard |
| `GET` | `/api/v1/workspaces/{id}/dashboard` | Fetch campaign overview and recent posts |
| `POST` | `/api/v1/workspaces/{id}/posts` | Create a new scheduled post draft |
| `POST` | `/api/v1/workspaces/{id}/posts/{id}/approve` | Move a post from draft to scheduled status |

## Validation

```bash
cd backend
php artisan test --compact

cd ../frontend
flutter analyze
```

## SaaS roadmap

The system is ready for commercial features like advanced analytics (engagement tracking), a shared media library, AI image generation integration, team collaboration comments, and white-labeling for agencies.

## Author

Ahmed Emad — Backend, Mobile, and Automation Developer.
