import json
import requests
import os

import pandas as pd

from dagster import (
    Config,
    MaterializeResult,
    MetadataValue,
    asset,
)

class HNStoriesConfig(Config):
    top_stories_limit: int = 10
    hn_top_story_ids_path: str = "data/hackernews_top_story_ids.json"
    hn_top_stories_path: str = "data/hackernews_top_stories.csv"
    lubw_recent_path: str = "data/lubw_recent.json"


@asset
def hackernews_top_story_ids(config: HNStoriesConfig):
    """Get top stories from the HackerNews top stories endpoint."""
    top_story_ids = requests.get("https://hacker-news.firebaseio.com/v0/topstories.json").json()

    with open(config.hn_top_story_ids_path, "w") as f:
        json.dump(top_story_ids[: config.top_stories_limit], f)


@asset(deps=[hackernews_top_story_ids])
def hackernews_top_stories(config: HNStoriesConfig) -> MaterializeResult:
    """Get items based on story ids from the HackerNews items endpoint."""
    with open(config.hn_top_story_ids_path, "r") as f:
        hackernews_top_story_ids = json.load(f)

    results = []
    for item_id in hackernews_top_story_ids:
        item = requests.get(f"https://hacker-news.firebaseio.com/v0/item/{item_id}.json").json()
        results.append(item)

    df = pd.DataFrame(results)
    df.to_csv(config.hn_top_stories_path)

    return MaterializeResult(
        metadata={
            "num_records": len(df),
            "preview": MetadataValue.md(str(df[["title", "by", "url"]].to_markdown())),
        }
    )

import httpx
from . import secrets
import datetime

lubw_url = "https://mersyzentrale.de/www/Datenweitergabe/Konstanz/data.php"

@asset
def lubw_recent_o3():
    auth = httpx.DigestAuth(
            username=secrets.get('lubw', 'username'),
            password=secrets.get('lubw', 'password'),
            )
    client = httpx.Client(auth=auth)
    now = datetime.datetime.now()
    yesterday = now - datetime.timedelta(days=1)
    response = client.get(
            lubw_url,
            params=dict(
                komponente="O3",
                von=yesterday.isoformat(timespec='seconds'),
                bis=now.isoformat(timespec='seconds'),
                ),
            headers=dict(Accept="application/json")
            )
    return response.json()
