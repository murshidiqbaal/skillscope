import os
from supabase import create_client, Client
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

url: str = os.getenv("SUPABASE_URL")
key: str = os.getenv("SUPABASE_KEY")

if not url or not key:
    raise ValueError("SUPABASE_URL and SUPABASE_KEY must be set in environment")

supabase: Client = create_client(url, key)

mock_skills = [
    {"name": "Flutter", "category": "Mobile Development", "demand_score": 92.5, "growth_rate": 15.0},
    {"name": "Python", "category": "Programming Languages", "demand_score": 98.0, "growth_rate": 10.5},
    {"name": "React", "category": "Web Development", "demand_score": 95.0, "growth_rate": 8.0},
    {"name": "Go", "category": "Backend Development", "demand_score": 85.0, "growth_rate": 18.2},
    {"name": "AWS", "category": "Cloud Computing", "demand_score": 96.0, "growth_rate": 12.0},
    {"name": "Docker", "category": "DevOps", "demand_score": 90.0, "growth_rate": 9.5},
    {"name": "PostgreSQL", "category": "Databases", "demand_score": 88.0, "growth_rate": 7.0},
]

mock_resources = [
    {"skill_name": "Flutter", "title": "Flutter Crash Course", "url": "https://youtube.com/flutter", "type": "youtube"},
    {"skill_name": "Flutter", "title": "Official Docs", "url": "https://docs.flutter.dev", "type": "documentation"},
    {"skill_name": "Python", "title": "Automate the Boring Stuff", "url": "https://automatetheboringstuff.com/", "type": "course"},
    {"skill_name": "React", "title": "React.dev", "url": "https://react.dev", "type": "documentation"},
]

def ingest():
    print("🚀 Starting Data Ingestion...")
    
    # 1. Ingest Skills
    for skill in mock_skills:
        try:
            existing = supabase.table("skills").select("id").eq("name", skill["name"]).execute()
            if not existing.data:
                supabase.table("skills").insert(skill).execute()
                print(f"✅ Inserted Skill: {skill['name']}")
            else:
                print(f"⏭️ Skill already exists: {skill['name']}")
        except Exception as e:
            print(f"❌ Error inserting {skill['name']}: {e}")

    # 2. Ingest Resources
    try:
        skills = supabase.table("skills").select("id, name").execute()
        skill_map = {s['name']: s['id'] for s in skills.data}

        for res in mock_resources:
            skill_id = skill_map.get(res['skill_name'])
            if skill_id:
                resource_data = {
                    "skill_id": skill_id,
                    "title": res['title'],
                    "url": res['url'],
                    "type": res['type']
                }
                existing_res = supabase.table("resources").select("id").eq("title", res["title"]).execute()
                if not existing_res.data:
                    supabase.table("resources").insert(resource_data).execute()
                    print(f"✅ Inserted Resource: {res['title']}")
                else:
                    print(f"⏭️ Resource already exists: {res['title']}")
    except Exception as e:
        print(f"❌ Error linking resources: {e}")

    print("🏁 Ingestion Complete.")

if __name__ == "__main__":
    ingest()
