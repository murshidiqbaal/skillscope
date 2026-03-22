"""
scripts/seed_data.py
One-off script to seed the Supabase database with sample data for SkillScope AI.

Run from the project root:
    python -m backend.scripts.seed_data

════════════════════════════════════════════════════════════════════
Required Supabase SQL — paste into the Supabase SQL editor and run
BEFORE executing this script.
════════════════════════════════════════════════════════════════════

-- chat_messages
CREATE TABLE IF NOT EXISTS chat_messages (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    text NOT NULL,
  role       text NOT NULL,
  content    text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- job_roles
CREATE TABLE IF NOT EXISTS job_roles (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  role_name       text NOT NULL,
  description     text,
  category        text,
  required_skills text[] DEFAULT '{}'
);

-- learning_resources
CREATE TABLE IF NOT EXISTS learning_resources (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  skill_name  text NOT NULL,
  title       text NOT NULL,
  url         text NOT NULL,
  description text,
  platform    text,
  created_at  timestamptz DEFAULT now()
);

-- skills
CREATE TABLE IF NOT EXISTS skills (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name         text NOT NULL,
  description  text,
  category     text,
  demand_score float DEFAULT 0,
  growth_rate  float DEFAULT 0,
  icon_url     text,
  tags         text[] DEFAULT '{}',
  created_at   timestamptz DEFAULT now()
);

-- resources  (used by mobile trending_skills feature)
CREATE TABLE IF NOT EXISTS resources (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  skill_id   uuid REFERENCES skills(id),
  type       text,
  title      text,
  url        text,
  created_at timestamptz DEFAULT now()
);

════════════════════════════════════════════════════════════════════
"""

import sys
import os

# Resolve imports whether run as a module or directly.
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

from supabase import create_client, Client
from backend.core.config import settings

client: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)

# ── Seed data ─────────────────────────────────────────────────────────────────

JOB_ROLES = [
    {
        "role_name": "Flutter Developer",
        "description": "Builds cross-platform mobile apps using Flutter & Dart.",
        "category": "Mobile",
        "required_skills": [
            "Flutter", "Dart", "Firebase", "REST APIs", "Riverpod",
            "GoRouter", "Git", "State Management",
        ],
    },
    {
        "role_name": "Backend Engineer",
        "description": "Designs and maintains server-side APIs and databases.",
        "category": "Backend",
        "required_skills": [
            "Python", "FastAPI", "PostgreSQL", "Docker",
            "Redis", "REST APIs", "Git", "CI/CD",
        ],
    },
    {
        "role_name": "ML Engineer",
        "description": "Trains, evaluates, and deploys machine learning models.",
        "category": "AI/ML",
        "required_skills": [
            "Python", "PyTorch", "scikit-learn", "SQL",
            "Docker", "MLflow", "NumPy", "Pandas",
        ],
    },
    {
        "role_name": "DevOps Engineer",
        "description": "Automates deployment pipelines and manages cloud infrastructure.",
        "category": "Infrastructure",
        "required_skills": [
            "Docker", "Kubernetes", "CI/CD", "Terraform",
            "Linux", "AWS", "Monitoring", "Bash",
        ],
    },
    {
        "role_name": "Frontend Developer",
        "description": "Creates responsive web interfaces using modern JS frameworks.",
        "category": "Frontend",
        "required_skills": [
            "React", "TypeScript", "CSS", "HTML",
            "REST APIs", "Git", "Testing", "Webpack",
        ],
    },
    {
        "role_name": "Data Engineer",
        "description": "Builds and maintains scalable data pipelines and warehouses.",
        "category": "Data",
        "required_skills": [
            "Python", "Apache Spark", "SQL", "Airflow",
            "dbt", "Kafka", "PostgreSQL", "Cloud Storage",
        ],
    },
    {
        "role_name": "Android Developer",
        "description": "Develops native Android applications using Kotlin.",
        "category": "Mobile",
        "required_skills": [
            "Kotlin", "Android SDK", "Jetpack Compose", "Room",
            "Retrofit", "Coroutines", "MVVM", "Git",
        ],
    },
    {
        "role_name": "iOS Developer",
        "description": "Develops native iOS applications using Swift.",
        "category": "Mobile",
        "required_skills": [
            "Swift", "SwiftUI", "UIKit", "CoreData",
            "Combine", "Xcode", "REST APIs", "Git",
        ],
    },
]

