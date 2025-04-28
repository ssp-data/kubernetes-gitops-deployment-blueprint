import dlt
from dlt.sources.helpers import requests
import os

def chess_players_online_status():
    """Load the online status of chess.com players."""
    resp = requests.get(f"https://api.chess.com/pub/leaderboards")
    players = resp.json().get('live_blitz', [])[:100]
    
    for player in players:
        username = player['username']
        online_status_resp = requests.get(f"https://api.chess.com/pub/player/{username}/is-online")
        online_status = online_status_resp.json().get('online', False)
        player['is_online'] = online_status
        yield player

def chess_players_profiles():
    """Load chess.com player profiles."""
    resp = requests.get(f"https://api.chess.com/pub/leaderboards")
    players = resp.json().get('live_blitz', [])[:100]
    
    for player in players:
        username = player['username']
        profile_resp = requests.get(f"https://api.chess.com/pub/player/{username}")
        profile = profile_resp.json()
        yield profile

def chess_players_games():
    """Load recent chess.com games for top players."""
    resp = requests.get(f"https://api.chess.com/pub/leaderboards")
    players = resp.json().get('live_blitz', [])[:10]  # Limit to 10 players for demo
    
    for player in players:
        username = player['username']
        games_resp = requests.get(f"https://api.chess.com/pub/player/{username}/games/archives")
        archives = games_resp.json().get('archives', [])
        
        if archives:
            # Get the most recent month's games
            latest_archive = archives[-1]
            monthly_games_resp = requests.get(latest_archive)
            games = monthly_games_resp.json().get('games', [])
            
            for game in games[:5]:  # Limit to 5 games per player
                game['player_username'] = username
                yield game

def load_chess_data():
    """Main function to load chess data into Snowflake."""
    # Configure the pipeline
    pipeline = dlt.pipeline(
        pipeline_name="chess_data",
        destination="snowflake",
        dataset_name="chess_data"
    )
    
    # Load data
    info = pipeline.run(
        [
            chess_players_online_status().with_name("players_online_status"),
            chess_players_profiles().with_name("players_profiles"),
            chess_players_games().with_name("players_games")
        ]
    )
    
    print(f"Load completed! Loaded {info.load_package.count} resources")
    print(f"Tables: {', '.join(info.load_package.resources_created)}")
    return info

if __name__ == "__main__":
    load_chess_data()