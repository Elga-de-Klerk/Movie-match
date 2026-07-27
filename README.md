# 🎬 MovieMatch

A movie discovery app that helps friends find something everyone wants to watch. 
Create a session, invite your people, swipe through movies together, and let MovieMatch find a match. 🍿

## 🗂️ What's in here

This is a Phoenix LiveView application — a little Elixir project built around real-time collaboration.

- ⚡ [`lib/movie_match/`](./lib/movie_match) — the brains (Elixir, Ecto, PostgreSQL)
- 🎨 [`lib/movie_match_web/`](./lib/movie_match_web) — the face (Phoenix LiveView, HEEx, Tailwind CSS)

## ✅ Before you start, you'll need

- 💧 Elixir
- 🐘 PostgreSQL
- 🟢 Node.js (for frontend assets)
- 🐳 Docker (optional, for running PostgreSQL)

## 🚀 Quick start

1. Start PostgreSQL
2. Install dependencies and prepare the database: `mix setup`
3. Start the development server: `mix phx.server`
4. Open the app: `http://localhost:4000`. 

Create a session, invite some friends, and find your next movie night 🎲🎥

🧰 Built with
- Backend: Elixir · Phoenix Framework 1.8.1 · Phoenix LiveView · Ecto
- Database: PostgreSQL
- Frontend: HEEx · Tailwind CSS
- Movie data: TMDB + streaming availability APIs (planned)