SKILLS = [
    {
        "name": "Flutter",
        "description": "Google's open-source UI toolkit for building natively compiled cross-platform apps.",
        "category": "Mobile",
        "demand_score": 88.0,
        "growth_rate": 15.0,
        "icon_url": "https://storage.googleapis.com/cms-storage-bucket/4fd0db61df0567c950f1.png",
        "tags": ["mobile", "dart", "ui", "cross-platform"],
    },
    {
        "name": "Python",
        "description": "Versatile, high-level programming language used in web, AI, automation, and more.",
        "category": "Backend",
        "demand_score": 95.0,
        "growth_rate": 12.0,
        "icon_url": "https://www.python.org/static/community_logos/python-logo.png",
        "tags": ["scripting", "backend", "ai", "automation"],
    },
    {
        "name": "FastAPI",
        "description": "Modern, fast (high-performance) async Python web framework.",
        "category": "Backend",
        "demand_score": 80.0,
        "growth_rate": 20.0,
        "icon_url": "https://fastapi.tiangolo.com/img/logo-margin/logo-teal.png",
        "tags": ["api", "async", "python", "rest"],
    },
    {
        "name": "React",
        "description": "Declarative JavaScript UI library for building component-based web interfaces.",
        "category": "Frontend",
        "demand_score": 92.0,
        "growth_rate": 8.0,
        "icon_url": "https://upload.wikimedia.org/wikipedia/commons/a/a7/React-icon.svg",
        "tags": ["ui", "javascript", "spa", "frontend"],
    },
    {
        "name": "Docker",
        "description": "Containerisation platform for packaging apps with their dependencies.",
        "category": "DevOps",
        "demand_score": 90.0,
        "growth_rate": 10.0,
        "icon_url": "https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png",
        "tags": ["containers", "devops", "cloud", "deployment"],
    },
    {
        "name": "Kubernetes",
        "description": "Open-source system for automating deployment, scaling, and management of containers.",
        "category": "Infrastructure",
        "demand_score": 85.0,
        "growth_rate": 14.0,
        "icon_url": "https://kubernetes.io/images/kubernetes-horizontal-color.png",
        "tags": ["orchestration", "devops", "cloud", "scaling"],
    },
    {
        "name": "PyTorch",
        "description": "Open-source deep learning framework developed by Meta AI.",
        "category": "AI/ML",
        "demand_score": 87.0,
        "growth_rate": 18.0,
        "icon_url": "https://pytorch.org/assets/images/pytorch-logo.png",
        "tags": ["deep-learning", "ai", "python", "neural-networks"],
    },
    {
        "name": "PostgreSQL",
        "description": "Powerful, open-source object-relational database system.",
        "category": "Database",
        "demand_score": 89.0,
        "growth_rate": 7.0,
        "icon_url": "https://www.postgresql.org/media/img/about/press/elephant.png",
        "tags": ["sql", "database", "backend", "relational"],
    },
    {
        "name": "TypeScript",
        "description": "Strongly typed superset of JavaScript that compiles to plain JS.",
        "category": "Frontend",
        "demand_score": 91.0,
        "growth_rate": 16.0,
        "icon_url": "https://upload.wikimedia.org/wikipedia/commons/4/4c/Typescript_logo_2020.svg",
        "tags": ["javascript", "typed", "frontend", "backend"],
    },
    {
        "name": "Kotlin",
        "description": "Modern, concise programming language for Android and JVM development.",
        "category": "Mobile",
        "demand_score": 82.0,
        "growth_rate": 11.0,
        "icon_url": "https://upload.wikimedia.org/wikipedia/commons/7/74/Kotlin_Icon.png",
        "tags": ["android", "mobile", "jvm", "backend"],
    },
    {
        "name": "Redis",
        "description": "In-memory data store used as a cache, message broker, and database.",
        "category": "Database",
        "demand_score": 84.0,
        "growth_rate": 9.0,
        "icon_url": "https://redis.io/images/redis-white.png",
        "tags": ["cache", "database", "backend", "performance"],
    },
    {
        "name": "Dart",
        "description": "Client-optimised language for fast apps on any platform, used with Flutter.",
        "category": "Mobile",
        "demand_score": 75.0,
        "growth_rate": 13.0,
        "icon_url": "https://dart.dev/assets/img/logo/logo-white.svg",
        "tags": ["mobile", "flutter", "frontend", "compiled"],
    },
]

