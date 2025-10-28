from pathlib import Path
from types import SimpleNamespace
from dotenv import load_dotenv

load_dotenv()

# Simple settings object (avoid pydantic BaseSettings incompatibility)
ROOT = Path(__file__).resolve().parents[2]
BACKEND_DIR = Path(__file__).resolve().parents[1]

settings = SimpleNamespace(
    data_dir=BACKEND_DIR / "data",
    seeder_dir=ROOT / "seeder",
    dataset_dir=ROOT / "dataset",
    env_file=".env",
)
