# this obviously isnt very refined but works fine for what I needed to do

import requests
import json
import os
from bs4 import BeautifulSoup

def grabSong(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.content, "html.parser")

    songsList = soup.find("ul", class_="songs-list")
    songs = songsList.children 

    songElements = [song for song in songs if song != "\n" and song.name == "li"]


    songs = []

    for song in songElements:
        # print(song.prettify())
        songInfo = song.find_all("div")[2]

        songLength = songInfo.find_all("span")[1].text.strip()
        songLevel = songInfo.find_all("span")[0].text.strip()

        songAuthor = song.find("h4", class_="songs-list__artist").text
        songName = song.find("h5", class_="songs-list__name").text


        songNotes = song.find_all("div", class_="songs-list__sheet")[0].get_text(separator=' ')
        songNotes = songNotes.replace("\n", "")

        songImage = song.find_all("img")[0]["src"]

        songs.append({
            "name": songName,
            "author": songAuthor,
            "notes": songNotes,
            "length": songLength,
            "level": songLevel,
            "image": songImage,
        })

    return songs


homePage = requests.get("https://virtualpiano.net/music-sheets/")
homePageSoup = BeautifulSoup(homePage.content, "html.parser")

categoryElements = homePageSoup.find_all("h4", "pp-category__title")
categoreis = []

for category in categoryElements:
    if category.text != "":
        categoreis.append(category.text.strip("\n").strip(" ").lower().replace(" ", "-").replace("\u2013", "–"))


songs = {}

for category in categoreis:
    categorySongs = []

    for i in range(1, 9):
        url = f"https://virtualpiano.net/music-sheet-categories/{category}/?pages={i}"

        currentSongs = grabSong(url)
        categorySongs.extend(currentSongs)

        if len(currentSongs) == 0:
            break

        print("Grabbed", url, "with", len(currentSongs), "songs")

    songs[category] = categorySongs


# write songs to songs.json
try:
    os.remove("songs.json")
except:
    pass

with open("songs.json", "x") as f:
    json.dump(songs, f, indent=4)