LEARNING_RESOURCES = [
    # Flutter
    {
        "skill_name": "Flutter",
        "title": "Flutter Official Documentation",
        "url": "https://docs.flutter.dev",
        "description": "The authoritative Flutter reference with codelabs, guides, and API docs.",
        "platform": "flutter.dev",
    },
    {
        "skill_name": "Flutter",
        "title": "Flutter & Dart — The Complete Guide (2024)",
        "url": "https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/",
        "description": "Bestselling Udemy course covering Flutter from zero to production.",
        "platform": "Udemy",
    },
    {
        "skill_name": "Flutter",
        "title": "Flutter YouTube Channel",
        "url": "https://www.youtube.com/@flutterdev",
        "description": "Official Flutter channel with tutorials, talks, and live coding sessions.",
        "platform": "YouTube",
    },
    # Python
    {
        "skill_name": "Python",
        "title": "Python for Everybody Specialisation",
        "url": "https://www.coursera.org/specializations/python",
        "description": "Beginner-friendly Python specialisation — 5 courses by University of Michigan.",
        "platform": "Coursera",
    },
    {
        "skill_name": "Python",
        "title": "Real Python Tutorials",
        "url": "https://realpython.com",
        "description": "High-quality, practical Python articles and video courses.",
        "platform": "Real Python",
    },
    # FastAPI
    {
        "skill_name": "FastAPI",
        "title": "FastAPI Official Tutorial",
        "url": "https://fastapi.tiangolo.com/tutorial/",
        "description": "Step-by-step FastAPI tutorial — from Hello World to advanced patterns.",
        "platform": "fastapi.tiangolo.com",
    },
    {
        "skill_name": "FastAPI",
        "title": "Full Stack FastAPI & PostgreSQL",
        "url": "https://github.com/tiangolo/full-stack-fastapi-template",
        "description": "Production-ready full-stack template with FastAPI, PostgreSQL, and Docker.",
        "platform": "GitHub",
    },
    # React
    {
        "skill_name": "React",
        "title": "React Official Tutorial",
        "url": "https://react.dev/learn",
        "description": "The new official React docs — interactive, modern, and comprehensive.",
        "platform": "react.dev",
    },
    {
        "skill_name": "React",
        "title": "The Ultimate React Course",
        "url": "https://www.udemy.com/course/the-ultimate-react-course/",
        "description": "Deep-dive React course including hooks, Redux, and Next.js.",
        "platform": "Udemy",
    },
    # Docker
    {
        "skill_name": "Docker",
        "title": "Docker Getting Started",
        "url": "https://docs.docker.com/get-started/",
        "description": "Official Docker beginner guide with hands-on labs.",
        "platform": "Docker Docs",
    },
    {
        "skill_name": "Docker",
        "title": "Docker & Kubernetes: The Practical Guide",
        "url": "https://www.udemy.com/course/docker-kubernetes-the-practical-guide/",
        "description": "Comprehensive Docker and Kubernetes course for beginners to advanced.",
        "platform": "Udemy",
    },
    # Kubernetes
    {
        "skill_name": "Kubernetes",
        "title": "Kubernetes Basics (Interactive)",
        "url": "https://kubernetes.io/docs/tutorials/kubernetes-basics/",
        "description": "Browser-based interactive Kubernetes tutorial from kubernetes.io.",
        "platform": "kubernetes.io",
    },
    # PyTorch
    {
        "skill_name": "PyTorch",
        "title": "Official PyTorch Tutorials",
        "url": "https://pytorch.org/tutorials/",
        "description": "Official tutorials from beginner to advanced deep learning.",
        "platform": "pytorch.org",
    },
    {
        "skill_name": "PyTorch",
        "title": "Deep Learning with PyTorch — fast.ai",
        "url": "https://course.fast.ai",
        "description": "Free top-down practical deep learning course using PyTorch.",
        "platform": "fast.ai",
    },
    # PostgreSQL
    {
        "skill_name": "PostgreSQL",
        "title": "PostgreSQL Tutorial",
        "url": "https://www.postgresqltutorial.com",
        "description": "Free, structured PostgreSQL learning path from basics to advanced SQL.",
        "platform": "postgresqltutorial.com",
    },
    # TypeScript
    {
        "skill_name": "TypeScript",
        "title": "TypeScript Official Handbook",
        "url": "https://www.typescriptlang.org/docs/handbook/intro.html",
        "description": "Comprehensive reference for all TypeScript features.",
        "platform": "typescriptlang.org",
    },
    # Kotlin
    {
        "skill_name": "Kotlin",
        "title": "Kotlin Official Documentation",
        "url": "https://kotlinlang.org/docs/home.html",
        "description": "Complete Kotlin language reference and guides.",
        "platform": "kotlinlang.org",
    },
    {
        "skill_name": "Kotlin",
        "title": "Android Basics with Compose",
        "url": "https://developer.android.com/courses/android-basics-compose/course",
        "description": "Google's free course — modern Android development with Kotlin & Jetpack Compose.",
        "platform": "Google Developers",
    },
    # Dart
    {
        "skill_name": "Dart",
        "title": "Dart Language Tour",
        "url": "https://dart.dev/language",
        "description": "Official Dart language tour covering all core language features.",
        "platform": "dart.dev",
    },
]


# ── Helpers ───────────────────────────────────────────────────────────────────

def _count(table: str) -> int:
    """Return the number of rows in a Supabase table."""
    resp = client.table(table).select("id", count="exact").execute()
    return resp.count or 0


def _insert(table: str, rows: list[dict], label: str) -> None:
    """Insert rows only when the table is empty."""
    if _count(table) == 0:
        client.table(table).insert(rows).execute()
        print(f"  ✅  Inserted {len(rows):>3} {label}.")
    else:
        print(f"  ⏭   '{table}' already has data — skipped.")


# ── Entry-point ───────────────────────────────────────────────────────────────

def seed() -> None:
    """Run all seed insertions."""
    print("\n🌱  Seeding SkillScope AI database …\n")
    _insert("job_roles",          JOB_ROLES,          "job roles")
    _insert("skills",             SKILLS,             "skills")
    _insert("learning_resources", LEARNING_RESOURCES, "learning resources")
    print("\n🎉  Seeding complete.\n")


if __name__ == "__main__":
    seed()
